# BGContinuedProcessingTask

A task that **starts in the foreground** and can continue running in the background if the user leaves the app. Unlike other BGTask subclasses, this one is not scheduled — it runs immediately on submission.

The system shows the task's progress in a **Live Activity**, allowing the user to monitor it and cancel if desired.

**No UIBackgroundModes entry required.**

## When to use

- Exporting video in a film-editing or DAW app
- Compressing or applying filters to a batch of photos
- Uploading large files initiated by a user tap
- Running Core ML inference on a large dataset after user starts it

**Must be triggered by a user action** (e.g. tapping a button). Do not submit programmatically without user intent.

## Full pattern

```swift
private let taskIdentifier = "com.example.app.video-export"
private var submitted = false

// 1. Register (before applicationDidFinishLaunching returns)
func registerExportTask() {
    guard !submitted else { return }
    submitted = true

    BGTaskScheduler.shared.register(
        forTaskWithIdentifier: taskIdentifier,
        using: nil
    ) { task in
        guard let task = task as? BGContinuedProcessingTask else { return }
        performExport(task)
    }
}

// 2. Submit (call from a button action / user-initiated code path)
func startExport() {
    let request = BGContinuedProcessingTaskRequest(
        identifier: taskIdentifier,
        title: "Video Export",
        subtitle: "Starting…"
    )

    // Optional: request GPU (see GPU section below)
    if BGTaskScheduler.supportedResources.contains(.gpu) {
        request.requiredResources = .gpu
    }

    // Optional: fail immediately if system can't start right now
    // request.strategy = .fail   // default is .queue

    do {
        try BGTaskScheduler.shared.submit(request)
    } catch {
        print("Failed to submit export: \(error)")
    }
}

// 3. Perform work + report progress
func performExport(_ task: BGContinuedProcessingTask) {
    var wasExpired = false

    task.expirationHandler = {
        wasExpired = true
        // user cancelled via Live Activity, or system expired the task
    }

    task.progress.totalUnitCount = 100

    Task {
        for step in 1...100 {
            guard !wasExpired else { break }

            await exportChunk(step)

            task.progress.completedUnitCount = Int64(step)
            task.updateTitle("Video Export", subtitle: "Completed \(step)%")
        }

        task.setTaskCompleted(success: !wasExpired)
    }
}
```

## GPU access

Some devices support GPU usage in the background for continuous tasks. Check support before requesting:

```swift
if BGTaskScheduler.supportedResources.contains(.gpu) {
    request.requiredResources = .gpu
}
```

Requires the **Background GPU Access** entitlement (`Background GPU Access = true`). Enable via **Target → Signing & Capabilities → + Background GPU Access**.

Without the entitlement, setting `.gpu` on `requiredResources` has no effect.

## Submission strategies

| Strategy | Behavior |
|----------|----------|
| `.queue` (default) | System queues the task and starts it as soon as possible |
| `.fail` | Task submission fails immediately if the system can't start it right now |

Use `.fail` when the task is time-sensitive and queuing it for later would make no sense (e.g. a live recording session).

The `.fail` strategy throws `BGTaskScheduler.Error.Code.immediateRunIneligible` if the system is at capacity.

## Progress reporting

`BGContinuedProcessingTask` conforms to `ProgressReporting`. The system uses `task.progress` to:
- Display progress in the Live Activity
- Prioritize termination of tasks with minimal progress under resource pressure

Update `completedUnitCount` regularly. Tasks that show no progress are terminated first.

## BGContinuedProcessingTaskRequest properties

| Property | Type | Notes |
|----------|------|-------|
| `identifier` | `String` | Prefixed with bundle ID |
| `title` | `String` | Displayed in Live Activity |
| `subtitle` | `String` | Displayed in Live Activity |
| `requiredResources` | `Resources` | `.gpu` or default (CPU + network) |
| `strategy` | `SubmissionStrategy` | `.queue` or `.fail` |

## BGContinuedProcessingTask methods

| Method / Property | Notes |
|-------------------|-------|
| `task.progress` | `Progress` instance for reporting completion |
| `task.updateTitle(_:subtitle:)` | Update Live Activity display text |
| `task.expirationHandler` | Called when user cancels or system expires |
| `task.setTaskCompleted(success:)` | Must call when done |
