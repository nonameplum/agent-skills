---
name: swift-type-typed-design
description: Type-driven domain modeling techniques for Swift using proper domain types, validation-carrying types, witness-based access control, and illegal-state elimination. Use when designing domain models, replacing primitive obsession, modeling workflows with enums/structs, adding compile-time guarantees, or discussing parse-dont-validate and making illegal states unrepresentable.
---

# Swift Type-Driven Design

Use this skill to design Swift models that encode business rules in types so invalid states are hard or impossible to represent.

## Agent behavior contract

1. Model domain concepts first, implementation details second.
2. Prefer value semantics (`struct`, `enum`) unless reference identity is required.
3. Replace primitive obsession with strong domain types only when it captures an essential invariant.
4. Use "parse, do not validate": create validated values once, then pass validated types through the system.
5. Favor compile-time guarantees over runtime checks.
6. Keep changes incremental and local to the workflow being modeled.
7. If introducing wrappers, improve call-site clarity, not just type novelty.

## Quick decision tree

1. Need the mental model and core principles?
   - Read `references/modeling-playbook.md` "Foundations"
   - Deep source: Fundamentals of type-driven code (`references/fundamentals-of-type-driven-code.md`)

2. Need safer user input or request payloads?
   - Read `references/pattern-catalog.md` "Validation-carrying types"
   - Deep source: Type-safe validation (`references/type-safe-validation.md`)

3. Need compile-time gated access to a feature or workflow step?
   - Read `references/pattern-catalog.md` "Witness pattern"
   - Deep source: Witness pattern: type-safe access control (`references/witness-pattern-type-safe-access-control.md`)

4. Need to model a domain with product/sum types and clear naming?
   - Read `references/modeling-playbook.md` "Domain modeling flow"
   - Deep source: Domain modeling with types (`references/domain-modeling-with-types.md`)

5. Need to remove impossible states from existing models?
   - Read `references/pattern-catalog.md` "Illegal-state elimination"
   - Deep source: Making illegal states unrepresentable (`references/making-illegal-states-unrepresentable.md`)

## Operating workflow

When asked to model or refactor:

1. Identify domain invariants and preconditions in plain language.
2. Classify each concept:
   - Primitive domain type
   - Product type (AND)
   - Sum type (OR)
   - Witness/precondition type
3. Choose the smallest type change that encodes the invariant.
4. Move checks to type construction boundaries.
5. Update downstream APIs to consume strong types instead of raw primitives.
6. Remove redundant runtime validation that the type now guarantees.

## Modeling heuristics

- Start with `struct`.
- Use `enum` for mutually exclusive states.
- Use nested `ID` types to avoid cross-entity identifier mixups.
- Avoid boolean gates for access control when a witness can model it.
- Avoid `String`/`Int` in public domain APIs when semantic meaning matters.
- Keep optional use intentional; each `Optional` introduces a `none` state.

## Anti-patterns to avoid

- Validation scattered across call sites.
- Re-checking invariants that should be proven by type construction.
- "Two optionals" used to model a choice with illegal combinations.
- Feature gating with plain `Bool` across many entry points.
- Premature wrappers with no encoded invariant or semantic benefit.

## Reference files

- `references/_index.md` - quick navigation by problem
- `references/modeling-playbook.md` - practical end-to-end modeling flow
- `references/pattern-catalog.md` - reusable templates and tradeoffs

## Deep source articles

Use these only when you need full explanations/examples:

- Fundamentals of type-driven code -> `references/fundamentals-of-type-driven-code.md`
- Type-safe validation -> `references/type-safe-validation.md`
- Witness pattern: type-safe access control -> `references/witness-pattern-type-safe-access-control.md`
- Domain modeling with types -> `references/domain-modeling-with-types.md`
- Making illegal states unrepresentable -> `references/making-illegal-states-unrepresentable.md`
