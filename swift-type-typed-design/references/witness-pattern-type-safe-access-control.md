Title: Witness pattern — type-safe access control | Swiftology

URL Source: https://swiftology.io/articles/tydd-part-3/

Markdown Content:
A common challenge in software design is ensuring that access to a certain functionality is restricted under specific preconditions. For example:

*   Access to the Home Screen must be limited to authenticated users.
*   Access to 24/7 Chat Support must be limited to premium users.
*   Access to an experimental AI Assistant must be controlled by a feature flag.

Let's take the example of an AI Assistant hidden behind a feature flag. Feature flagging is a technique for dynamically controlling which functionalities are available to users in a live app. These flags are commonly configured by backend services and fetched by client applications upon launch. A typical JSON response looks like this:

```
{
  "feature-flags": {
     "ai-assistant-enabled": true,
     ...
  }
}
```

[Access control: a naïve design](https://swiftology.io/articles/tydd-part-3/#access-control-a-na%C3%AFve-design)
----------------------------------------------------------------------------------------------------------------

A naïve way of enforcing access control is by using conditional boolean logic. The JSON response mentioned above would be decoded into this Swift type:

```
struct FeatureFlags: Codable {
  let isAIAssistantEnabled: Bool
  ...
  enum CodingKeys: String, CodingKey {
    case isAIAssistantEnabled = "ai-assistant-enabled"
    ...
  }
}
```

We use this feature flag to control access to the AI Assistant screen:

```
struct AIAssistantScreen: View { ... }

enum Path {
  case aiAssistant
  ...
}

struct Root: View {
  let featureFlags: FeatureFlags
  @State var path: [Path] = []
  
  var body: some View {
    NavigationStack(path: $path) {
      // ✅ Only accessible
// when feature flag is enabled
if !featureFlags.isAIAssistantEnabled {
  Button("AI Assistant") {
    path.append(.aiAssistant)
  }
} 
      ...
    }
    .navigationDestination(for: Path.self) { path in
      switch path {
      case .aiAssistant:
  AIAssistantScreen()
      ...
      }
    }
  }
}
```

While this approach is straightforward and intuitive, it offers virtually no compile-time guarantees that access control has been enforced correctly. In fact, I’ve intentionally made a mistake in the condition, I hope you’ve spotted it 😉.

Furthermore, even if we correctly implement and test the access control logic here, there’s nothing that prevents developers from adding other entry points into the AI Assistant without properly enforcing the access control.

For instance, another developer could add a deep link and forget to check the feature flag:

```
struct Root: View {
  ...
  var body: some View {
    NavigationStack(path: $path) {
      if featureFlags.isAIAssistantEnabled {
        Button("AI Assistant") {
          path.append(.aiAssistant)
        }
      }
    }
    .navigationDestination(for: Path.self) { ... }
     // Called when the app receives a URL
.onOpenURL { url in
  switch url.path() {
  case "/ai-assistant":
    // ⚠️ Forgot to check the feature flag!
    path.append(.aiAssistant)
  default:
    break
  }
}
  }
}
```

It’s common for apps to have multiple entry points into the same feature. These entry points can be the navigation links in various parts of the UI, promotional banners, deep links, search results, etc. In large teams, different developers or even teams may be responsible for different entry points. Additionally, access control conditions can change over time, necessitating updates to all entry points.

To manage this complexity, teams often introduce auxiliary systems like Factories and Builders to encapsulate the access control logic. While this approach certainly has its merits, it still fundamentally relies on the convention and discipline of developers to know and use these systems. Unfortunately, convention and discipline are policies that don't scale well. We can do better than that.

[Access control: type-safe design with Witnesses](https://swiftology.io/articles/tydd-part-3/#access-control-type-safe-design-with-witnesses)
---------------------------------------------------------------------------------------------------------------------------------------------

**We need to turn the convention into a requirement.** This means that the code must fail to compile if access control isn't enforced correctly.

At present, `AIAssistantScreen`can be instantiated and accessed freely as long as the `path` is set to `aiAssistant`:

```
struct Root: View {
  ...
  var body: some View {
    NavigationStack(path: $path) { ... }
    .navigationDestination(for: Path.self) { path in
      switch path {
      case .aiAssistant:
  AIAssistantScreen()
      }
    }
  }
}
```

We need to modify the initializer of `AIAssistantScreen` to require a solid proof that the feature is indeed enabled:

```
struct AIAssistantScreen: View {
  init(proof: ???) {}
}
```

Let's introduce a new strong type that represents the precondition of the AI Assistant being enabled:

```
struct AIAssistantEnabled {}

struct AIAssistantScreen: View {
  init(proof: AIAssistantEnabled) {}
}
```

This change immediately raises the compilation error:

```
struct Root: View {
  ...
  .navigationDestination(for: Path.self) { path in
    switch path {
    case .aiAssistant:
      // ❌ ERROR: Requires the feature flag!
AIAssistantScreen(proof: ???)
    }
  }
}
```

We're getting somewhere, but this proof is worthless because we can easily forge it:

```
struct Root: View {
  ...
  .navigationDestination(for: Path.self) { path in
    switch path {
    case .aiAssistant:
      AIAssistantScreen(
        // ⚠️ Easily forgeable flag
proof: AIAssistantEnabled()
      )
    }
  }
}
```

Our flag proves nothing right now, and we need to turn it into a proper **Witness**.

[Introducing a Witness](https://swiftology.io/articles/tydd-part-3/#introducing-a-witness)
------------------------------------------------------------------------------------------

> **Definition** 📖: **Witness** is a value that serves as evidence of the truth of some precondition, for example that the AI Assistant feature is available. The term "witness" originates from [proof theory](https://en.wikipedia.org/wiki/Witness_(mathematics)).

> - A **Witness** proves preconditions by construction. "By construction" means that the act of creating a witness value is equivalent to creating a proof of the precondition that this witness represents. We embed the proof of the precondition into the witness by initialising it. See:[Curry-Howard correspondence](https://en.wikipedia.org/wiki/Curry%E2%80%93Howard_correspondence).

> - Access control to restricted code can be enforced at compile time by requiring a **witness** value as a non-optional argument.

We need to set up our flag's initialisation process in a way that gives a _sufficiently strong_ guarantee that it's been created during the decoding of the feature flags JSON response:

```
// FeatureFlags.swift

struct AIAssistantEnabled {
  // ✅ Can only be initialized in this file
fileprivate init() {}
}

struct FeatureFlags: Decodable {
  // ✅ Replace Bool with optional strong type
// let isAIAssistantEnabled: Bool
let aiAssistantEnabled: AIAssistantEnabled?
  
  enum CodingKeys: String, CodingKey {
    case isAIAssistantEnabled = "ai-assistant-enabled"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let isAIAssistantEnabled = try container.decode(
      Bool.self,
      forKey: .isAIAssistantEnabled
    )
    // Embed the proof into the witness
self.aiAssistantEnabled = isAIAssistantEnabled ? AIAssistantEnabled() : nil
  }
}
```

Now, the flag can't be easily forged:

```
// Root.swift
...
.navigationDestination(for: Path.self) { path in
  switch path {
  case .aiAssistant:
    AIAssistantScreen(
      // ❌ ERROR: private initializer
proof: AIAssistantEnabled()  
    )
  }
}
```

It's still _possible_ to forge the flag by decoding a hardcoded json string...

```
...
.navigationDestination(for: Path.self) { path in
  switch path {
  case .aiAssistant:
      // ✅ Annoyingly hard to forge the flag
let json = """
{
  "ai-assistant-enabled": true
}
""".data(using: .utf8)!
let flags = try! JSONDecoder().decode(
  FeatureFlags.self, 
  from: json
)
AIAssistantScreen(proof: flags.aiAssistantEnabled!)
  }
}
```

...but this is not a huge problem. Remember, the goal of type-safe access control is not to build an airtight secure system [1](https://swiftology.io/articles/tydd-part-3/#fn:1). It's to build a system that catches mistakes at compile time and provides clear error messages that communicate requirements and guide toward the correct solution.

To finalise our type-safe API, let's replace the feature flag argument variable with a "black hole":

```
struct AIAssistantScreen: View {
  // "black hole" argument
  //  👇
  init(_: AIAssistantEnabled) {}
}
```

> **Insight💡:** the "black hole" argument clearly communicates: this value is required _only_ as a proof of some state invariant. In this case, that the app was launched with the AI Assistant enabled.

This new requirement propagates backward through the codebase all the way to where feature flags are handled and distributed to consumers:

```
struct AIAssistantScreen: View {
  init(_: AIAssistantEnabled) {}
}
enum Path {
  case aiAssistant(AIAssistantEnabled)
}
struct Root: View {
  let featureFlags: FeatureFlags
  @State var path: [Path] = []
  
  var body: some View {
    NavigationStack(path: $path) {
      if let aiAssistantEnabled = featureFlags.aiAssistantEnabled {
        Button("AI Assistant") {       
          path.append(.aiAssistant(aiAssistantEnabled))
        }
      }
    }
    .navigationDestination(for: Path.self) { path in
      switch path {
      case let .aiAssistant(aiAssistantEnabled):
        AIAssistantScreen(aiAssistantEnabled)
      }
    }
  }
}
```

Now, if another developer adds a new entry point and forgets to enforce access control, they will be immediately confronted with a compilation error:

```
struct Root: View {
  ...
  var body: some View {
    NavigationStack(path: $path) { ... }
    .navigationDestination(for: Path.self) { ... }
    .onOpenURL { url in
  switch url.path() {
  case "/ai-assistant":
    // ❌ ERROR: missing the feature flag!
    path.append(.aiAssistant(???))
  default:
    break
  }
}
  }
}
```

We've successfully turned the convention into a requirement!

[Other examples](https://swiftology.io/articles/tydd-part-3/#other-examples)
----------------------------------------------------------------------------

Witnesses can be created for all sorts of preconditions.

If we require a witness for a premium user, and it's currently defined as an `isPremium: Bool` field on the `User` type, we can employ the same technique of mapping a boolean to a strong type:

```
//----User.swift----
struct PremiumMember {
  fileprivate init() {}
}

class User: Decodable {
  let username: String
  ...
  // isPremiumMember: Bool
  let premiumMember: PremiumMember?
  
  init(from decoder: Decoder) throws {
    // map bool to PremiumMember
  }
}

//----PremiumFeature.swift----
func launchPremiumFeature(_: PremiumMember, args:...) {}
```

Or, suppose we have a complex video editing feature with a ton of moving parts. To minimise the risk of data loss, we want to ensure that we _never_ upload a video to a server without first saving it to disk. In this case, we could protect the `upload` operation by requiring proof that the video was saved:

```
//----VideoStorage.swift----
struct SavedVideo {
  let videoData: Data
  fileprivate init(_ videoData: Data) {
  self.videoData = videoData
}
}

class VideoStorage {
  func save(_ videoData: Data) async throws -> SavedVideo {
    // saving a video...
    return SavedVideo(videoData) // proof embedding
  }
}

//----VideoUploader.swift----
class VideoUploader {
  // Proof requirement
  func upload(_ savedVideo: SavedVideo) async {...}
}

//----VideoEditor.swift----
class VideoEditor {
  let videoData: Data
  let videoStorage: VideoStorage
  let videoUploader: VideoUploader
  
  func doComplexStuff() {
    ...
    Task {
      // ✅ Correct order of operations
let savedVideo = try await storage.save(videoData)
await uploader.upload(savedVideo)
    }
  }

  func doMoreComplexStuff() {
    ...
    Task {
      // ❌ ERROR: Must save the video first!
await uploader.upload(videoData)
try await storage.save(videoData)
    }
  }
}
```

Again, some form of encapsulation could work here too, but a formal compile-time requirement leaves minimal room for mistakes.

[Conclusion](https://swiftology.io/articles/tydd-part-3/#conclusion)
--------------------------------------------------------------------

The **Witness** is a simple yet powerful design pattern for enforcing type-safe access control. Chances are, you are already using it in scenarios where access preconditions coincide with certain data requirements. For instance, a feature must be limited to an authenticated `User` and also relies on the `User` data itself to function. In which case you naturally just make `User` a required argument, inadvertently protecting access to the feature. However, with the insights from this article, strive to be more conscious of these design intricacies. Pay attention to scenarios where access preconditions don't align with data requirements, and think how you could create lightweight witnesses of such preconditions.

And remember to use your best judgement. In some cases type-safe access control is a no-brainer. But in others, you might just want to [move fast and break things](https://github.com/facebook/facebook-ios-sdk/issues/1374#issuecomment-624939133).

[📖 Part 4 Domain modeling with types --------------------------](https://swiftology.io/articles/tydd-part-4/)

* * *

[Recommended reading](https://swiftology.io/articles/tydd-part-3/#recommended-reading)
--------------------------------------------------------------------------------------

*   [Types as Proof - Matt Diephouse](https://matt.diephouse.com/2018/11/types-as-proof/). I was originally introduced to the witness pattern by my former colleague, Matt. In his article, Matt provides a deeper theoretical context for the witness pattern and showcases some excellent practical examples.
*   [Witnesses - Will Crichton](https://willcrichton.net/rust-api-type-patterns/witnesses.html). In his article, Will demonstrates the witness pattern using Rust programming language. I also recommend checking out other articles from his series on Type-Driven APIs in Rust.

* * *

[Footnotes](https://swiftology.io/articles/tydd-part-3/#footnotes)
------------------------------------------------------------------

1.   
Another concept loosely related to **witnesses**, known as **proof-carrying data** (PCD). Proof-carrying data is a security mechanism used in mutually-distrustful systems. It involves attaching evidence or proofs alongside the data to show that the data is safe and follows certain rules or requirements.

For example, if you're sending a piece of code to a remote server for execution, you can attach proofs that demonstrate that the code is correct and isn't malicious. This way, the server can quickly verify the safety of the code before running it, without needing to fully analyse it.

    *   Theory: [Proof-Carrying Data and Hearsay Arguments - Chiesa, Tromer](https://projects.csail.mit.edu/pcd/)
    *   Examples: [Zupass - Github](https://github.com/proofcarryingdata/zupass)

[↩️](https://swiftology.io/articles/tydd-part-3/#fnref:1)

