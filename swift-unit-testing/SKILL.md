# Swift Unit Testing: Agent Playbook

> **Audience:** LLM coding agents generating or modifying Swift unit tests
> **Framework:** Swift Testing (`import Testing`)

---

## Quick Reference (Read First)

| Requirement | Rule |
|-------------|------|
| Framework | Swift Testing (`@Test`, `#expect`, `#require`) — never XCTest for new tests |
| Test structure | AAA pattern with `// Arrange`, `// Act`, `// Assert` comments |
| Naming | `operation_condition_expectedResult` — no "test" prefix, no "should" |
| SUT variable | Always `sut` — never `store`, `context`, `container` for the main subject |
| Helpers | `make...` prefix — placed at bottom of file |
| Dependencies | Fakes/stubs via closures — avoid assertion-heavy mocks |
| Isolation | Deterministic, in-memory, no network, no disk, no real time |

---

## Non-Negotiables (NEVER Violate)

1. **NEVER use XCTest** for new tests — use Swift Testing exclusively
2. **NEVER write flaky tests** — no network, no real filesystem, no `Date()`, no `UUID()`
3. **NEVER combine multiple behaviors** in one test — split into separate `@Test` functions
4. **NEVER skip AAA comments** — every test must have `// Arrange`, `// Act`, `// Assert`
5. **NEVER use magic strings/numbers** — use named constants or fixture values
6. **NEVER guess CLI commands** — insert `> TODO:` marker if unknown
7. **NEVER modify unrelated code** — touch only what the task requires
8. **NEVER invent abstractions** — follow existing patterns in nearest neighbor tests

---

## Workflow (Execute Every Time)

### Step 1: Clarify Intent

Before writing any code, answer:

- What **single behavior** is being verified?
- What is the exact **given / when / then**?
- What is **out of scope**?

If unclear, **stop and ask**.

### Step 2: Locate Insertion Point

```
Tests/
├── {ModuleName}Tests/           ← SwiftPM default (mirror source hierarchy)
│   ├── Test{Subject}.swift
│   └── TestSupport/
│       └── fakes, helpers
└── {AppName}Tests/              ← Xcode test target
    └── Test{Subject}.swift
```

- Find the closest existing test file under `Tests/` or the test target folder
- If no test file exists, create one following naming convention
- Mirror the source hierarchy if the repo already does so
- Check nearest neighbor tests for patterns before inventing structure

### Step 3: Select Testing Approach

| Subject Type | Approach |
|--------------|----------|
| Pure function/utility | Direct call + `#expect` |
| SwiftData schema (if used) | In-memory container + `@Suite(.serialized)` |
| SwiftData migration (if used) | File-based container (only when testing cross-instance migration) |

### Step 4: Write the Test

Follow this exact structure:

```swift
import Testing
@testable import {ModuleName}

struct Test{Subject} {
  @Test
  func operation_condition_expectedResult() throws {
    // Arrange
    let sut = makeSut()

    // Act
    let result = sut.performOperation()

    // Assert
    #expect(result == expectedValue)
  }

  // MARK: - Helpers

  private func makeSut() -> Subject {
    Subject()
  }
}
```

### Step 5: Verify

- Run only the relevant test(s) — not the full suite
- Confirm deterministic: run twice, same result
- Check for linter errors

---

## Framework: Swift Testing

### Import Statement

```swift
import Testing
@testable import {AppTarget}

### Test Container

Prefer `struct`. Use `class` only when `deinit` cleanup is required.

```swift
struct TestUserService {
  @Test
  func fetchUser_validId_returnsUser() async throws {
    // ...
  }
}
```

### Assertions

| Use Case | Macro |
|----------|-------|
| Boolean/equality | `#expect(value == expected)` |
| Unwrap optional | `let x = try #require(optionalValue)` |
| Verify throws | `#expect(throws: SomeError.self) { try operation() }` |
| Verify no throw | `#expect(throws: Never.self) { try operation() }` |

**NEVER use XCTest assertions** (`XCTAssert*`) in Swift Testing files.

### Display Names

Use `@Test("...")` only when the function name cannot be expressive:

```swift
// ✅ Display name adds value
@Test("V0→V1 migration preserves user recordings")
func migrateFromV0_preservesRecordings() throws { }

// ❌ Display name duplicates function name — remove it
@Test("Save user persists to store")
func saveUser_persistsToStore() throws { }
```

---

## Naming Conventions

### File Names

| Pattern | Example |
|---------|---------|
| `Test{Subject}.swift` | `TestMigrationPlan.swift` |
| `Test{Subject}+{Aspect}.swift` | `TestModelContainer+Migration.swift` |

### Test Function Names

Pattern: `operation_condition_expectedResult`

```swift
// ✅ Good
func createContainer_withUnversionedStore_migratesSuccessfully()
func fetchUser_nonExistentId_returnsNil()
func onAppear_setsInitialFocus()

// ❌ Bad — verbose, uses "should", uses "test" prefix
func testThatWhenUserIsSavedThenItShouldBeFetched()
```

### Variable Names

```swift
// ✅ Always use `sut` for system under test
let sut = makeSut()
var sut = TestStore(...)

// ❌ Never use inconsistent names for SUT
let store = makeSut()    // Bad
let context = ...        // Bad
```

---

## AAA Pattern (Required)

Every test MUST have these three comments:

```swift
@Test
func operation_succeeds() throws {
  // Arrange
  let sut = makeSut()
  let input = Input.mock()

  // Act
  let result = sut.process(input)

  // Assert
  #expect(result.isSuccess)
}
```

---

## Async Coordination: Gate

Use a lightweight `Gate` to coordinate async tasks deterministically. This
avoids flaky timing with `Task.sleep` or `Task.yield`.

```swift
let gate = Gate()

let task = Task {
  // Act
  await gate.enter()
  // Continue after the signal
}

// Arrange any prerequisites, then signal the task to proceed
gate.open()

_ = await task.value
```

```swift
import Synchronization

public struct Gate: Sendable {
  private enum State {
    case closed
    case open
    case pending(UnsafeContinuation<Void, Never>)
  }

  private let state = ManagedCriticalState(State.closed)

  public init() {}

  public func open() {
    state.withCriticalRegion { state -> UnsafeContinuation<Void, Never>? in
      switch state {
      case .closed:
        state = .open
        return nil
      case .open:
        return nil
      case .pending(let continuation):
        state = .closed
        return continuation
      }
    }?.resume()
  }

  public func enter() async {
    var other: UnsafeContinuation<Void, Never>?
    await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
      state.withCriticalRegion { state -> UnsafeContinuation<Void, Never>? in
        switch state {
        case .closed:
          state = .pending(continuation)
          return nil
        case .open:
          state = .closed
          return continuation
        case .pending(let existing):
          other = existing
          state = .pending(continuation)
          return nil
        }
      }?.resume()
    }
    other?.resume()
  }
}
```

**About `ManagedCriticalState`:**
It is a lightweight lock from `Synchronization` that protects a tiny critical
section. Keep the locked region small and never resume continuations inside it.
If you cannot use `ManagedCriticalState`, use a `Mutex` or an actor with the
same extract-then-resume pattern.

**Guidelines:**
- Use a `Gate` per synchronization point.
- Prefer explicit `enter()`/`open()` over time-based delays.

**Reference:**
- AsyncAlgorithms [Gate.swift](https://github.com/apple/swift-async-algorithms/blob/103f5e5beab0896f7ec5e85d9383ce0f026065f5/Tests/AsyncAlgorithmsTests/Support/Gate.swift#L14)

---

## Memory Leak Detection Trait

Use a test trait to verify tracked objects are deallocated after each test.
This catches retain cycles without relying on timing.

```swift
import Testing

@Suite(.checkMemoryLeaks)
struct MyTests {
  @Test
  func myTest() async throws {
    let sut = MyClass()

    // ... exercise sut ...

    trackForMemoryLeaks(sut)
  }
}
```

**Implementation (drop into test target):**

```swift
import Testing

public struct MemoryLeakCheckTrait: TestTrait, SuiteTrait, TestScoping {
  public init() {}

  public var isRecursive: Bool { true }

  public func provideScope(
    for test: Test,
    testCase: Test.Case?,
    performing function: @concurrent @Sendable () async throws -> Void
  ) async throws {
    let tracker = LeakTracker()
    try await LeakTracker.$current.withValue(tracker) {
      try await function()
    }
    try tracker.verifyNoLeaks()
  }
}

public extension Trait where Self == MemoryLeakCheckTrait {
  static var checkMemoryLeaks: Self { Self() }
}

private final class LeakTracker: @unchecked Sendable {
  @TaskLocal static var current = LeakTracker()

  private var trackedInstances: [(closure: () -> AnyObject?, sourceLocation: SourceLocation)] = []

  func track<T: AnyObject>(_ instance: T, sourceLocation: SourceLocation) {
    trackedInstances.append(({ [weak instance] in instance }, sourceLocation))
  }

  func verifyNoLeaks() throws {
    for tracked in trackedInstances {
      #expect(
        tracked.closure() == nil,
        "Instance should have been deallocated. Potential memory leak.",
        sourceLocation: tracked.sourceLocation
      )
    }
    trackedInstances.removeAll()
  }
}

public func trackForMemoryLeaks(
  _ instance: AnyObject,
  fileID: String = #fileID,
  filePath: String = #filePath,
  line: Int = #line,
  column: Int = #column
) {
  LeakTracker.current.track(
    instance,
    sourceLocation: SourceLocation(
      fileID: fileID,
      filePath: filePath,
      line: line,
      column: column
    )
  )
}
```

---

### Helper Patterns

These patterns apply to **all tests** — plain services, SwiftData, utilities, etc.

#### Single Return Value

When the test only needs the SUT:

```swift
// Plain service
private func makeSut() -> UserService {
  UserService(repository: MockUserRepository())
}

```

#### Tuple Return

When you need SUT + collaborators you want to inspect/verify, return a labeled tuple:

```swift
@Test
func fetchUser_callsRepository() async throws {
  // Arrange
  let (sut, repository) = makeSut()

  // Act
  _ = try await sut.fetchUser(id: "123")

  // Assert
  #expect(repository.fetchCalledWith == "123")
}

// MARK: - Helpers

private func makeSut() -> (
  sut: UserService,
  repository: MockUserRepository
) {
  let repository = MockUserRepository()
  let service = UserService(repository: repository)
  return (sut: service, repository: repository)
}
```

#### TestEnvironment Struct

When the tuple becomes unwieldy (typically 3+ items, but use judgment based on readability), switch to a `TestEnvironment` struct.

**Naming rules:**
- Struct name: `TestEnvironment` — never `SystemUnderTest`
- Main subject property: `sut` — maintains consistency across all patterns
- Variable name: `env` — short and readable
- Access pattern: `env.sut` reads as "the environment's system under test"

```swift
@Test
func sync_updatesAllSystems() async throws {
  // Arrange
  let env = makeSut()

  // Act
  try await env.sut.performSync()

  // Assert
  #expect(env.repository.saveCalled)
  #expect(env.cache.invalidateCalled)
  #expect(env.analytics.trackedEvents.contains(.syncCompleted))
}

// MARK: - Helpers

private struct TestEnvironment {
  let sut: SyncService
  let repository: MockRepository
  let cache: MockCacheManager
  let analytics: MockAnalyticsClient
}

private func makeSut() -> TestEnvironment {
  let repository = MockRepository()
  let cache = MockCacheManager()
  let analytics = MockAnalyticsClient()

  let sut = SyncService(
    repository: repository,
    cache: cache,
    analytics: analytics
  )

  return TestEnvironment(
    sut: sut,
    repository: repository,
    cache: cache,
    analytics: analytics
  )
}
```

**Key points:**
- Use tuple when it remains readable (often 2 items, sometimes 3)
- Switch to `TestEnvironment` when tuple becomes awkward to destructure or read
- Always name the main subject `sut` — consistent across single, tuple, and struct patterns
- Access pattern: `env.sut.doSomething()`, `env.repository.fetchCalled`
- Keep `makeSut()` as the factory name for consistency

---

## SwiftData Testing

### Required: Serial Execution

SwiftData has process-level global state. All SwiftData tests MUST run serially:

```swift
@Suite(.serialized)
final class TestSchemaMigration: SwiftDataTests {
  // ...
}
```

### Container Types

| Purpose | Container Type |
|---------|----------------|
| Schema compatibility | In-memory |
| Migration correctness | File-based (with cleanup) |

```swift
// In-memory (default)
private func makeInMemoryContainer() throws -> ModelContainer {
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  return try ModelContainer(for: User.self, configurations: [config])
}
```

---

## Fixtures and Mocks

### Fixture Pattern

Use version-agnostic mocks on current schema types:

```swift
// ✅ Good — version-agnostic
extension User {
  static func mock(
    id: String = TestValues.userID,
    email: String = TestValues.userEmail
  ) -> User {
    User(id: id, email: email)
  }
}

private enum TestValues {
  static let userID = "user-123"
  static let userEmail = "user@example.com"
}

// ❌ Bad — tied to schema version
extension SchemaV1.User {
  static func mock() -> SchemaV1.User { }
}
```

### Fakes Over Mocks

Prefer closures that return deterministic values:

```swift
// ✅ Fake — simple, deterministic
$0.apiClient.fetchUser = { _ in .mock() }

// ❌ Mock — complex, assertion-heavy
let mock = MockAPIClient()
mock.verify(.fetchUser, calledWith: userId)
```

---

## Helpers

### Placement

Always at the **bottom** of the test file, after all `@Test` functions.

### Naming

Always `make...` prefix:

```swift
private func makeSut() -> Subject { }
private func makeInMemoryContainer() throws -> ModelContainer { }
private func makeUser(email: String = "a@b.com") -> User { }
```

### Keep Minimal

Only expose parameters that tests commonly override:

```swift
// ✅ Good — configurable where needed
private func makeSut(
  isLoading: Bool = false,
  configure: ((inout State) -> Void)? = nil
) -> TestStore { }

// ❌ Bad — too many parameters
private func makeSut(
  isLoading: Bool = false,
  hasError: Bool = false,
  userId: String = "",
  userName: String = "",
  // ... 10 more parameters
) -> TestStore { }
```

---

## Anti-Patterns (What NOT to Do)

| ❌ Don't | ✅ Do Instead |
|----------|---------------|
| `testThatWhenUserIsSavedThenItCanBeFetched` | `saveUser_canBeFetched` |
| Magic strings: `#expect(error.code == "E001")` | Named constant: `#expect(error.code == ErrorCode.notFound)` |
| Large setup in each test | Extract to `makeSut()` helper |
| Multiple behaviors per test | One test per behavior |
| XCTest in Swift Testing files | `#expect`, `#require` |
| `setUp` / `tearDown` | `init` / `deinit` |
| `let store = makeSut()` | `let sut = makeSut()` |
| `// Act & Assert` combined comment | Separate `// Act` and `// Assert` |

---

## Checklist Before Committing

- [ ] Uses Swift Testing (`import Testing`, `@Test`, `#expect`)
- [ ] Function name follows `operation_condition_expectedResult`
- [ ] Has `// Arrange`, `// Act`, `// Assert` comments
- [ ] Uses `sut` for system under test
- [ ] One behavior per test
- [ ] No shared mutable state between tests
- [ ] Deterministic (no network, no real disk, no real time)
- [ ] Helpers use `make...` naming and are at bottom of file
- [ ] No magic strings/numbers
- [ ] Runs in < 100ms
