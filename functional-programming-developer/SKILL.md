---
name: functional-programming-developer
description: Functional architecture guidance for Swift (immutability, pure functions, reducers, DI via functions).
---

# Functional Architecture in Swift

Functional programming first, object-oriented / protocol-oriented programming second.

This skill guides how to design **domain and core logic** in Swift using
immutability, pure functions, and explicit effects.

---

## When to use

- Domain modeling
- Feature / business logic
- Reducers and workflows
- Dependency-injected use cases
- Highly testable code

---

## Architectural patterns

- Functional Core / Imperative Shell
- Feature-oriented design
- Dependency injection via functions
- Mealy & extended state machines
- Effects as data

---

## Functional techniques

- Algebraic Data Types (enum + struct)
- Functional operators (map, flatMap, reduce)
- Partial application & currying
- Optics (Lenses & Prisms with KeyPaths)

---

## Reading order

1. references/state-machines.md
2. references/functional-operators.md
3. references/algebraic-data-types.md
4. references/optics.md
5. references/dependency-injection-currying.md
6. references/dependency-injection-decision-table.md

---

## Dependency injection rules

- Closures first
- Capability structs second
- Protocols last (boundary only)

---

## Testing rules

- Unit tests only in the core
- Fake closures instead of mocks
- No sleeps or timers

---

## Summary

If it’s hard to test, simplify the design.
