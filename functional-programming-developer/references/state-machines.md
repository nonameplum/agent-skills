# Mealy & Extended State Machines in Swift
## Reducers, Effects, and AsyncSequence-based State Streams

A state machine can be viewed not only as a pure transition function, but also as a
**stream of states evolving over time**.

This document extends the reducer-based approach with **AsyncSequence** examples,
showing how to model a state machine as a stream of states and effects.

---

## 1) Recap: reducer as a Mealy machine

A reducer models behavior as:

```
(State, Event) -> (State, [Effect])
```

```swift
struct Transition<State, Effect> {
    let state: State
    let effects: [Effect]
}

typealias Reducer<State, Event, Effect> =
    (State, Event) -> Transition<State, Effect>
```

This function is **pure** and synchronous.

---

## 2) From reducer to stream of states

Conceptually:

> **A state machine is a stream of states produced by a stream of events.**

```
EventStream ──► Reducer ──► StateStream
```

In Swift Concurrency, this maps naturally to `AsyncSequence`.

---

## 3) Example domain: Counter

```swift
struct CounterState: Equatable {
    let value: Int
}

enum CounterEvent: Equatable {
    case increment
    case decrement
}

enum CounterEffect: Equatable {
    case log(String)
}
```

Reducer:

```swift
let counterReduce: Reducer<CounterState, CounterEvent, CounterEffect> = { state, event in
    switch event {
    case .increment:
        let next = CounterState(value: state.value + 1)
        return .init(state: next, effects: [.log("inc")])

    case .decrement:
        let next = CounterState(value: state.value - 1)
        return .init(state: next, effects: [.log("dec")])
    }
}
```

---

## 4) Async event source

Events often come from:
- user input
- network callbacks
- timers
- child effect completions

A simple async event stream can be built with `AsyncStream`.

```swift
func counterEvents() -> AsyncStream<CounterEvent> {
    AsyncStream { continuation in
        continuation.yield(.increment)
        continuation.yield(.increment)
        continuation.yield(.decrement)
        continuation.finish()
    }
}
```

---

## 5) Folding an AsyncSequence into a State stream

We now want to turn:

```
AsyncSequence<Event> → AsyncSequence<State>
```

### Basic runner (state-only)

```swift
func states<State, Event, Effect>(
    initial: State,
    events: some AsyncSequence<Event, Never>,
    reduce: @escaping Reducer<State, Event, Effect>
) -> AsyncStream<State> {

    AsyncStream { continuation in
        Task {
            var state = initial
            continuation.yield(state) // initial state

            for await event in events {
                let transition = reduce(state, event)
                state = transition.state
                continuation.yield(state)
            }

            continuation.finish()
        }
    }
}
```

Usage:

```swift
let stateStream = states(
    initial: CounterState(value: 0),
    events: counterEvents(),
    reduce: counterReduce
)

for await state in stateStream {
    print("state =", state.value)
}
```

This prints:

```
state = 0
state = 1
state = 2
state = 1
```

---

## 6) Streaming both states and effects

Often you want both:
- a stream of states (for UI)
- a stream of effects (for side effects)

### Model output as a value

```swift
struct Step<State, Effect> {
    let state: State
    let effects: [Effect]
}
```

### Async stream of steps

```swift
func steps<State, Event, Effect>(
    initial: State,
    events: some AsyncSequence<Event, Never>,
    reduce: @escaping Reducer<State, Event, Effect>
) -> AsyncStream<Step<State, Effect>> {

    AsyncStream { continuation in
        Task {
            var state = initial
            continuation.yield(.init(state: state, effects: []))

            for await event in events {
                let transition = reduce(state, event)
                state = transition.state
                continuation.yield(.init(state: state, effects: transition.effects))
            }

            continuation.finish()
        }
    }
}
```

Usage:

```swift
let stepStream = steps(
    initial: CounterState(value: 0),
    events: counterEvents(),
    reduce: counterReduce
)

for await step in stepStream {
    print("state =", step.state.value, "effects =", step.effects)
}
```

---

## 7) Interpreting effects asynchronously

Effects are interpreted in the **imperative shell**.

```swift
struct CounterEnvironment {
    var log: (String) async -> Void
}

func interpret(effect: CounterEffect, env: CounterEnvironment) async {
    switch effect {
    case .log(let msg):
        await env.log(msg)
    }
}
```

### Wiring it together

```swift
let env = CounterEnvironment(log: { print("LOG:", $0) })

for await step in stepStream {
    for effect in step.effects {
        await interpret(effect: effect, env: env)
    }
}
```

---

## 8) Feedback loop: effects producing new events

Many effects produce **new events** (e.g. network responses).

This creates a feedback loop:

```
Event ─► Reducer ─► Effect ─► Async work ─► Event
```

### Pattern: event continuation

```swift
func makeEventStream() -> (AsyncStream<CounterEvent>, AsyncStream<CounterEvent>.Continuation) {
    var continuation: AsyncStream<CounterEvent>.Continuation!
    let stream = AsyncStream<CounterEvent> {
        continuation = $0
    }
    return (stream, continuation)
}
```

Example usage:

```swift
let (events, emit) = makeEventStream()

Task {
    emit.yield(.increment)
    emit.yield(.increment)
}

let stepStream = steps(
    initial: CounterState(value: 0),
    events: events,
    reduce: counterReduce
)

Task {
    for await step in stepStream {
        print("state =", step.state.value)
    }
}
```

Effects can call `emit.yield(...)` to feed results back into the system.

---

## 9) Extended state machines as streams

Extended state machines work the same way:
- `State` becomes a `(mode + context)` struct
- the reducer is unchanged
- the output is still a stream of states

This makes them ideal for:
- UI state binding
- SwiftUI `.task` / `.onReceive`
- replayable tests

---

## 10) Testing AsyncSequence-based state machines

Because reducers are pure, you usually test:
- reducer logic synchronously
- stream wiring separately

### Example: collecting states

```swift
func collectStates<S: Equatable>(
    from stream: some AsyncSequence<S, Never>
) async -> [S] {
    var result: [S] = []
    for await s in stream {
        result.append(s)
    }
    return result
}
```

Test:

```swift
@Test
func counterStateStreamProducesExpectedStates() async {
    let events = AsyncStream<CounterEvent> {
        $0.yield(.increment)
        $0.yield(.increment)
        $0.finish()
    }

    let stream = states(
        initial: CounterState(value: 0),
        events: events,
        reduce: counterReduce
    )

    let collected = await collectStates(from: stream)

    #expect(collected.map(\.value) == [0, 1, 2])
}
```

---

## 11) Mental model

- Reducer = **pure transition**
- AsyncSequence = **time**
- State machine = **stream of states**
- Effects = **instructions crossing the boundary**

This model scales cleanly from:
- simple counters
- to UI flows
- to complex async workflows

---

## 7) AsyncSequence: “a state machine is a stream of states”

For UI and reactive flows, it’s often useful to treat a reducer-driven state machine as a **stream**:

- input: an `AsyncSequence` of `Event`s
- output: an `AsyncSequence` of `State`s (and optionally `Effect`s)

There are a few practical shapes depending on what you want to expose.

### A) Stream of states (pure replay, no effects)

This is the simplest definition of “a state machine is a stream of states”:

```swift
/// Turns a stream of events into a stream of states by applying a pure reducer.
func states<State, Event>(
    initial: State,
    events: some AsyncSequence<Event>,
    reduce: @escaping (State, Event) -> State
) -> AsyncStream<State> {
    AsyncStream { continuation in
        Task {
            var state = initial
            continuation.yield(state)

            for await event in events {
                state = reduce(state, event)
                continuation.yield(state)
            }

            continuation.finish()
        }
    }
}
```

Example:

```swift
func counterReduceStateOnly(_ state: CounterState, _ event: CounterEvent) -> CounterState {
    counterReduce(state, event).state
}

let stateStream = states(
    initial: CounterState(value: 0),
    events: eventStream,
    reduce: counterReduceStateOnly
)
```

### B) Stream of transitions (state + effects)

Often you want effects too.

```swift
func transitions<State, Event, Effect>(
    initial: State,
    events: some AsyncSequence<Event>,
    reduce: @escaping (State, Event) -> Transition<State, Effect>
) -> AsyncStream<Transition<State, Effect>> {
    AsyncStream { continuation in
        Task {
            var state = initial
            continuation.yield(.init(state: state, effects: []))

            for await event in events {
                let t = reduce(state, event)
                state = t.state
                continuation.yield(t)
            }

            continuation.finish()
        }
    }
}
```

Now you can observe states *and* interpret effects at the boundary:

```swift
let stream = transitions(initial: CounterState(value: 0), events: eventStream, reduce: counterReduce)

Task {
    for await t in stream {
        // State observation (UI)
        render(t.state)

        // Effects interpretation (shell)
        for fx in t.effects { await interpret(effect: fx, env: env) }
    }
}
```

### C) “Feedback loop”: effects can produce more events (async)

A common architecture pattern:
1) reducer emits `Effect`
2) the shell interprets effects and may emit new `Event`s (e.g. network responses)
3) those events feed back into the reducer

Below is a minimal feedback runner using an `AsyncStream<Event>` as the event bus.

```swift
/// Interprets an effect and optionally emits follow-up events (e.g. network callbacks).
typealias EffectInterpreter<Event, Effect> = (Effect) async -> Event?

func feedbackLoop<State, Event, Effect>(
    initial: State,
    reduce: @escaping (State, Event) -> Transition<State, Effect>,
    interpret: @escaping EffectInterpreter<Event, Effect>
) -> (events: AsyncStream<Event>, send: (Event) -> Void, states: AsyncStream<State>) {

    var continuation: AsyncStream<Event>.Continuation!
    let events = AsyncStream<Event> { continuation = $0 }

    let states = AsyncStream<State> { stateCont in
        Task {
            var state = initial
            stateCont.yield(state)

            for await event in events {
                let t = reduce(state, event)
                state = t.state
                stateCont.yield(state)

                // interpret effects sequentially (simple and deterministic)
                for fx in t.effects {
                    if let followUp = await interpret(fx) {
                        continuation.yield(followUp)
                    }
                }
            }

            stateCont.finish()
        }
    }

    let send: (Event) -> Void = { continuation.yield($0) }
    return (events: events, send: send, states: states)
}
```

#### Example: Auth flow with async login

Effects include `.performLogin`. Interpreting it triggers async work and emits a follow-up event.

```swift
enum AuthEffect: Equatable {
    case performLogin(username: String, password: String)
    case clearSession
    case toast(String)
}

func interpretAuthEffect(_ fx: AuthEffect) async -> AuthEvent? {
    switch fx {
    case .performLogin(let u, let p):
        do {
            let token = try await apiLogin(username: u, password: p)
            return .loginSucceeded(token: token)
        } catch {
            return .loginFailed(message: "Login failed")
        }

    case .clearSession:
        await sessionStore.clear()
        return nil

    case .toast:
        return nil
    }
}
```

Run:

```swift
let loop = feedbackLoop(
    initial: AuthModel(state: .loggedOut, context: .init(username: "", token: nil, message: nil)),
    reduce: authReduce,
    interpret: interpretAuthEffect
)

// UI: send events
loop.send(.submit(username: "a", password: "b"))

// UI: observe state stream
Task {
    for await s in loop.states {
        renderAuth(s)
    }
}
```

### D) Concurrency and ordering notes

- The examples above interpret effects **sequentially** to keep ordering deterministic.
- If you need parallelism, you can run effects concurrently, but you must decide:
  - ordering of follow-up events
  - cancellation semantics
  - state consistency under concurrent event injection

A pragmatic default: sequential interpretation + explicit cancellation events when needed.

### E) Cancellation (minimal pattern)

Add a cancellation token in state, or model it as an effect.

Example effect:

```swift
enum Effect {
    case startRequest(id: UUID)
    case cancelRequest(id: UUID)
}
```

Your interpreter owns the Task map keyed by `id` and cancels on demand.

---

## 8) Takeaway

- A reducer is a Mealy machine.
- An `AsyncSequence<Event>` + reducer gives you an `AsyncSequence<State>`: a stream of states.
- Effects make it practical: interpret effects to do async work and feed results back as events.
