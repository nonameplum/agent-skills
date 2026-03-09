Title: Making illegal states unrepresentable | Swiftology

URL Source: https://swiftology.io/articles/making-illegal-states-unrepresentable/

Markdown Content:
> 💡In state modeling, perfection is achieved not when there is nothing more to add, but when there is nothing left to take away.

When we reason about code, we often want to understand what states our program can enter, and how it behaves when it enters a certain state. When we discover that our programs can enter unintended states, it bothers us greatly (at least it should!). We usually call such states _illegal_, and take action to protect against them.

A simple example of an illegal state is when we mutate a collection while it's being iterated:

```
for index in array.indices {
  if #condition# {
    array.removeFirst() // ⚠️ Indices shifted
    // `index` is logically detached from `array`
    // this is an illegal state!
  }
  // 💥 Eventually, we'll hit index out of bounds
  let element = array[index]
  ...
}
```

Why are illegal states bad? The main reason, obviously, is because they are, well... _illegal_, and are usually linked to bugs in our programs. But another, less obvious, reason is that they tend to increase the complexity of our code, forcing us to add and maintain extra checks and balances to protect against illegal states.

A naïve (and horribly wrong) way of handling the illegal state from the example above is by adding an extra check:

```
for index in array.indices {
  if #condition# {
    array.removeFirst()
  }
  guard array.indices.contains(index) { return }
// `index` is still logically detached from `array`
// but we mask this with an extra check
  let element = array[index]
  ...
}
```

Protection against illegal states is a common source of [accidental and incidental complexity](https://coder-mike.com/blog/2021/09/24/incidental-vs-accidental-complexity/), since it doesn't always represent how complex the real problem space is, but rather masks our mistakes in domain modeling.

> In this article, we'll look at how Swift types can be modeled to make illegal states unrepresentable in code, effectively, eliminating them from our programs, along with the added complexity.

[📝 Example: Forgotten password recovery](https://swiftology.io/articles/making-illegal-states-unrepresentable/#example-forgotten-password-recovery)
----------------------------------------------------------------------------------------------------------------------------------------------------

Suppose we have an application that requires _all_ users to register with at least one contact method, either an email or a phone number, or both.

We can model this requirement with the following `ContactMethods` data type:

```
class RegisteredUser {
  let contactMethods: ContactMethods
  ...
}
struct ContactMethods {
  let email: Email?
  let phoneNumber: PhoneNumber?
}
```

Let's verify that `ContactMethods` is flexible enough to permit all required combinations of contact methods:

```
// Only email
ContactMethods(
  email: Email("user@example.com"), 
  phoneNumber: nil
)
// Only phone number
ContactMethods(
  email: nil, 
  phoneNumber: PhoneNumber("+442079460000")
)
// Both
ContactMethods(
  email: Email("user@example.com"), 
  phoneNumber: PhoneNumber("+442079460000")
)
```

If a registered user later forgets their password, we can generate a temporary recovery link and send it to one of their contact methods, prioritising email:

```
func sendRecoveryLink(to user: RegisteredUser) async {
  let link = await generateRecoveryLink(for: user)
  
  if let email = user.contactMethods.email {
    // send link to email
  } else if let phoneNumber = user.contactMethods.phoneNumber {
    // send link to phone number
  }
}
```

Job done! But wait...

...I always get suspicious when I see a chain of `if-else` statements without a final `else` clause:

```
func sendRecoveryLink(to user: RegisteredUser) async {
  let link = await generateRecoveryLink(for: user)
  
  if let email = user.contactMethods.email {
    // send link to email
  } else if let phoneNumber = user.contactMethods.phoneNumber {
    // send link to phone number
  } else {
  ???
}
}
```

What does this `else` clause represent? What state does our program enter when we take this code path?

We can only take this code path if a registered user has neither `email` nor `phoneNumber`. But we _know_ that all users were required to provide at least one contact method during registration, so this state is considered illegal and, indeed, _impossible_ according to our business rules!

### Handling missing contact details at runtime

How should we handle this illegal state? At this point, we have the following options:

1.   Just ignore it since it's considered "impossible" and should never happen in production, YOLO.
2.   Disregard business rules and handle the illegal state anyway, just in case. Show the user some "helpful" error dialog, navigate them away from the faulty screen, etc. Bury the problem in incidental complexity.
3.   Crash with `fatalError` to surface information that can help us investigate the issue later. This might be the best option under the given circumstances, but most teams won't have the guts to intentionally crash their app.
4.   Silently log an error message, without crashing. In my experience, this is what most teams would do:

```
func sendRecoveryLink(to user: RegisteredUser) async {
  let link = await generateRecoveryLink(for: user)
  
  if let email = user.contactMethods.email {
    // send link to email
  } else if let phoneNumber = user.contactMethods.phoneNumber {
    // send link to phone number
  } else {
  logger.error("This should never happen! Investigate \(user.id)")
}
}
```

To avoid the unnecessary call to a potentially expensive and sensitive `generateRecoveryLink` when in the illegal state, we might even be compelled to move the call inside valid state branches, further complicating our code:

```
func sendRecoveryLink(to user: RegisteredUser) async {
  if let email = user.contactMethods.email {
    let link = await generateRecoveryLink(for: user)
    // send link to email
  } else if let phoneNumber = user.contactMethods.phoneNumber {
    let link = await generateRecoveryLink(for: user)
    // send link to phone number
  } else {
    logger.error("This should never happen! Investigate \(user.id)")
  }
}
```

At this point, it should be quite obvious that we were moving in altogether wrong direction, so let's take a few steps back.

### Handling missing contact details at compile time

Let's revisit the `ContactMethods` data type. We verified that it was flexible enough to permit all required combinations of contact methods, but turns out it was _too flexible_, and also permitted the illegal combination:

```
// Only email
ContactMethods(
  email: Email("user@example.com"), 
  phoneNumber: nil
)
// Only phone number
ContactMethods(
  email: nil, 
  phoneNumber: PhoneNumber("+442079460000")
)
// Both
ContactMethods(
  email: Email("user@example.com"), 
  phoneNumber: PhoneNumber("+442079460000")
)
// ⚠️ None - the illegal combo
ContactMethods(
  email: nil,
  phoneNumber: nil
)
```

Clearly, we'd made a domain modeling mistake here. `ContactMethods` doesn't accurately represent our business rules, and this inaccuracy then corrupts the password recovery logic.

We need to locate the source of the illegal state within `ContactMethods` and eliminate it.

> 🐘 How do you make a statue of an elephant?Get the biggest granite block you can find and chip away everything that doesn’t look like an elephant.

What extra piece of `ContactMethods` do we need to chip away?

```
// 🤔 what must we remove?
struct ContactMethods {
  let email: Email?
  let phoneNumber: PhoneNumber?
}
```

It's actually not obvious. If we consider `ContactMethods` in its current form, there is nothing we can remove. We can't remove any of the properties or make any of them non-optional, without making the type _too restrictive_.

This is because we're looking at `ContactMethods` in its **compacted** representation, which conceals useful information from us. We need to expand `ContactMethods` to see its structure clearly. Let's do it step by step.

First, let's de-sugar the optional types:

```
struct ContactMethods {
  let email: Optional<Email>
  let phoneNumber: Optional<PhoneNumber>
}
```

`Optional` is a generic enum defined like this:

```
enum Optional<WrappedValue> {
  case some(WrappedValue)
  case none
}
```

This means that types of both properties look something like this:

```
struct ContactMethods {
  let email: Optional<Email>
  let phoneNumber: Optional<PhoneNumber>
}
// pseudo-code
enum Optional<Email> {  
  case some(Email)        
  case none               
}   
enum Optional<PhoneNumber> {
  case some(PhoneNumber) 
  case none
}
```

`ContactMethods` is a struct, which means it's a _combination_ of all values that `Optional<Email>` and `Optional<PhoneNumber>` can hold together. Let's juxtapose these enums and permute their cases:

```
enum Optional<Email> {  enum Optional<PhoneNumber> {
  case some(Email)        case some(PhoneNumber)
  case none               case none
}                       }
// Permutation of all cases 🔀
case some(Email)        case some(PhoneNumber)
case some(Email)        case none
case none               case some(PhoneNumber)
case none               case none
```

Finally, let's merge these permutations into a single enum, and give each case a meaningful name:

```
enum ContactMethods {
  case both(Email, PhoneNumber)
  case email(Email)
  case phoneNumber(PhoneNumber)
  case none
}
```

Voilà! Now, we're looking at `ContactMethods` in its **expanded** representation! Notice how these cases directly map to the four possible combinations we'd identified earlier.

Now, it's obvious which piece must be chipped away:

```
enum ContactMethods {
  case both(Email, PhoneNumber)
  case email(Email)
  case phoneNumber(PhoneNumber)
  // case none
☝️ the illegal state removed!
}
```

We can now update the `sendRecoveryLink` function:

```
func sendRecoveryLink(to user: RegisteredUser) async {
  let link = await generateRecoveryLink(for: user)
  
  switch user.contactMethods {
case let .both(email, _), 
     let .email(email):
  // send link to email
case let .phoneNumber(phoneNumber):
  // send link to phone number
}
}
```

We don't need to complicate our code by handling the missing contact details anymore! This illegal state simply can't be represented in our code. We have the exhaustive `switch` statement where all logic branches map to valid application states.

[Expanding data types to isolate illegal states](https://swiftology.io/articles/making-illegal-states-unrepresentable/#expanding-data-types-to-isolate-illegal-states)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

In the previous section I showed you a step-by-step process of converting `ContactMethods` from its **compacted** to its **expanded** representation:

```
// Compacted
struct ContactMethods {
  let email: Email?
  let phoneNumber: PhoneNumber?
}
// Expanded
enum ContactMethods {
  case both(Email, PhoneNumber)
  case email(Email)
  case phoneNumber(PhoneNumber)
  case none
}
```

But to an untrained eye that demonstration might look more like a sleight of hand trick, and less like a valuable lesson. So let's break down the theory behind data types expansion, starting from first principles.

### Data types are sets of values

We can think of data types as sets of all possible values they can hold.

For example, `Bool` is a set of two possible values, and `UInt8` is a set of 256 possible values:

```
Bool  = {true, false} // 2 values
UInt8 = {0,1,...,255} // 256 values
```

In the previous article, [Domain Modeling with types](https://swiftology.io/articles/tydd-part-4), we looked at **Algebraic Data Types** (ADTs) which compose other types using logical `AND` and `OR` relationships.

One of the most important properties of ADTs is that they allow us to calculate the total number of all possible values that multiple types can hold together.

For a Combination of types (`AND`), we _multiply_ their value counts:

```
struct Combination {
  let num: UInt8 // 256
  let bool: Bool // 2
}
// 256   ×   2   =  512
```

For a Choice of types (`OR`), we _add_ their value counts:

```
enum Choice {
  case num(UInt8) // 256
  case bool(Bool) // 2
}
// 256   +   2    =  258
```

For this reason a Combination of types is also known as a **Product type**, and a Choice of types is known as a **Sum type**:

```
// X*Y
struct Product<X, Y> {
  let x: X
  let y: Y
}
// X+Y
enum Sum<X, Y> {
  case x(X) 
  case y(Y)				  
}
```

### Distribute Product types over Sum types

At school, we are taught how multiplication can be distributed over addition: `x*(y+z)=x*y+x*z`

The same elementary algebra can be applied to **Product** and **Sum** types. After all, they aren't called _algebraic_ data types for nothing.

Let's define 4 types:

```
struct A {}
struct B {}
struct C {}
struct D {}
```

...and demonstrate this equivalence: `(A+B)*(C+D)=A*C+A*D+B*C+B*D`

```
// (A+B)*(C+D)
struct Compacted {
  let ab: Sum<A, B>
  let cd: Sum<C, D>
}
// A*C+A*D+B*C+B*D
enum Expanded {
  case ac(Product<A, C>)
  case ad(Product<A, D>)
  case bc(Product<B, C>)
  case bd(Product<B, D>)
}
// (A+B)*(C+D) = A*C+A*D+B*C+B*D
// Compacted   = Expanded
```

`Compacted` and `Expanded` are equivalent. They are just different representations of the same data type. And when I say 'equivalent' I really mean they are _isomorphic_, which is a fancy term that simply means that we can move data between these representations without losing _any_ information:

```
// Isomorphism: Compacted <-> Expanded
extension Compacted {
  func expand() -> Expanded {...}
}
extension Expanded {
  func compact() -> Compacted {...}		
}

let a = A()
let c = C()
let expanded = Expanded.ac(a, c)
let compacted = Compacted(.a(a), .c(c))

expanded.compact() == compacted // true 
compacted.expand() == expanded  // true
```

These conversions are very easy to implement, and you can try it as an exercise.

Let's replace `A`, `B`, `C`,`D` with the Four Schools of Elemental Magic: `Air`, `Water`, `Earth`, and `Fire`.

```
struct Compacted {
  let atmospheric: Sum<Air, Water>
  let geothermal: Sum<Earth, Fire>
}
enum Expanded {
  case sand(Product<Air, Earth>)
  case lightning(Product<Air, Fire>)
  case swamp(Product<Water, Earth>)
  case steam(Product<Water, Fire>)
}
```

We already have a formal proof that these two representations are equivalent.

Suppose we decide that `Air` and `Fire` should never be combined, the lightning magic is strictly outlawed! We can easily isolate and eliminate this illegal state in the `Expanded` representation:

```
enum Expanded {
  case sand(Product<Air, Earth>)
  //case lightning(Product<Air, Fire>)
  case swamp(Product<Water, Earth>)
  case steam(Product<Water, Fire>)
}
```

But it would be impossible in the `Compacted` representation:

```
// 🤷🏻
struct Compacted {
  let atmospheric: Sum<Air, Water>
  let geothermal: Sum<Earth, Fire>
}
```

> 💡Knowing how to define data types in their **compacted** and **expanded** representations is an essential skill for isolating and eliminating illegal states.

["Zero element" is a common source of illegal states](https://swiftology.io/articles/making-illegal-states-unrepresentable/#zero-element-is-a-common-source-of-illegal-states)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Some data types have a "zero element" that represents an absence of a value. Here are some examples from Swift standard library:

```
Optional    nil
UInt        0
String      ""
Array       [] 
Dictionary  [:]
```

When such data types are composed, they may have multiple potential "zero elements":

```
String      ""
String?     ""  nil
[String]   [""] []       
[String]?  [""] [] nil
```

Some or all of such "zero elements" may be considered an illegal state by certain parts of your program.

> 💡It's very common to have one part of a program where a "zero element" represents a valid state, while another part interprets it as an illegal state. Failure to recognise and represent these logical boundaries in the type system may result in tons of incidental complexity.

The solution is to replace types that have a "zero element" with corresponding types that don't, and use them in relevant parts of the code base:

```
T?     👉 T
[T]    👉 NonEmpty<[T]>
UInt   👉 PositiveInt 
String 👉 NonEmpty<String> // aka NonEmpty<[Character]>
```

I briefly mentioned `NonEmpty<Collection>` type in the first part of this series - [Fundamentals of type-driven code](https://swiftology.io/articles/tydd-part-1-fundamentals/) - indeed this type is so essential that I strongly believe it should be included in Swift Standard Library, just like it is in many other languages. Until then, you can fetch it from [swift-nonempty](https://github.com/pointfreeco/swift-nonempty).

As for something like `PositiveInt`, it's a trivial parser type that can be implemented using techniques discussed in [Type-safe validation](https://swiftology.io/articles/tydd-part-2/):

```
struct PositiveInt {
  let rawValue: UInt
  
  init?(_ rawValue: UInt) {
    guard rawValue > 0 else { return nil }
    self.rawValue = rawValue
  }
}
```

For data types with multiple "zero elements", we can surgically eliminate only those that represent illegal states in our domain:

```
// Type                      "zero elements"
[String]?                     [""] []  nil
[String]                      [""] []  ✅
[NonEmpty<String>]?            ✅  []  nil 
NonEmpty<[String]>?           [""] ✅  nil
NonEmpty<[String]>            [""] ✅  ✅
[NonEmpty<String>]             ✅  []  ✅
NonEmpty<[NonEmpty<String>]>?  ✅  ✅  nil
NonEmpty<[NonEmpty<String>]>   ✅  ✅  ✅
```

While your domain may never require a `non-empty array of non-empty strings`, it's very useful to understand the underlying principle of a "zero element" elimination that gives rise to such types.

[Serialization is a common source of illegal states](https://swiftology.io/articles/making-illegal-states-unrepresentable/#serialization-is-a-common-source-of-illegal-states)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

We often need to serialize data into various formats for transport and storage. Common examples include JSON, XML, Plist, SQLite, protobuf, etc.

Most of these formats are significantly less expressive than Swift's type system, and don't support constructs like Algebraic Data Types.

Let's focus on JSON, as it's the most common serialization format. JSON doesn't support union types (Choice/Sum types), which are required for modelling mutually exclusive states.

Suppose we have a `Payment Method`, which is either a `Credit Card` or a `Gift Card`. Since JSON doesn't support union types, we have to resort to two nullable fields:

```
"payment_method": {
  "credit_card": { /* Credit Card */ },
  "gift_card": null
}
"payment_method": {
  "credit_card": null,
  "gift_card":  {/* Gift Card */},,
}
```

If we were to directly map (or even autogenerate) a Swift type from this JSON schema, we'd get this:

```
struct PaymentMethod: Codable {
  let creditCard: CreditCard?
  let giftCard: GiftCard?
}
```

Of course, you already know that this representation permits 2 illegal states:

```
// ✅ legal
PaymentMethod(
  creditCard: CreditCard(...),
  giftCard: nil
)
// ✅ legal
PaymentMethod(
  creditCard: nil,
  giftCard: GiftCard(...)
)
// ❌ illegal
PaymentMethod(
  creditCard: CreditCard(...),
  giftCard: GiftCard(...)
)
// ❌ illegal
PaymentMethod(
  creditCard: nil,
  giftCard: nil
)
```

It's common for teams to allow JSON schema to dictate the structure of their Swift domain models. This often leads to the proliferation of illegal state handling deep inside a domain code, which means more incidental complexity.

Instead, I advise to "fail fast", at the boundary between the domain and the outside world (network, file system, etc).

We can encode the requirement that payment methods must be mutually exclusive right into the JSON decoding.

```
// ✅ Accurately modeled choice
enum PaymentMethod {
  case creditCard(CreditCard)
  case giftCard(GiftCard)
}

extension PaymentMethod: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let creditCard = try container.decodeIfPresent(CreditCard.self, forKey: .creditCard)
    let giftCard = try container.decodeIfPresent(GiftCard.self, forKey: .giftCard)
    
    switch (creditCard, giftCard) {
case let (creditCard?, nil):
  self = .creditCard(creditCard)
case let (nil, giftCard?):
  self = .giftCard(giftCard)
case (.some, .some), (nil, nil):
  throw #DecodingError#
}
  }
}
```

Some persistence solutions, such as `Realm`, require separate Swift types to serve as a serialization schema, often known as Data Transfer Objects (DTOs), specifically designed to be serialized. Similar to JSON, `Realm` doesn't support union types, and just like with JSON objects, my advice is to forbid DTOs from entering your domain code, and parse them into domain models at its boundaries:

```
// Realm DTO
class PaymentMethodObject: Object {
  @Persisted var creditCard: CreditCard?
  @Persisted var giftCard: GiftCard?
}
// Domain model
enum PaymentMethod {
  case creditCard(CreditCard)
  case giftCard(GiftCard)

  init(from object: PaymentMethodObject) throws {
    // similar to JSON decoding
  }
}
```

[Interoperability with other languages is a common source of illegal states](https://swiftology.io/articles/making-illegal-states-unrepresentable/#interoperability-with-other-languages-is-a-common-source-of-illegal-states)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

In Swift programming, sometimes we need to interoperate with other programming languages, such as Objective-C, C, JavaScript, Python, etc. Type systems of these languages differ, often significantly, from Swift's type system. As a result, some semantic information can be lost during the conversion process when data crosses language boundaries. In the attempt to recover its original semantics, data must be sanitized and parsed. And failure to do so must prevent it from entering our domain code, as it should be considered corrupt and illegal.

I won't go into much detail here because the strategy for handling interoperability is very similar to that of serialization, described in the previous section. Indeed, serializable formats are often used to communicate between two languages.

For scenarios where cross-system communication happens a lot, we might even introduce an [Anti-Corruption Layer](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/acl.html)(ACL) to stand between another system and our Swift domain code.

![Image 1: anti-corruption-layer](https://swiftology.io/anti-corruption-layer.png)
[Using `Never` to eliminate illegal states](https://swiftology.io/articles/making-illegal-states-unrepresentable/#using-code-never-code-to-eliminate-illegal-states)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

Suppose we have a `Cache` protocol with associated `CacheError` type:

```
protocol Cache {
  associatedtype CacheError: Error
  func data(for key: String) async -> Result<Data?, CacheError>
  ...
}
```

We can implement a specific `RemoteCache` class that expects `NetworkError`s to happen when we fetch data over the network:

```
enum NetworkError: Error {
  case connectionFailed 
  case timeout
}
class RemoteCache: Cache {
  func data(for key: String) async -> Result<Data?, NetworkError> {...}
}

await switch remoteCache.data(for: "data") {
  case let .success(data): 
    // happy days
  case .failure(.connectionFailed),
     .failure(.timeout): 
  // hangle network error, e.g. retry
}
```

But if we introduce an in-memory cache and use it with `NetworkError`, we'll have to handle impossible states:

```
class InMemoryCache: Cache {
  func data(for key: String) -> Result<Data?, NetworkError> {...}
}

switch inMemoryCache.data(for: "data") {
  case let .success(data): 
    // happy days
  case .failure(.connectionFailed), 
     .failure(.timeout):
  fatalError("in-memory cache can't fail!")
}
```

In-memory cache can't fail due to `connectionFailed` or `timeout`. Indeed, it can't fail at all! So we can introduce a separate `InMemoryCacheError` with....no error cases?

```
enum InMemoryCacheError: Error {
  // no error cases? 🤔
}
```

This is a perfectly accurate in-memory cache error model! But it turns out that such a type already exists in Swift Standard Library, it's called `Never`:

```
enum Never {}
extension Never: Error {}
```

We can use `InMemoryCache` with `Never` error type to tell the compiler that it never fails, making the illegal states unrepresentable in code:

```
class InMemoryCache: Cache {
  func data(for key: String) -> Result<Data?, Never>
}
// ✅ this switch is exhaustive!
switch inMemoryCache.read(key: "data") {
  case let .success(data): 
    // only happy days
}
```

As you can see, we don't need to handle `.failure` case at all! The compiler knows that error value of type `Never` can't be created at runtime, so it accepts the switch with only the `.success` case as exhaustive.

[Conclusion](https://swiftology.io/articles/making-illegal-states-unrepresentable/#conclusion)
----------------------------------------------------------------------------------------------

"Making illegal states unrepresentable" is a very powerful approach to data modeling and software design in general. It's been mainstream in functional programming communities for a long time now, including that of Swift.

If you've made it through the whole article, you should be well-equipped to squash those pesky illegal states at compile time, using Swift's type system as your weapon of choice!

Stay tuned for the next part where we'll discuss how to manage side-effects! 🌟

[📺 Companion Video](https://swiftology.io/articles/making-illegal-states-unrepresentable/#companion-video)
-----------------------------------------------------------------------------------------------------------

📖 Part 6

Coming soon

Controlling Side Effects with Swift
-----------------------------------

[Recommended materials](https://swiftology.io/articles/making-illegal-states-unrepresentable/#recommended-materials)
--------------------------------------------------------------------------------------------------------------------

*   📖 [Eliminating Impossible States with Never](https://matt.diephouse.com/2018/07/eliminating-impossible-states-with-never/) by Matt Diephouse
*   📖 [Designing with types: Making illegal states unrepresentable](https://fsharpforfunandprofit.com/posts/designing-with-types-making-illegal-states-unrepresentable/)by Scott Wlaschin
*   📺 [Making Impossible States Impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8)by Richard Feldman
*   📖 [Incidental vs Accidental complexity](https://coder-mike.com/blog/2021/09/24/incidental-vs-accidental-complexity/) by Michael Hunter

