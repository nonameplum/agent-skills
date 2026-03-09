# Reference Index

Quick navigation for type-driven design in Swift.

## Start here

| File | Purpose |
|------|---------|
| `modeling-playbook.md` | End-to-end process for turning business rules into types |
| `pattern-catalog.md` | Copyable patterns: strong types, witnesses, ADTs, illegal-state elimination |

## Quick links by problem

### "I need to..."

- **Understand type-driven foundations** -> `modeling-playbook.md` (Foundations)
- **Stop passing raw String/Int everywhere** -> `pattern-catalog.md` (Strong domain primitives)
- **Validate input once and carry proof forward** -> `pattern-catalog.md` (Validation-carrying types)
- **Restrict feature/workflow access by precondition** -> `pattern-catalog.md` (Witness pattern)
- **Model mutually exclusive states correctly** -> `modeling-playbook.md` (Product vs sum)
- **Remove impossible states from existing model** -> `pattern-catalog.md` (Illegal-state elimination)

### "I am seeing..."

- **Repeated guard checks in many layers** -> use validation-carrying types
- **Many booleans controlling behavior** -> model explicit sum types/witnesses
- **Two or more optionals that should represent one choice** -> replace with enum
- **Defensive logging for \"should never happen\" paths** -> remove illegal states from type model

## Deep source map (article series)

Use the article files for full reasoning and expanded examples.

| Topic | Source file |
|------|-------------|
| Fundamentals of type-driven code | `fundamentals-of-type-driven-code.md` |
| Type-safe validation | `type-safe-validation.md` |
| Witness pattern: type-safe access control | `witness-pattern-type-safe-access-control.md` |
| Domain modeling with types | `domain-modeling-with-types.md` |
| Making illegal states unrepresentable | `making-illegal-states-unrepresentable.md` |
