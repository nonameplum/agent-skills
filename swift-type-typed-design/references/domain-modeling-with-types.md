Title: Domain modeling with types | Swiftology

URL Source: https://swiftology.io/articles/tydd-part-4/

Markdown Content:
In this article we'll talk about **Software Design** and the role **types** play in this process.

Software design, to put it bluntly, is an exercise in envisioning the future for our software in which it's fully realised according to various specifications: requirements, goals, constraints, etc. It's something that we do _after_ we analyse specifications and _before_ we begin programming. Software design is an ongoing process to which we come back when specifications change, or when we re-emerge from programming deep dives with new insights that challenge our initial designs, it's when we know that our vision didn't survive the impact with reality and we must go back to the drawing board.

I'm intentionally being very casual with my definition of software design because it can include various kinds of activities, depending on the approach. But in this article we'll focus on the activity known as Domain Modeling, and we'll use Swift types as a modeling tool.

What is **Domain Modeling**? This activity is often associated with [Domain-Driven Design](https://en.m.wikipedia.org/wiki/Domain-driven_design) (DDD), one of the most dominant approaches to software design of the past 20 years, introduced by Eric Evans in his [seminal book](https://www.oreilly.com/library/view/domain-driven-design-tackling/0321125215/). But Domain Modeling isn't exclusive to DDD, and you don't have to be familiar with it to successfully practice Domain Modeling. For this reason, _I will refer to DDD no more in this article, and will not use its terminology_, although some definitions will naturally coincide.

[Key definitions](https://swiftology.io/articles/tydd-part-4/#key-definitions)
------------------------------------------------------------------------------

> **📖****Domain** refers to a problem space to which software is applied. It often represents the real-world context, such as banking, healthcare, education, etc. Domains vary in scope - for the Hilton mobile app, this particular hotel company is its domain; while for Booking.com, it's the hotel industry as a whole.

> **📖****Domain Model** is a simplified view of a domain. It focuses on essential aspects of the domain required to solve its problems. It describes key concepts and workflows that can be performed within the domain. For instance, a banking domain model would have concepts such as Money, Account, Transaction, and workflows such as Deposit and Withdraw.

> **📖****Domain Modeling** is the process of translating real-world domain concepts and workflows into a structured format that can be implemented in code.

[Swift, a modeling language?](https://swiftology.io/articles/tydd-part-4/#swift-a-modeling-language)
----------------------------------------------------------------------------------------------------

At first glance Swift, a general purpose language, might seem like an odd choice for domain modeling. After all, there exist specialised modeling languages, such as UML (Unified Modeling Language), wouldn't they be a better fit for the task? It's both 'yes' and 'no', and you can read my thoughts on this in the appendix. For now, let's focus on what makes Swift a superb modeling language:

*   First-class support for **Value Types**, represented by `struct` and `enum`. Value types abstract away the notion of computer memory address, which is not an essential aspect in most of the domains. With languages that don't support value types, such as Objective-C and Java, programmers have to put in extra legwork to achieve value semantics.
*   **Algebraic Data Types** (ADTs). Don't worry if you're not familiar with this concept, it sounds scarier than it really is, and I'll explain it below. ADTs unlock the power of composition, which is essential when modeling complex domains.
*   **Lightweight Abstractions** with protocols which provide a straightforward and composable way of adding "traits" to domain models, such as identity, equality, etc.

![Image 1: domain-modeling-inline.png](https://swiftology.io/domain-modeling-inline.png)
### Naming

Naming can be hard, but it's one of the most important aspects of domain modeling. Luckily, the recommendation is straightforward. Domain models should use the natural vocabulary of a domain, not technical jargon, to build a shared mental model between engineers working on different platforms and non-tech stakeholders. For example, in a banking domain model the type representing a savings account should be called exactly that - `SavingsAccount` - and not `SavingsAccountManagedObject`, even if it's persisted with Core Data.

[Primitives](https://swiftology.io/articles/tydd-part-4/#primitives)
--------------------------------------------------------------------

These types represent singular atomic concepts within a domain. They are the basic building blocks from which domain models are composed.

Some domain primitives can be represented by one of the standard library types, such as `String`, `Decimal`, `Date`, etc. While others require defining a custom data type, for example `Email`, `Money`, `DateOfBirth`, etc.

Custom data types are often defined by wrapping standard types:

```
struct Email {
  let rawValue: String // wrapped type
}
```

This approach provides a semantic separation between `Email` and an arbitrary `String`, making them non-interchangeable within the logic of our program. In addition, we can bake-in data validation into custom data types:

```
struct Email {
  let rawValue: String
  
  init?(_ rawValue: String) {
  guard #rawValue matches email regex# else { 
    return nil 
  }
  self.rawValue = rawValue
}
}
```

Now, `Email` is guaranteed to always hold a valid email string, which might be an important invariant within our domain model. You can read more about this technique and the philosophy behind it in [Part 2: Type-safe validation](https://swiftology.io/articles/tydd-part-2/).

It's very easy to create custom data types in Swift. Should we then do this for all domain primitives? For instance, If we need to represent a person, should we define custom data types for properties such as `FirstName`, `LastName`, `DateOfBirth`, `Height`, etc? Most likely not.

> **📣 Remember!** Domain models must only capture the _essential_ aspects of the domain required to _solve its problems_.

Does our domain have problems that require treating `FirstName` and `LastName` as unique data types? Maybe yes, if we work on software that analyses origins of personal names for some anthropological research. But if we work on a banking application that only displays names on UI, then we should be perfectly fine representing all personal names as simple `String`s.

What about `DateOfBirth` then? Should we just use `Date` instead? In many domains, yes. But in a banking domain, maybe not. To remain compliant with regulations we might be required to enforce age restrictions on our users, so a custom data type might be warranted:

```
struct DateOfBirth {
  let rawValue: Date
  
  init?(_ dateOfBirth: Date) {
    guard dateOfBirth <= #upperLegalDateOfBirth# 
      && dateOfBirth >= #lowerLegalDateOfBirth# else { 
  return nil 
}
    self.rawValue = dateOfBirth
  }
}
```

Now we have a compile-time guarantee that users within our banking domain model comply with the legal age requirements.

[Combinations](https://swiftology.io/articles/tydd-part-4/#combinations)
------------------------------------------------------------------------

Combination types are composed of other types using the logical **AND** relation.

Example: `Credentials` are composed of `Email`**AND**`Password`.

```
struct Credentials {
  let email: Email
  let password: Password
}
```

Combination types are more generally known as [records](https://en.wikipedia.org/wiki/Record_(computer_science)) and [product types](https://en.wikipedia.org/wiki/Record_(computer_science)), and can be created in Swift using a `struct`, `final class`, `actor`, or a tuple. When deciding which one to pick, follow these recommendations:

1.   Start with a `struct`. Most of the domains aren't concerned with the concept of computer memory address, and the value semantics of `struct` abstracts this concern away. When we think about `Credentials` or `DateOfBirth` we usually don't care about their memory addresses, we only care about their contents. Even for entities that have an identity, such as a `User`, we usually care about their _semantic_ identity, such as `username: "haXX0r"`, and not about their memory address identity, such as `0x6000029ed580`.
2.   If you require reference semantics, for instance for performance optimisation reasons, use `final class`. Note the `final` keyword. Domain modeling with Swift _highly discourages_ inheritance. Inheritance is a very crude modeling tool. When you inherit from a class you complicate multiple things between the parent and child classes: types, interfaces, behaviour, and data. It's rare to have domain concepts that have a relationship that requires such a tight coupling. If you need to reuse data or behaviour, you can use composition. If you need to reuse interfaces, you can use protocol composition. If you need polymorphism, for instance to process collections of heterogeneous types, you can again use protocols and generics to provide lightweight abstractions. This approach is often referred to in Swift community as "Protocol-Oriented Programming", although I find this term somewhat reductive. Nevertheless, this approach offers a greater control and flexibility over relationships within our domain models, and reduces chances of code misuse resulting from inherent (pun intended) complications of inheritance.
3.   If you require reference semantics _and_ need to work in a concurrent environment, you might consider using an `actor` to provide safe access to mutable state.
4.   Tuples are not recommended. Their usefulness for domain modeling is very limited in that they don't have unique type names and can't conform to protocols. It's easier to just use a `struct`.

[Choices](https://swiftology.io/articles/tydd-part-4/#choices)
--------------------------------------------------------------

Choice types are composed of other types using the logical **OR** relation.

We define them using enums with associated values, more generally known as [tagged unions](https://en.wikipedia.org/wiki/Tagged_union) and sum types.

Example: `PaymentMethod` is `CreditCard`**OR**`GiftCard`

```
enum PaymentMethod {
  case creditCard(CreditCard)
  case giftCard(GiftCard)
}
```

Thanks to Swift's exhaustive pattern matching (aka enum switching) it's a total delight to work with Choice types:

```
func pay(with paymentMethod: PaymentMethod) {
  switch paymentMethod {
    case let .creditCard(creditCard):
      //pay with the credit card
    case let .giftCard(giftCard):
      //pay with the gift card
  }
}
```

But choice types tend to be underutilised in Swift domain models. And the reason is quite simple - common data interchange formats, such as JSON and XML, don't support tagged unions natively, and to represent mutually exclusive choices web services often use multiple nullable fields:

```
// Credit Card option
"payment_method": {
  "credit_card": { /* data */ },
  "gift_card": null
}

// Gift Card option
"payment_method": {
  "credit_card": null,
  "gift_card":  { /* data */ },
}
```

Which would then be mirrored in Swift like this:

```
struct PaymentMethod: Decodable {
  let creditCard: CreditCard?
  let giftCard: GiftCard?
}
```

Needless to say, this is a horrible way of modeling a Choice type because it permits two invalid choices:

```
// ✅ valid choice
PaymentMethod(
  creditCard: CreditCard(...)
  giftCard: nil
)
// ✅ valid choice
PaymentMethod(
  creditCard: nil
  giftCard: GiftCard(...)
)
// ❌ invalid choice
PaymentMethod(
  creditCard: nil
  giftCard: nil
)
// ❌ invalid choice
PaymentMethod(
  creditCard: CreditCard(...)
  giftCard: GiftCard(...)
)
```

If such a "Choice" type is allowed to enter our domain model it will poison it with these invalid choices. This is the part of the problem known as the impossible state problem, and I will explain how to manage it in the next article of this series.

[Algebraic Data Types](https://swiftology.io/articles/tydd-part-4/#algebraic-data-types)
----------------------------------------------------------------------------------------

**Combination** and **Choice** types, when put together, form **Algebraic Data Types** (ADTs). Despite an intimidating name, the concept is very simple. ADTs are composite types formed by **AND**-ing or **OR**-ing other types.

ADTs allow us to manage complexity within our domain models by composing simpler data types into more-complex ones:

```
// Primitives
struct Money { ... }
struct CreditCard { ... }
struct DebitCard { ... }
// Choice of primitives
enum PaymentMethod {
  case creditCard(CreditCard)
  case debitCard(DebitCard)
}
// Combination of choices
struct Payment {
  let method: PaymentMethod
  let amount: Money
}
// Choice of combinations of choices
enum Transaction {
  case sent(Payment)
  case received(Payment)
}
// and so on, ad infinitum...
```

Composability is a very important property of ADTs, but equally as important is its de-composability. Just as we can assemble a complex ADT from simpler 'parts', so can we easily disassemble it back into its constituents using pattern matching, property access, key paths, etc. With ADTs, divide and conquer becomes a very powerful approach to dealing with complex domain models.

In addition to that, ADTs allow us to easily calculate the number of possible permutations of values that our domain types can hold. We'll explore how this can be useful when we look at how to manage impossible states in the upcoming article.

> **Insight💡:** Composition of types is the key to managing complex domain models. Use Algebraic Data Types to compose simpler types into more-complex ones.

[Identity](https://swiftology.io/articles/tydd-part-4/#identity)
----------------------------------------------------------------

Identity is an important aspect of domain modeling. We often need to have stable and unique identifiers within our domain models. Frameworks like `SwiftUI` often impose `Identifiable` requirement on data for its collections.

The lack of type information around identity can lead to mistakes where identities of unrelated data types are mixed up:

```
struct Song: Identifiable {
  let id: Int
}
struct Video: Identifiable {
  let id: Int
}

func main() {
  let video1 = Video(id: 1)
  let song1 = Song(id: 1)
  // ⚠️ probably unintended
if video1.id == song1.id { // true
  // do something...
}
}
```

To gain the compiler’s support in preventing such mistakes, it’s recommended to have a unique `ID` type for each custom data type.

Declaring nominally distinct types like `Song.ID` and `Video.ID` solves the problem:

```
struct Song: Identifiable {
  struct ID { let id: Int }
  let id: Song.ID
}
struct Video: Identifiable {
  struct ID { let id: Int }
  let id: Video.ID
}
```

But defining a new `ID` type for each data type can quickly go out of hand, so a more ergonomic and scalable solution is to use so called "phantom types". It’s a type safety technique for pulling new types out of thin air, merely by placing a marker type parameter into a generic wrapper type:

```
struct ID<PhantomType> {
  let id: Int
}
struct Song {
  let id: ID<Song>
}
struct Video {
  let id: ID<Video>
}

func main() {
  let video1 = Video(id: 1)
  let song1 = Song(id: 1)
  // ❌ Error: ID<Song> and ID<Video> don't match
// Potential mistake avoided
 if video1.id == song1.id { ... }
}
```

You can take a look at [Swift Tagged](https://github.com/pointfreeco/swift-tagged) library that provides additional flexibility for creating the ID types.

[Functions](https://swiftology.io/articles/tydd-part-4/#functions)
------------------------------------------------------------------

Function types can be used to model domain workflows. For example, a banking domain might have a money transfer workflow. Workflows usually consist of sequences of operations which can be modeled as multiple functions logically linked together by their input and output types.

A money transfer workflow could be defined as a sequence of operations similar to this one:

1.   Enter and validate the amount of money to be transferred.
2.   Enter and validate the recipient's account number.
3.   Perform the money transfer request.
4.   Display a receipt upon the transfer completion.

We can define these operations as the following function types:

```
// 1. Enter and validate the amount of money to be transferred.
(String) -> Money

// 2. Enter and validate the recipient's account number.
(String) -> AccountNumber

// 3. Perform the money transfer request.
(Money, AccoutNumber) async -> TransferReciept

// 4. Display a receipt upon the transfer completion. 
(TransferReciept) -> TransferRecieptView
```

We start with bare function types to see how they fit together in a bigger picture before jumping to implementation. This approach encourages us to [write code top-down](https://www.teamten.com/lawrence/programming/write-code-top-down.html). It protects us from trapping ourselves in dead ends where individual components don't fit together because they've been built in isolation with no view of a bigger picture. Better still, it protects us from premature abstractions which are often introduced specifically to avoid such traps by overgeneralising the code to make it fit into all sorts of _hypothetical_ scenarios, whether it's actually needed or not.

Ok, we have our function types that nicely fit together. Does it mean that we expect these types to be finalised from the first go? Absolutely not! We define the initial types as accurately as we can based on the specifications and our educated guesses, but we fully expect them to be further refined as we uncover unforeseen details during the implementation.

For example, one educated guess we could make even when defining the initial types is that any validation can fail. But we might not yet know how exactly these validations can fail or how these failures are going to be handled. So we refine our function types as accurately as we can by just marking them with `throws`, but we leave out specific error types for now until we figure them out later. We could also guess that the money transfer network requests can fail too.

```
// 1. Enter and validate the amount of money to be transferred.
(String) throws -> Money

// 2. Enter and validate the recipient's account number.
(String) throws -> AccountNumber

// 3. Perform the money transfer request.
(Money, AccoutNumber) async throws -> TransferReciept

// 4. Display a receipt upon the transfer completion.
(TransferReciept) -> TransferRecieptView
```

With these more refined function types we can see that operations still fit well together based on their inputs and outputs, but we now anticipate having error handling logic in places where these operations integrate with each other.

Speaking of errors...

[Errors](https://swiftology.io/articles/tydd-part-4/#errors)
------------------------------------------------------------

Errors are often treated as a second-class citizen and the lack of type information around them can exacerbate this situation. It's important to identify all **Domain Errors** and explicitly encode them in types. Domain errors, also known as 'business errors', are those errors that are relevant within our domain to solve its problems. For a banking domain, a failed attempt to withdraw money from a closed account will most likely be treated as a domain error that requires special handling.

When domain errors are defined as types, they can be caught and handled appropriately:

```
enum WithdrawalError: Error {
 case insufficientFunds(remainingBalance: Money)
 case closedAccount
}

func withdraw(
  amount: Money, 
  from account: SavingsAccount
) async -> Result<Receipt, WithdrawalError> {...}

let result = await withdraw(amount: 100.0, from: SavingsAccount(...))
switch result {
  case let .success(receipt): 
    // happy days
  case let .failure(.insufficientFunds(remainingBalance)):
    // suggest to withdraw the remainingBalance
  case .failure(.closedAccount):
    // display the list of other accounts
}
```

Upcoming [Typed Throws](https://github.com/apple/swift-evolution/blob/main/proposals/0413-typed-throws.md) will allow to replace switching on `Result` with a more natural `do-try` flow:

```
func withdraw(
  amount: Money, 
  from account: SavingsAccount
) async throws(WithdrawalError) -> Receipt {...}

do {
  let receipt = try await withdraw(amount: 100.0, from: SavingsAccount(...))
} catch {
  switch error {
  case .insufficientFunds(remainingBalance): 
    // suggest to withdraw the remainingBalance
  case .closedAccount: 
    // display the list of other accounts
  }
}
```

[Side Effects](https://swiftology.io/articles/tydd-part-4/#side-effects)
------------------------------------------------------------------------

Learning how to model side effects, such as I/O operations, networking, randomness, and so on, can be hard. But it's a very valuable skill to acquire. I'll dedicate a whole separate article to this topic, so stay tuned...

[Conclusion](https://swiftology.io/articles/tydd-part-4/#conclusion)
--------------------------------------------------------------------

Domain modeling plays a significant role in modern software design, and investing time and effort to mastering this skill will be worth your while. Learn to leverage Swift's expressive type system to create accurate and robust models tailored to solve problems in your domain.

In the upcoming articles of this series we'll continue mastering various techniques of domain modeling that will help us manage impossible state and side effects.

[📖 Part 5 Making illegal states unrepresentable -------------------------------------](https://swiftology.io/articles/making-illegal-states-unrepresentable/)

* * *

[Appendix: Swift vs UML](https://swiftology.io/articles/tydd-part-4/#appendix-swift-vs-uml)
-------------------------------------------------------------------------------------------

There are many specialised domain modeling tools and languages, UML (unified modeling language) being the most popular one. Specialised modeling languages benefit from being platform-independent and focused on domain concepts. But these benefits can also be viewed as downsides:

*   Being platform-independent also means being abstracted away from the target platform languages. Unless you directly generate Swift types from UML diagrams, they serve merely as glorified documentation. Inevitably, this leads to interpretation gaps and desynchronisation.
*   Understanding and using UML effectively requires learning its notation and conventions. It's a steep learning curve. For simple domain models UML can feel like an overkill, while for complex ones it quickly becomes unwieldy, lacking any static analysis features like autocomplete, typechecking, validation, etc.

Using Swift for domain modeling has own downsides:

*   It's limited to mostly Apple platforms. While you could use Swift domain models as a design document for, let's say, Android implementation, it's unlikely that you would do so. It's more likely that each platform would practice domain modeling independently using their native language.
*   Domain modeling using a general purpose language can lead to focusing on implementation details early on, potentially obscuring the core domain concepts.

* * *

[Recommended materials](https://swiftology.io/articles/tydd-part-4/#recommended-materials)
------------------------------------------------------------------------------------------

*   This article was heavily inspired by Scott Wlaschin's fantastic book [Domain Modeling Made Functional](https://pragprog.com/titles/swdddf/domain-modeling-made-functional). It uses F# for code examples, but as a Swift programmer I found it very readable.
*   Read more about the theory behind Product and Sum types in Swift in [Swift, Algebraically: Sum Types, Product Types, Exponential Types](https://josevillegas.substack.com/p/swift-sum-types-product-types) by Jose Villegas.
*   More examples of ADTs in the article [Algebraic Data Types in Swift](https://medium.com/nerd-for-tech/algebraic-data-types-in-swift-2a777b24253d) by Anastasiia Petrova, and [Algebraic Data Types](https://www.pointfree.co/episodes/ep4-algebraic-data-types) videos by Point-Free.
*   More on the importance of strong typing in software design in [Cloud Automation à la DDD: From stringly typed to affordances](https://architectelevator.com/cloud/ddd-technical-domains/) by by Gregor Hohpe.
*   Great thoughts on how to remain hands-on as a software architect in [Debugging Architects](https://architectelevator.com/transformation/debugging-architect/) by Gregor Hohpe.

