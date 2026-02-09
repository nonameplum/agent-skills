# Choosing between Closures vs Capability Structs vs Protocols (Swift)

This table is intentionally short and biased toward functional architecture.

## Decision table

| You should use… | When it’s the best fit | Pros | Cons | Typical examples |
|---|---|---|---|---|
| **A single closure** | You need **one capability** (or 2–3 max) and the shape is stable | Smallest surface area, easiest tests (inline fakes), minimal ceremony | Parameter lists can grow quickly; naming can get repetitive | `now: () -> Date`, `fetch: (URL) async throws -> Data`, `log: (String) -> Void` |
| **A capability struct of closures** | You have **several related capabilities** (4+), you want grouping, and you still want functions as dependencies | Scales DI cleanly, easy to override one function in tests, keeps boundaries explicit | Slightly more boilerplate; API changes touch call sites | `HTTPClient { get/post }`, `Clock { now/sleep }`, `UserStore { load/save/delete }` |
| **A protocol** | You need **polymorphism**, shared abstractions across many modules, reference semantics/identity, or OO framework integration | Familiar, dynamic dispatch, good extension points | Mocking overhead, interfaces tend to grow, easier to hide side effects | `URLSessionProtocol`, `AnalyticsTracking`, `KeychainStoring` |

## Quick rules of thumb

- Start with **closures** when a use case needs only a couple of operations.
- Switch to a **capability struct** when signatures get noisy or capabilities naturally group.
- Use **protocols** only when you explicitly need polymorphism or integration constraints.
- Keep the functional core depending on *functions/capabilities*, not concrete implementations.
- Put protocol-heavy integration at the boundary and adapt into closures before passing into the core.

## “Do I need protocols?” checklist

Protocols are reasonable if:
- you need runtime polymorphism across many call sites
- you need reference semantics / identity (shared state) and can justify it
- frameworks/APIs force OO patterns
- you are designing an SDK extension point

Otherwise, prefer closures or capability structs.
