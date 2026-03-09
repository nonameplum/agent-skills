# Modeling Playbook

Use this workflow when designing or refactoring a domain model with types.

## Foundations

- Types are information containers.
- Runtime checks often indicate missing type-level information.
- Prefer proving invariants once at construction boundaries.
- Propagate proof via strong types, not comments or conventions.

## Domain modeling flow

1. Write key business rules in plain language.
2. Extract domain nouns (concepts) and verbs (workflows).
3. For each concept, decide:
   - Is this a primitive domain value? (`Email`, `Money`, `DateOfBirth`)
   - Is this a composition of values? (product type, AND)
   - Is this a choice between alternatives? (sum type, OR)
4. Mark invariants that must always hold.
5. Choose where invariants are established:
   - fallible initializer
   - throwing parser
   - decoding boundary
6. Update API signatures to consume refined types.
7. Remove now-redundant downstream checks.

## Product vs sum

### Product type (AND)

Use `struct` when all fields are required together.

```swift
struct Credentials {
  let email: Email
  let password: Password
}
```

### Sum type (OR)

Use `enum` when value can be exactly one alternative.

```swift
enum PaymentMethod {
  case creditCard(CreditCard)
  case giftCard(GiftCard)
}
```

If you currently use multiple optionals for a single choice, strongly consider replacing them with an enum.

## Choosing representation

1. Default to `struct`.
2. Use `enum` for states/choices.
3. Use `final class` only if reference semantics are required.
4. Use `actor` only when mutable shared state and concurrency are both required.

## Naming rules

- Use domain vocabulary, not storage/framework terms.
- Name by business meaning (`SavingsAccount`, not `SavingsAccountManagedObject`).
- Prefer explicit, searchable names over abbreviations.

## Identity modeling

Avoid generic primitive IDs across unrelated types.

```swift
struct Song: Identifiable {
  struct ID: Hashable { let rawValue: Int }
  let id: ID
}

struct Video: Identifiable {
  struct ID: Hashable { let rawValue: Int }
  let id: ID
}
```

This prevents accidental cross-entity ID comparisons.

## Refactor playbook for existing code

1. Find repeated checks (`if`, `guard`) for the same invariant.
2. Introduce one refined type that captures that invariant.
3. Convert one API boundary to require the refined type.
4. Migrate one call chain end-to-end.
5. Repeat for the next invariant.

Keep changes small and reviewable.
