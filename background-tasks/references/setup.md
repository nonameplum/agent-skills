# Setup

## Info.plist

Two keys are required before any task will work.

### BGTaskSchedulerPermittedIdentifiers

List every task identifier your app will ever register. Using an identifier not in this list causes a `.notPermitted` error at submit time.

```xml
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
    <string>com.example.app.refresh</string>
    <string>com.example.app.processing</string>
</array>
```

Use reverse-DNS style prefixed with your bundle ID. Make the suffix descriptive: `db-cleanup`, `content-sync`, `video-export`.

### UIBackgroundModes

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>        <!-- required for BGAppRefreshTask -->
    <string>processing</string>   <!-- required for BGProcessingTask / BGHealthResearchTask -->
</array>
```

`BGContinuedProcessingTask` does not require a UIBackgroundModes entry.

## Xcode capability shortcut

Enable via **Target → Signing & Capabilities → + Background Modes**:
- "Background fetch" → adds `fetch`
- "Background processing" → adds `processing`

Xcode writes both the capability and the Info.plist key automatically.

## Handler registration

Register **all** handlers before `applicationDidFinishLaunching(_:)` returns. The system ignores registrations made after that point.

```swift
// AppDelegate
func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    registerBackgroundTasks()
    return true
}

private func registerBackgroundTasks() {
    BGTaskScheduler.shared.register(
        forTaskWithIdentifier: "com.example.app.refresh",
        using: nil   // nil = default background queue
    ) { task in
        guard let task = task as? BGAppRefreshTask else { return }
        AppRefreshHandler.shared.handle(task)
    }

    BGTaskScheduler.shared.register(
        forTaskWithIdentifier: "com.example.app.processing",
        using: nil
    ) { task in
        guard let task = task as? BGProcessingTask else { return }
        ProcessingHandler.shared.handle(task)
    }
}
```

For SwiftUI apps using `@main`, attach via `UIApplicationDelegateAdaptor` or the `.onBackground` modifier and check the scene phase — registration still must complete at launch.

## Verification

`register(forTaskWithIdentifier:using:launchHandler:)` returns `false` if the identifier is missing from `BGTaskSchedulerPermittedIdentifiers`. Log the return value during development:

```swift
let registered = BGTaskScheduler.shared.register(
    forTaskWithIdentifier: identifier,
    using: nil
) { task in ... }

assert(registered, "Failed to register \(identifier) — check BGTaskSchedulerPermittedIdentifiers")
```
