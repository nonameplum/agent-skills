# Scheduling

## Task limits

| Task type | Max pending |
|-----------|-------------|
| `BGAppRefreshTask` | 1 |
| `BGProcessingTask` / `BGHealthResearchTask` | 10 (combined) |
| `BGContinuedProcessingTask` | No queue limit; runs immediately or fails |

Submitting beyond the limit throws `BGTaskScheduler.Error.Code.tooManyPendingTaskRequests`.

Submitting a request with an identifier that already has a pending request **replaces** the existing one.

## earliestBeginDate

Controls the minimum time before the system will run the task. The system may run it later — this is a lower bound, not a guarantee.

```swift
// Run no earlier than 30 minutes from now
request.earliestBeginDate = Date(timeIntervalSinceNow: 30 * 60)

// Run as soon as possible
request.earliestBeginDate = nil
```

Note: `earliestBeginDate` is **ignored** for `BGContinuedProcessingTaskRequest` — the system always uses `Date.now`.

## Submitting a task

```swift
do {
    try BGTaskScheduler.shared.submit(request)
} catch {
    // See references/error-handling.md for error codes
    print("Submit failed: \(error)")
}
```

## Cancelling tasks

```swift
// Cancel one specific task by identifier
BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: "com.example.app.refresh")

// Cancel all pending tasks
BGTaskScheduler.shared.cancelAllTaskRequests()
```

Cancellation only affects **pending** (not yet running) tasks. A task already executing is not affected.

## Inspecting pending tasks

```swift
BGTaskScheduler.shared.getPendingTaskRequests { requests in
    for request in requests {
        print("\(request.identifier) — earliest: \(String(describing: request.earliestBeginDate))")
    }
}
```

The handler may run on a background thread. Objects in the array are **copies** — mutating them has no effect. To change a task's configuration, cancel and resubmit.

## Rescheduling pattern

Always reschedule at the **start** of the handler, not after `setTaskCompleted`:

```swift
func handleAppRefresh(_ task: BGAppRefreshTask) {
    scheduleAppRefresh()    // reschedule first

    task.expirationHandler = { task.setTaskCompleted(success: false) }

    Task {
        await doWork()
        task.setTaskCompleted(success: true)
    }
}
```

This ensures the next execution is queued even if the current run expires mid-work.
