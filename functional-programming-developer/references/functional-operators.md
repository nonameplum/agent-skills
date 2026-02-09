# Functional Operators in Swift (map, flatMap, reduce, ...)

Swift’s standard library gives you a great functional vocabulary. The key is to use operators
to make **control flow explicit** and code **composable**.

This document focuses on:
- `map` / `flatMap` / `compactMap` / `filter`
- `reduce` / `reduce(into:)`
- using these operators with `Optional` and `Result`
- practical readability guidelines

---

## A mental model

Think “container” (Array/Optional/Result) + “value”.

- `map`: transform the value, keep the container
- `flatMap`: transform the value into a container, then flatten
- `reduce`: fold many values into one

---

## 1) map

### Arrays

```swift
let names = people.map { $0.name }
```

### Optionals

```swift
let maybeUser: User? = ...
let maybeName: String? = maybeUser.map { $0.name }
```

### Result

```swift
enum ParseError: Error { case invalid }

func parseInt(_ s: String) -> Result<Int, ParseError> {
    Int(s).map(Result.success) ?? .failure(.invalid)
}

let doubled = parseInt("21").map { $0 * 2 } // success(42)
```

**Rule of thumb:** `map` should be side-effect free. If you’re doing I/O inside `map`, pause.

---

## 2) flatMap

### Optional: chaining validations

```swift
func nonEmpty(_ s: String) -> String? { s.isEmpty ? nil : s }
func maxLen(_ n: Int) -> (String) -> String? { { $0.count <= n ? $0 : nil } }

let input: String? = " hello "
let validated = input
    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    .flatMap(nonEmpty)
    .flatMap(maxLen(10))
```

This reads as a pipeline: trim → require non-empty → require <=10.

### Array: one-to-many

```swift
let lines = ["a b", "c"]
let words = lines.flatMap { $0.split(separator: " ").map(String.init) }
// ["a", "b", "c"]
```

### Result: chaining computations that may fail

```swift
enum DomainError: Error { case notANumber, divisionByZero }

func parse(_ s: String) -> Result<Int, DomainError> {
    Int(s).map(Result.success) ?? .failure(.notANumber)
}

func reciprocal(_ x: Int) -> Result<Double, DomainError> {
    x == 0 ? .failure(.divisionByZero) : .success(1.0 / Double(x))
}

let r = parse("4").flatMap(reciprocal) // success(0.25)
```

---

## 3) compactMap

Transforms and drops nils:

```swift
let ids = ["A", "", "B"].compactMap { $0.isEmpty ? nil : $0 }
// ["A", "B"]
```

Common: parsing:

```swift
let uuids = raw.compactMap(UUID.init(uuidString:))
```

---

## 4) filter

Keeps items matching a predicate:

```swift
let adults = people.filter { $0.age >= 18 }
```

---

## 5) reduce and reduce(into:)

### reduce: fold into a value

```swift
let total = prices.reduce(0, +)
```

### reduce(into:): fold with a mutable accumulator (inside the function)

This is still “functional enough” because mutation is local.

```swift
let byId = people.reduce(into: [String: Person]()) { dict, p in
    dict[p.id] = p
}
```

### Reduce as “event replay” (state machines)

Reducers make this extremely powerful:

```swift
let finalState = events.reduce(initialState) { state, event in
    reduce(state, event).state
}
```

---

## 6) Practical readability tips

- Prefer **named helper functions** when closures get long.
- Use `flatMap` only when the closure returns a container (`Optional`, `Result`, arrays, etc.).
- Use `reduce(into:)` when you are building dictionaries/sets to keep it efficient and readable.
- Keep pipelines short; if it grows beyond 4–6 steps, consider extracting a dedicated function.

---

## 7) “effects live at the boundary”

Inside the functional core:
- use `map/flatMap/reduce` to transform values
- do not start network requests, DB writes, logs, etc.

At the shell:
- use `forEach` (or plain loops) to interpret effects.
