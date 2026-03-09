# BGAppRefreshTask

Short-lived background task for refreshing app content. The system grants up to **~30 seconds** of runtime and decides the best time to run it.

**Required UIBackgroundModes**: `fetch`

## When to use

- Polling a server for new content (messages, feeds, stock prices)
- Updating local state from a lightweight network request
- Prefetching data so the app feels instant on next launch

Do **not** use for CPU-heavy or long-running work — use `BGProcessingTask` instead.

## Full pattern

```swift
// 1. Register (in AppDelegate, before applicationDidFinishLaunching returns)
BGTaskScheduler.shared.register(
    forTaskWithIdentifier: "com.example.app.refresh",
    using: nil
) { task in
    guard let task = task as? BGAppRefreshTask else { return }
    handleAppRefresh(task)
}

// 2. Schedule
func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "com.example.app.refresh")
    // earliestBeginDate: nil = schedule as soon as possible
    request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // not before 15 min
    do {
        try BGTaskScheduler.shared.submit(request)
    } catch {
        print("Failed to schedule refresh: \(error)")
    }
}

// 3. Handle
func handleAppRefresh(_ task: BGAppRefreshTask) {
    // Reschedule first so the next run is queued even if this one expires
    scheduleAppRefresh()

    let workTask = Task {
        do {
            try await fetchLatestContent()
            task.setTaskCompleted(success: true)
        } catch {
            task.setTaskCompleted(success: false)
        }
    }

    // Expiration handler: system calls this shortly before time runs out
    task.expirationHandler = {
        workTask.cancel()
        task.setTaskCompleted(success: false)
    }
}
```

## Rules

- **Reschedule inside the handler**, before doing any work — if the task expires before you reschedule, the next run never gets queued.
- **Always call `setTaskCompleted(success:)`** — missing this may cause the system to kill your app.
- **Always set `expirationHandler`** — missing it causes the system to silently mark the task failed.
- The system may throttle frequency based on how often the user opens the app. Apps the user interacts with frequently get more opportunities.

## BGAppRefreshTaskRequest properties

| Property | Type | Notes |
|----------|------|-------|
| `identifier` | `String` | Read-only, set at init |
| `earliestBeginDate` | `Date?` | Minimum delay before the system runs the task. `nil` = ASAP |
