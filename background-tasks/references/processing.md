# BGProcessingTask

Long-running background task for intensive work. Runs while the device is **idle** (screen off, no active user). The system decides the best time; the task can run for **minutes**.

**Required UIBackgroundModes**: `processing`

## When to use

- Training or updating on-device ML models
- Database maintenance, large migrations, or index rebuilding
- Bulk sync with a server
- Processing large media files

Do **not** use for short content refreshes — use `BGAppRefreshTask` instead.

> The system terminates any BGProcessingTask if the user starts actively using the device. BGAppRefreshTask is not affected by this.

## Full pattern

```swift
// 1. Register (in AppDelegate, before applicationDidFinishLaunching returns)
BGTaskScheduler.shared.register(
    forTaskWithIdentifier: "com.example.app.db-cleanup",
    using: nil
) { task in
    guard let task = task as? BGProcessingTask else { return }
    handleDatabaseCleanup(task)
}

// 2. Schedule
func scheduleDatabaseCleanup() {
    let request = BGProcessingTaskRequest(identifier: "com.example.app.db-cleanup")
    request.requiresExternalPower = true      // prefer plugged-in device
    request.requiresNetworkConnectivity = false
    request.earliestBeginDate = Date(timeIntervalSinceNow: 60) // not before 1 minute
    do {
        try BGTaskScheduler.shared.submit(request)
    } catch {
        print("Failed to schedule processing: \(error)")
    }
}

// 3. Handle
func handleDatabaseCleanup(_ task: BGProcessingTask) {
    var isCancelled = false

    task.expirationHandler = {
        isCancelled = true
        // save any partial progress here
    }

    Task {
        await performCleanupInBatches(shouldCancel: { isCancelled })
        task.setTaskCompleted(success: !isCancelled)
    }
}
```

## BGProcessingTaskRequest properties

| Property | Type | Default | Notes |
|----------|------|---------|-------|
| `identifier` | `String` | — | Read-only, set at init |
| `earliestBeginDate` | `Date?` | `nil` | Minimum delay; `nil` = ASAP |
| `requiresNetworkConnectivity` | `Bool` | `false` | System only runs the task when network is available |
| `requiresExternalPower` | `Bool` | `false` | System only runs the task when device is charging |

## Rules

- **Always set `expirationHandler`** — use it to cancel work and save state.
- **Always call `setTaskCompleted(success:)`**.
- Design work to be **interruptible in batches** — the system can terminate the task at any time.
- Use `requiresExternalPower = true` for very heavy tasks (ML training, large video processing) to avoid draining the battery.
