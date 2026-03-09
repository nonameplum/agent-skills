Title: Fundamentals of type-driven code | Swiftology

URL Source: https://swiftology.io/articles/tydd-part-1-fundamentals/

Markdown Content:
With this series of articles, I have a lofty goal of shifting your Swift programming mindset. I know it sounds presumptuous, but this is exactly what happened to me a few years back when I was introduced to Type-Driven Design. I assure you, it’s not some new fad or an esoteric methodology. It’s a system of practical, well-researched, and time-tested ideas that form the basis for a powerful approach to writing high-quality, robust, and correct software.

The principles of Type-Driven Design are widely discussed in various functional programming communities but have yet to receive significant attention from the mainstream Swift community. The good news is that many Swift codebases already heavily lean on these principles, and I bet you are already familiar with many of them. However, there’s tremendous value in structuring fragmented knowledge into a cohesive system; that's when you gain truly deep insights.

So take a cup of coffee, and let’s dive in!

To develop an intuition for type-driven code we need to begin with something familiar.

As a Swift programmer, I’m sure you can immediately identify this code as problematic:

```
func main(number: Int?) {
  if number != nil {
  print("double:", 2 * number!)
} 
}
```

What's wrong with this code? Yes, we should use the `if let` optional unwrapping syntax here. But before we do, let's scrutinise this particular code.

Why _exactly_ is this code problematic? Well, we had to force unwrap the optional value. But is it really such a problem? Sure, this syntax is un-Swifty, but the logic is perfectly sound and safe since we're checking that the `number` is not `nil` before accessing it. We've been writing similar code in Objective-C for years!

The problem is not the force unwrapping itself, but the reason _why_ we have to force unwrap even after the `nil` check. To make the underlying problem more obvious, let's break the locality and introduce an external function that also takes an optional argument:

```
// Main.swift
func main(number: Int?) {
  if number != nil {
    save(number)		 
  }
}
```

```
// Save.swift
func save(_ number: Int?) {
  // ⚠️ We don't know 
// if number is nil or not,
// we must check ourselves!
if number != nil {
  UserDefaults.standard.set(
    number!, 
    forKey: "num"
  ) 
}
  else {
    print("Err: We don't want to store nils")
  }
}
```

> **Insight 💡:** The fundamental problem with this code is the _loss of information_. As soon as we check that `number` is not `nil` and step out of the `if` statement in `main`, we discard this information. And we must repeat the check again later in `save` function because it has no information about the check that's already been performed by `main`.

We want to retain the information that the `number` is not `nil` and propagate it forward. That's why we unwrap `number` and pass the non-optional value to the next function, eliminating the need for the repeated check:

```
func main(number: Int?) {
  if let number = number {
  save(number)
}
}

func save(_ num: Int) {
  UserDefaults.standard.set(number, forKey: "num") 
}
```

Of course, I'm not showing this just to remind you about the optional unwrapping and non-optional types.

This code is the example of information loss that every Swift programmer can immediately recognise and fix. But it's only because we've been conditioned to use the `if let` syntax for optional values. At the same time, many Swift programmers fail to recognise other instances of information loss when they deal with types that don't have a fancy syntax support.

Let's consider the second example:

```
func main(numbers: [Int]) {
  guard !numbers.isEmpty else {
    print("No numbers, sad")
    return
  }
  print("Cool numbers:", numbers)
}
```

This code looks absolutely fine and Swifty. There's no dodgy stuff like force unwrapping, and nothing that should trigger alarms in a Swift programmer's head. Yet, this code has the exact same kind of information loss as the previous one. And we can again reveal this with the help of an external function:

```
// Main.swift
func main(numbers: [Int]) {
  if !numbers.isEmpty {
    save(numbers)			 
  } else {
    print("No numbers, nothing to save...")
  }
}
```

```
// Save.swift
func save(_ numbers: [Int]) {
  // ⚠️ We don't know 
// if numbers are empty or not,
// and must check ourselves!
if !numbers.isEmpty {
  UserDefaults.standard.set(numbers, forKey: "numbers")
} 
  else {
    print("No numbers, nothing to save...")
  }
}
```

Since there's no fancy built-in syntax that allows us to easily remember that an array is not empty, it's very common for programmers to just ignore this inconvenience and allow such low quality code to proliferate.

To prevent the information loss in this example, we have to explicitly capture the `first` element of the array as a **proof** that it's not empty, and pass it forward to the next function:

```
func main(numbers: [Int]) {
  guard let first = numbers.first else { 
  print("No numbers, skipping...")
  return
}
let remaining = Array(numbers.dropFirst()) 
  save(first, remaining)	 
}

func save(
  _ first: Int,
_ remaining: [Int]
) {
  UserDefaults.standard.set(
    CollectionOfOne(first) + remaining, 
    forKey: "numbers"
  )
}
```

Look, we don't need to repeat `isEmpty` check anymore!

Of course, destructuring and reconstructing arrays like this everywhere would be a total chore, so we can incapsulate this process within the `NonEmptyArray` type:

```
struct NonEmptyArray<Element> {
  var first: Element
  var remaining: [Element]
  
  var arrayValue: [Element] { 
    CollectionOfOne(first) + remaining
  }
  
  init?(_ arrayValue: [Element]) {
    guard let first = arrayValue.first else {
      return nil
    }
    self.first = first
    remaining = Array(arrayValue.dropFirst())
  }
}
```

`NonEmptyArray` type leverages its internal structure to encode the **proof** that it's not empty. You can learn more about this technique in my article [Greater type safety with Structural Typing in Swift](https://swiftology.io/articles/structural-typing/).

Let's update the code:

```
func main(numbers: [Int]) {
  guard let nonEmptyNumbers = NonEmptyArray(numbers) else { 
  print("No numbers, skipping...")
  return
} 
  save(nonEmptyNumbers)	 
}

func save(_ numbers: NonEmptyArray<Int>) {
  UserDefaults.standard.set(
    numbers.arrayValue, 
    forKey: "numbers"
  )
}
```

> **Insight💡:** Use types to retain and propagate information, such as proofs of validation and domain-specific invariants.

Languages like Haskell, PureScript, and Elm even provide `NonEmpty` collection types with their standard libraries. It's truly indispensable and by the time you finish reading this series, you'll start seeing use cases for non-empty arrays everywhere in your codebase. For Swift, I recommend the time-tested open-source library from Point-Free - [swift-nonempty](https://github.com/pointfreeco/swift-nonempty).

[📖 Part 2 Type-safe validation --------------------](https://swiftology.io/articles/tydd-part-2/)

