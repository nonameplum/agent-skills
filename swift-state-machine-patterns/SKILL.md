---
name: swift-state-machine-patterns
description: Build type-safe Swift state machines with enum states and action-based transitions. Use for lifecycle or protocol flows, reentrancy-sensitive operations, or async/concurrent workflows.
---

# Swift State Machine Patterns

## When to use
- Reentrancy-sensitive flows
- Protocol or lifecycle logic with strict transition rules
- Async streams or continuations that need cancellation safety
- Concurrency boundaries where invalid state must be unrepresentable

## Core rules
1) Model state as an enum with associated values. Each case carries only data
   valid in that state.
2) Keep the state machine as a value type (`struct`) with a private `state`.
3) Transition methods are pure: mutate state and return `Action` values.
4) Execute side effects outside the transition (and outside any lock).
5) Use strong types for events (enum or method parameters), actions, and
   identifiers. Avoid strings or boolean flags for state.
6) Prefer per-state structs for larger associated data to prevent accidental
   access to irrelevant fields.
7) Make invalid states unrepresentable by construction, not by runtime checks.

## Sub-state pattern
Model each state as a dedicated struct and store it as an associated value in
the enum. Capabilities are expressed as protocols and only adopted by states
that support them.

- Use one struct per state (`IdleState`, `ActiveState`, `QuiescingState`).
- Store only the fields valid in that state; move shared data into protocols.
- Use `init(from:)` to build the next state from the prior one and copy only
  relevant fields.
- Use capability protocols (e.g., `MaySendFrames`, `HasLocalSettings`) to keep
  helpers constrained to valid states.
- Optional: a `modifying` sentinel state can avoid CoW during transitions.

```swift
private struct IdleState: ConnectionStateWithRole, ConnectionStateWithConfiguration { /* ... */ }
private struct ActiveState: ConnectionStateWithRole, HasLocalSettings, HasRemoteSettings { /* ... */ }

private enum State {
  case idle(IdleState)
  case active(ActiveState)
}
```

## Usage pattern: driver + state machine
Embed the state machine inside a handler/coordinator that owns side effects.
The driver calls transition methods, applies effects, and decides
whether to forward/emit/drop inputs.

```swift
final class ProtocolHandler {
  private var stateMachine = ConnectionStateMachine()
  private var pendingEvents: [UserEvent] = []

  func receive(_ message: Message) {
    let result = stateMachine.receive(message)
    apply(effect: result.effect)

    switch result.result {
    case .succeed:
      forward(message)
    case .ignore:
      break
    case .connectionError(let error):
      handleConnectionError(error)
    case .streamError(let id, let error):
      handleStreamError(id, error)
    }

    flushPendingEvents()
  }

  func send(_ message: Message) {
    let result = stateMachine.send(message)
    apply(effect: result.effect)
    if case .succeed = result.result {
      write(message)
    } else {
      handleSendError(result.result)
    }
    flushPendingEvents()
  }
}
```

## Pattern: Method-per-event (SwiftNIO style)
Model events as dedicated mutating methods (send/receive). Each method switches
on state and returns a typed result or actions. This mirrors
`HTTP2ConnectionStateMachine` in SwiftNIO HTTP/2.

```swift
struct ConnectionStateMachine: Sendable {
  private enum State: Sendable {
    case idle(IdleState)
    case active(ActiveState)
    case quiescing(QuiescingState)
  }

  private struct IdleState: Sendable { }
  private struct ActiveState: Sendable { var streamID: Int }
  private struct QuiescingState: Sendable { var lastStreamID: Int }

  enum Action: Sendable {
    case sendPreface
    case closeStream(id: Int)
    case ignore
  }

  private var state: State = .idle(IdleState())

  mutating func receiveGoaway(lastStreamID: Int) -> [Action] {
    switch state {
    case .active(let data):
      state = .quiescing(QuiescingState(lastStreamID: lastStreamID))
      return lastStreamID < data.streamID ? [.closeStream(id: data.streamID)] : []
    default:
      return [.ignore]
    }
  }

  mutating func sendPreface() -> [Action] {
    switch state {
    case .idle:
      state = .active(ActiveState(streamID: 0))
      return [.sendPreface]
    default:
      return [.ignore]
    }
  }
}
```

Notes:
- For complex inputs, use a nested `Request` struct to keep method signatures small.
- Share repeated transitions in private helpers that mutate state and return actions.
- Expose read-only query helpers (e.g., `isConnected`) as computed properties.
- When each event returns a different shape, use per-event action enums
  (`NextAction`, `FinishAction`) instead of a single shared `Action`.
- Use a `.modifying` sentinel state to avoid CoW when updating associated data.
- Trap impossible transitions with `preconditionFailure` to keep invariants strict.
- Track suspended and cancelled sets with placeholder IDs for out-of-order cancel.
- Model terminal outcomes with a `Termination` enum (e.g., finished vs failed).
- Return optional actions when an event produces no side effects.

## Examples
### Channel-style rendezvous
```swift
struct ChannelStateMachine<Element: Sendable> {
  private struct SuspendedProducer: Hashable {
    let id: UInt64
    let continuation: UnsafeContinuation<Void, Never>?
    let element: Element?

    static func placeHolder(id: UInt64) -> SuspendedProducer {
      SuspendedProducer(id: id, continuation: nil, element: nil)
    }
  }

  private struct SuspendedConsumer: Hashable {
    let id: UInt64
    let continuation: UnsafeContinuation<Element?, any Error>?

    static func placeHolder(id: UInt64) -> SuspendedConsumer {
      SuspendedConsumer(id: id, continuation: nil)
    }
  }

  private enum State {
    case channeling(
      suspendedProducers: OrderedSet<SuspendedProducer>,
      cancelledProducers: Set<SuspendedProducer>,
      suspendedConsumers: OrderedSet<SuspendedConsumer>,
      cancelledConsumers: Set<SuspendedConsumer>
    )
    case terminated(Termination)
  }

  enum SendAction { case suspend; case resumeConsumer(UnsafeContinuation<Element?, any Error>?) }
  enum NextAction { case suspend; case resumeProducer(UnsafeContinuation<Void, Never>?, Result<Element?, Error>) }
  enum SendCancelledAction { case none; case resumeProducer(UnsafeContinuation<Void, Never>?) }

  mutating func send() -> SendAction { /* switch state */ }
  mutating func next() -> NextAction { /* switch state */ }
  mutating func sendCancelled(producerID: UInt64) -> SendCancelledAction { /* placeholders */ }
}
```

### CombineLatest upstream coordination
```swift
struct CombineLatestStateMachine<A: AsyncSequence, B: AsyncSequence, C: AsyncSequence?> {
  typealias DownstreamContinuation = UnsafeContinuation<Result<(A.Element, B.Element, C.Element?)?, Error>, Never>

  private enum State {
    struct Upstream<Element> {
      var continuation: UnsafeContinuation<Void, Error>?
      var element: Element?
      var isFinished: Bool
    }

    case initial(base1: A, base2: B, base3: C)
    case waitingForDemand(task: Task<Void, Never>, upstreams: (Upstream<A.Element>, Upstream<B.Element>, Upstream<C.Element>), buffer: Deque<(A.Element, B.Element, C.Element?)>)
    case combining(task: Task<Void, Never>, upstreams: (Upstream<A.Element>, Upstream<B.Element>, Upstream<C.Element>), downstreamContinuation: DownstreamContinuation, buffer: Deque<(A.Element, B.Element, C.Element?)>)
    case upstreamsFinished(buffer: Deque<(A.Element, B.Element, C.Element?)>)
    case upstreamThrew(error: Error)
    case finished
    case modifying
  }

  enum NextAction {
    case startTask(A, B, C)
    case resumeUpstreamContinuations([UnsafeContinuation<Void, Error>])
    case resumeContinuation(DownstreamContinuation, Result<(A.Element, B.Element, C.Element?)?, Error>)
    case resumeDownstreamContinuationWithNil(DownstreamContinuation)
  }

  mutating func next(for continuation: DownstreamContinuation) -> NextAction { /* switch state */ }
  mutating func upstreamFinished(baseIndex: Int) -> UpstreamFinishedAction? { /* switch state */ }
}
```

## Action-first transitions
- Determine actions inside the transition method.
- Perform side effects after the transition, outside locks or actor boundaries.
- This keeps the state machine deterministic and easy to test.

## Concurrency integration
- Protect the state with a `Mutex` (Synchronization) on iOS 18+ or `NSRecursiveLock` iOS 16+ or an actor.
- Extract any continuation or callback while holding the lock.
- Resume continuations outside the lock to avoid deadlocks.
- Use `withTaskCancellationHandler` when storing continuations so cancellation
  can drive a state transition.

## Testing guidance
- Test transitions directly by calling transition methods (e.g., `sendPreface`,
  `receiveGoaway`).
- Assert the resulting `Action` array and the new state.
- Avoid time-based tests; make them deterministic.

## Checklist
- [ ] State is an enum with associated values
- [ ] Each case only holds valid data for that state
- [ ] Per-state structs + capability protocols model valid operations
- [ ] Transition methods return actions, no side effects inside
- [ ] Strong types for event inputs and actions, no strings or bools
- [ ] Concurrency-safe: no user code or continuation resumes inside locks
- [ ] Driver applies effects, then forwards/emits inputs
- [ ] Tests cover each transition and invalid-transition behavior

## Anti-patterns
- Separate booleans for state (`isActive`, `isFinished`, `hasStarted`)
- Shared optional fields that are only valid in some phases
- Side effects performed inside transition switches
- Resuming continuations while holding a lock
- "State" represented as `String` or loosely-typed integers
