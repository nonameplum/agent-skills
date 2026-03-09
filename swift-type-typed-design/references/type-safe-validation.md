Title: Type-safe validation | Swiftology

URL Source: https://swiftology.io/articles/tydd-part-2/

Markdown Content:
Validation is a very common task in software engineering. We need to validate stuff all the time: user inputs, data formats, array bounds, external configurations, etc.

In the previous article we saw how types can capture and propagate information. And now we'll cement this idea by looking at a bigger example that focuses of input validation, and does so in a type-safe way, eliminating a whole class of bugs and vulnerabilities.

We're going to build a Login screen that validates login credentials and performs a login network request. Here's a UI scaffolding with text fields and a button:

```
struct LoginScreen: View {
  @State var email: String = ""
  @State var password: String = ""
  
  var body: some View {
    VStack {
      TextField("Email", text: $email)
      TextField("Password", text: $password)
      Button("Log In") { onLogIn() }
    }
  }
  
  func onLogIn() {}
}
```

To log in, our screen will use `AuthService` with a method like this:

```
class AuthService {
  func logIn(
    email: String, 
    password: String
  ) {
    // Sends an HTTP request...
  }
}
```

When the `Log In` button is tapped, we pass `email` and `password` inputs to the `AuthService`:

```
struct LoginScreen: View {
  @EnvironmentObject var authService: AuthService
  @State var email: String = ""
  @State var password: String = ""
  
  var body: some View { ... }
  
  func onLogIn() {
    authService.logIn(
  email: email, 
  password: password
)
  }
}
```

But before we can make the login request, we have a requirement to check that `email` and `password` have valid formats:

```
func onLogIn() {
  guard email.matches("#email regex#")
  && password.count > 7 else {
  return
}
  authService.logIn(
    email: email, 
    password: password
  )
}
```

If you read the first article in this series you can already see the issue here. We're losing the knowledge that `email` and `password` are valid as soon as we step out of the guard statement!

We can displace or completely remove the validation step, and the app would still compile and run as if nothing had happened!

```
func onLogIn() {
  // guard email.matches("#email regex#")
//  && password.count > 7 else {
//  return
// }
  authService.logIn(
    email: email, 
    password: password
  )
}
```

`AuthService` has no knowledge that the `email` and `password` strings that it receives have indeed been validated. Since validation checks can be arbitrarily displaced, the whole system must always assume that it could be acting on potentially invalid input data. Should then the `AuthService` perform its own validation before sending the login request?

```
class AuthService {
  func logIn(email: String, password: String) {
    // Just to be sure...
guard email.matches... else { return }
    // Send HTTP request
  }
}
```

This certainly doesn't seem right. You could argue that validation is not the responsibility of `AuthService` and it should just "trust" or "assume" that the upstream has taken care of the validation. Which is a perfectly reasonable argument, but wouldn't it be better if instead of blind "trust", it could rely on solid proof?

Coming back to our validation check, we also permit mistakes like this:

```
func onLogIn() {
  guard email.matches("#email regex#")
  || password.count > 7 else {
    return
  }
  authService.logIn(
    email: email, 
    password: password
  )
}
```

Now, it's possible to make the login request with **partially validated** data!

We can be super diligent when implementing and testing validations like this, but we'll never have a complete confidence that at any given moment we're acting upon fully validated data, especially in a large codebase with lots of distributed moving parts.

> **Caution ⚠️:** Conventional **validation** can be dangerous! It can lead to the anti-pattern where data validation is mixed with business logic. Validation checks become scattered around the codebase with the hope, but without any systematic justification, that all invalid data is caught before it's being acted upon. In some scenarios failure to catch invalid data can lead to vulnerabilities that can be exploited by injecting malicious data.

So, what can we do about it? We need to improve our design by introducing type safety. We need the **validation-carrying types**!

Let's introduce `Email` and `Password` types that wrap raw strings:

```
struct Email {
  let rawValue: String
}

struct Password {
  let rawValue: String
}
```

Next, let's put corresponding validation checks inside the fallible initializers:

```
struct Email {
  let rawValue: String
  
  init?(_ rawValue: String) {
  guard rawValue.matches("#email regex#") else { 
    return nil 
  }
  self.rawValue = rawValue
}
}

struct Password {
  let rawValue: String
  
  init?(_ rawValue: String) {
  guard rawValue.count > 7 else { 
    return nil 
  }
  self.rawValue = rawValue
}
}
```

Now, it’s only possible to create `Email` and `Password` values if validation checks pass. And crucially, we now retain and propagate the **proof** of validation with the successfully initialized values of these types.

Let's update the code:

```
func onLogIn() {
  guard let validEmail = Email(email), 
  let validPassword = Password(password) else {
  return
}
  authService.logIn(
    email: validEmail.rawValue, 
    password: validPassword.rawValue
  )
}
```

We still have to fall back to raw strings before passing credentials to `AuthService`. Let’s refine the types on the `AuthService` itself...

```
class AuthService {
  func logIn(email: Email, password: Password) {
    // ✅ Has a proof that email and password
    // have already been validated,
    // so doesn't need to validate again
    
    // Send an HTTP request...
  }
}
extension Email: Encodable { ... }
extension Password: Encodable { ... }
```

…and pass the validated credentials directly to `AuthService`, sealing the gap in data flow:

```
func onLogIn() {
  guard let validEmail = Email(email), 
    let validPassword = Password(password) else {
      return
  }
  authService.logIn(
    email: validEmail, 
    password: validPassword
  )
}
```

[Parse, don’t validate](https://swiftology.io/articles/tydd-part-2/#parse-don-t-validate)
-----------------------------------------------------------------------------------------

What is the difference between `String` and `Email`?

`Email` is a more structured version of `String`. All emails are strings, but not all strings are emails. The same can be said about `String` and `Password`.

There are two kinds of operations that can be performed on such type pairs: **validation** and **parsing**.

> **Validation:** Checks if a value of a less structured type qualifies as a value of a more structured type , returning `true` or `false`, then discards this information:

```
func isValidEmail(_ string: String) -> Bool {
  return string.matches("#email regex#")
}

if isValidEmail("jobs@apple.com") {
  // ⚠️ no information retained
}
```

> **Parsing**: Transforms a value of a less structured type into a value of a more structured type, or fails in the process:

```
if let email = Email("jobs@apple.com") {
   email // ✅ the parsed email is retained
}
```

_The difference between validation and parsing is in how information is retained._ In the Login screen example, we started with validation and replaced it with parsing, eliminating a whole class of bugs and vulnerabilities [1](https://swiftology.io/articles/tydd-part-2/#fn:1).

To really bring this home, look at this code:

```
let numString = "1"
let urlString = "https://apple.com/"

if Int(numString) != nil {
  // ⚠️ validation
}
if URL(string: urlString) != nil {
  // ⚠️ validation
}
```

You would never perform input validation with `Int` and `URL` like this. Instead, you'd try to initialize them from strings like this:

```
let numString = "1"
let urlString = "https://apple.com/"

if let number = Int(numString) {
  number // ✅ parsing
}
if let url = URL(string: urlString) {
  url // ✅ parsing
}
```

But we don't just initialize `Int` and `URL` from strings here, we _parse_`Int` and `URL` from stings. These initializers are just tiny little parsers. I really want you to internalise this notion. Parsers like this are everywhere, and you'll benefit a ton by recognising them and by getting used to creating ones yourself.

> **Insight💡:** Prefer **parsing** to **validation**. **Parsing** is the process of creating validated data from the unvalidated one. Types serve as vessels for validated data, carrying the validation invariants within them.

[Conclusion](https://swiftology.io/articles/tydd-part-2/#conclusion)
--------------------------------------------------------------------

"Type-safe validation" really just means **parsing**. But rather than simply titling this article "Parsing", I wanted us to arrive at this understanding by starting from first principles. In later articles in this series we'll return to parsers and discuss where to best place them within the structure of our programs to get the benefits of type-safe data flows at the architectural level. We'll also discuss error handling in more detail, since in this article whenever the parsing failed we just returned `nil` to signify the failure, thus losing this important information.

[📖 Part 3 Witness Pattern - type-safe access control ------------------------------------------](https://swiftology.io/articles/tydd-part-3/)

* * *

[Recommended reading](https://swiftology.io/articles/tydd-part-2/#recommended-reading)
--------------------------------------------------------------------------------------

*   [Parse, don't validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/) by Alexis King. This article, as evident by one of the section titles, was heavily influenced by the brilliant article by Alexis. Even though it's mostly targeted at Haskell programmers, I highly recommend reading it.
*   Parsing is a really deep and interesting topic. You can explore ideas like Parser Combinators for composing smaller parsers into bigger ones, allowing to tackle really complex parsing challenges in a controlled and predictable manner. You can look into the library [swift-parsing](https://github.com/pointfreeco/swift-parsing) by Point-free which implements many interesting parsing concepts. I also recommend their [Parsing](https://www.pointfree.co/collections/parsing) video series which goes really deep into fundamental parsing concepts and demonstrates how the library was built. Note that you'll need to be a paid subscriber to get the full access.

* * *

[Footnotes](https://swiftology.io/articles/tydd-part-2/#footnotes)
------------------------------------------------------------------

1.   Of course, parsers can have vulnerabilities and be exploited too. But crucially, this would be an issue with the parser itself, which could be fixed by patching the parser or moving to another, more secure version of the parser. Whereas conventional validation can lead to vulnerabilities at the systemic level, which can be incredibly hard or impossible to fix without rewriting the whole system.

[↩️](https://swiftology.io/articles/tydd-part-2/#fnref:1)

