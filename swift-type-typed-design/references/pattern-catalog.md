# Pattern Catalog

Reusable type-driven patterns for Swift domain modeling.

## 1) Strong domain primitives

### Use when

- A raw primitive (`String`, `Int`, `Date`) has domain semantics.
- Mixing values would be a bug.

### Pattern

```swift
struct Email: Equatable, Hashable, Codable {
  let rawValue: String
}
```

Add behavior close to the type when needed.

## 2) Validation-carrying types (parse, do not validate)

### Use when

- Input must pass format/range/business checks.
- You currently re-check validity in multiple layers.

### Pattern

```swift
struct Password {
  let rawValue: String

  init?(_ rawValue: String) {
    guard rawValue.count >= 8 else { return nil }
    self.rawValue = rawValue
  }
}
```

Then require validated types downstream:

```swift
struct Credentials {
  let email: Email
  let password: Password
}
```

### Benefit

One-time validation at boundaries, compile-time safety in core logic.

## 3) Witness pattern for access control

### Use when

- Feature/workflow access depends on preconditions.
- Boolean checks are duplicated across many entry points.

### Pattern

```swift
struct AIAssistantEnabled {
  fileprivate init() {}
}

struct AIAssistantScreen {
  init(proof: AIAssistantEnabled) {}
}
```

Construct witness only at trusted boundary (for example decoding feature flags).

### Benefit

Code cannot compile unless proof is provided.

## 4) Replace optional soup with sum types

### Smell

```swift
struct PaymentMethod {
  let creditCard: CreditCard?
  let giftCard: GiftCard?
}
```

This allows invalid combinations (`nil,nil` and `some,some`).

### Pattern

```swift
enum PaymentMethod {
  case creditCard(CreditCard)
  case giftCard(GiftCard)
}
```

### Benefit

Illegal combinations become unrepresentable.

## 5) Illegal-state elimination by state-space reduction

### Use when

- You have "should never happen" branches.
- Business rules say a state is impossible, but type still allows it.

### Process

1. Expand compact model into explicit states.
2. Identify illegal case(s).
3. Redefine type without illegal case(s).
4. Simplify logic that handled impossible branches.

### Example

```swift
enum ContactMethods {
  case both(Email, PhoneNumber)
  case email(Email)
  case phoneNumber(PhoneNumber)
}
```

No `.none` case means at least one contact method is guaranteed.

## 6) Product and sum composition (ADT mindset)

Build complex models from small pieces:

- Product types (`struct`) for AND
- Sum types (`enum`) for OR
- Nest composition iteratively

This supports divide-and-conquer reasoning and cleaner APIs.

## Pattern selection guide

- Need semantic distinction -> strong primitive type
- Need one-time input proof -> validation-carrying type
- Need gated access by precondition -> witness
- Need one-of-many state -> enum sum type
- Need to remove impossible branch -> state-space reduction
