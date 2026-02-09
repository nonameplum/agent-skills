# Algebraic Data Types (ADTs) in Swift

Swift doesn’t label them “ADTs” in the language, but `enum` and `struct` are exactly
the building blocks you need.

- **Product types** (`struct`) = combine fields (A AND B AND C)
- **Sum types** (`enum`) = choose one case (A OR B OR C)

ADTs help you:
- represent domain invariants
- avoid invalid states
- make control flow explicit via pattern matching

---

## 1) Product types (struct)

```swift
struct Money: Equatable {
    let amount: Decimal
    let currency: String
}
```

You can add invariants via initializers:

```swift
struct PositiveInt: Equatable {
    let value: Int
    init?(_ value: Int) {
        guard value > 0 else { return nil }
        self.value = value
    }
}
```

---

## 2) Sum types (enum)

### Simple sum type

```swift
enum Sex { case male, female }
```

### Sum type with associated values

```swift
enum LoadState<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(message: String)
}
```

This replaces multiple booleans like `isLoading`, `hasError`, `data != nil` which can drift out of sync.

---

## 3) Modeling workflows as ADTs

Instead of:

```swift
struct Checkout {
    var step: Int
    var address: Address?
    var payment: Payment?
}
```

Prefer:

```swift
enum CheckoutState: Equatable {
    case cart(items: [String])
    case address(Address)
    case payment(Payment)
    case confirmation(orderID: String)
}
```

Now the type system expresses what data exists at each phase.

---

## 4) Hierarchical state (nested enums)

This is a great fit for large flows or reducer architectures:

```swift
enum AppState: Equatable {
    case loggedOut(LoggedOutState)
    case loggedIn(LoggedInState)

    struct LoggedOutState: Equatable {
        let email: String
        let error: String?
    }

    enum LoggedInState: Equatable {
        case home
        case details(id: String)
        case settings
    }
}
```

---

## 5) Pattern matching (the superpower)

```swift
func screenTitle(for state: LoadState<[Int]>) -> String {
    switch state {
    case .idle: return "Idle"
    case .loading: return "Loading…"
    case .loaded(let items): return "Loaded \(items.count) items"
    case .failed(let message): return "Error: \(message)"
    }
}
```

Pattern matching encourages you to handle every case.

---

## 6) Error modeling

Prefer domain errors as finite enums:

```swift
enum SaveError: Error, Equatable {
    case validationFailed(field: String)
    case databaseUnavailable
    case unauthorized
}
```

This is easier to test than opaque `NSError`s and helps avoid string comparisons.

---

## 7) Practical guidance

- If you have multiple interacting booleans, you probably want an enum.
- If a value must be valid, encode that in its type/initializer.
- Use associated values to carry data specific to a mode/state.
- Keep enums small; split large ones into nested enums or separate types.
