# Dependency Injection via Functions, Partial Application, and Currying (Swift)

This document shows how to do DI without protocols by leaning on:
- **closure injection**
- **partial application** (fix dependencies first)
- **currying** (build behavior step by step)
- **capability structs** (group dependencies)

Goal: keep the functional core explicit and tests trivial.

---

## 1) Closure injection: the baseline

A use case is an orchestration function that requires side-effect capabilities:

```swift
@concurrent
func savePerson(
    person: Person,
    save: sending (Person) async throws -> Void,
    onError: sending (Person, Error) async -> Void
) async {
    do { try await save(person) }
    catch { await onError(person, error) }
}
```

Tests pass closure fakes.

---

## 2) Partial application: build a reusable use case

Given the function above, specialize it by fixing the dependencies:

```swift
func makeSavePerson(
    save: @escaping (Person) async throws -> Void,
    onError: @escaping (Person, Error) async -> Void
) -> (Person) async -> Void {
    { person in
        await savePerson(person: person, save: save, onError: onError)
    }
}
```

### App boundary assembly

```swift
let saveUseCase = makeSavePerson(
    save: { try await DataAccessObject().save(entity: $0) },
    onError: { p, e in print("Save failed for \(p.id): \(e)") }
)
```

### Test assembly

```swift
import Testing

@Test func saveCallsSave() async {
    var saved: Person? = nil
    let uc = makeSavePerson(
        save: { saved = $0 },
        onError: { _, _ in }
    )

    let p = Person(id: "1", name: "A", lastName: "B", sex: .male)
    await uc(p)

    #expect(saved == p)
}
```

---

## 3) Dependency-first APIs (makes partial application natural)

If you design functions with dependencies first and input last:

```swift
func makeGreeter(
    now: @escaping () -> Date,
    format: @escaping (String) -> String
) -> (String) -> String {
    { name in
        format("Hello \(name) at \(now())")
    }
}
```

This style makes DI feel like configuration.

---

## 4) Currying in Swift (manual)

Swift doesn’t auto-curry multi-arg functions, but you can write small helpers.

### Curry helpers

```swift
func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    { a in { b in f(a, b) } }
}

func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    { a in { b in { c in f(a, b, c) } } }
}
```

### Example: specialized logger

```swift
func formatLog(prefix: String, id: String, message: String) -> String {
    "[\(prefix)][\(id)] \(message)"
}

let c = curry(formatLog)
let info = c("INFO")     // (String) -> (String) -> String
let info42 = info("42")  // (String) -> String

let line = info42("Hello") // "[INFO][42] Hello"
```

### Currying for DI (explicit pipelines)

```swift
func deletePersonCurried(
    isAuthorized: @escaping () async -> Bool
) -> (@escaping (Person) async throws -> Void)
 -> (@escaping (Person, Error) async -> Void)
 -> (Person) async -> Void {

    { delete in
        { onError in
            { person in
                guard await isAuthorized() else { return }
                do { try await delete(person) }
                catch { await onError(person, error) }
            }
        }
    }
}
```

Assembly:

```swift
let deleteUseCase =
    deletePersonCurried(isAuthorized: { await Permissions().hasPermissions() })
    ({ try await DataAccessObject().delete(entity: $0) })
    ({ p, e in print("Delete failed \(p.id): \(e)") })
```

---

## 5) Capability structs (scale point)

When dependency lists get noisy, group them:

```swift
struct PersonStore {
    var save: (Person) async throws -> Void
    var delete: (Person) async throws -> Void
}

struct PermissionsClient {
    var hasPermissions: () async -> Bool
}
```

Use case:

```swift
func makeDeletePerson(
    permissions: PermissionsClient,
    store: PersonStore,
    onError: @escaping (Person, Error) async -> Void
) -> (Person) async -> Void {
    { person in
        guard await permissions.hasPermissions() else { return }
        do { try await store.delete(person) }
        catch { await onError(person, error) }
    }
}
```

In tests, override only what you need:

```swift
let store = PersonStore(
    save: { _ in },
    delete: { _ in throw SaveError.dbError }
)
```

---

## 6) Protocols (boundary tool)

Protocols are useful when you need:
- runtime polymorphism across modules
- reference semantics / identity
- integration constraints (framework expects OO patterns)

But you can still adapt protocols to closures before passing into the core:

```swift
protocol AnalyticsTracking {
    func track(_ name: String)
}

func makeTrack(analytics: AnalyticsTracking) -> (String) -> Void {
    { analytics.track($0) }
}
```

Now your core depends on `(String) -> Void`, not on `AnalyticsTracking`.

---

## 7) Guidance

- Prefer closures for small dependency surfaces.
- Use capability structs as the primary scaling mechanism.
- Keep protocols at the shell; adapt to functions for the core.
- Design dependency-first functions to make partial application easy.
