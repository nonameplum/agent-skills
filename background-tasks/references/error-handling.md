# Error Handling

`BGTaskScheduler.shared.submit(_:)` throws `BGTaskScheduler.Error`. Always catch and handle it.

```swift
do {
    try BGTaskScheduler.shared.submit(request)
} catch let error as BGTaskScheduler.Error {
    switch error.code {
    case .notPermitted:
        // See below
    case .tooManyPendingTaskRequests:
        // See below
    case .unavailable:
        // See below
    case .immediateRunIneligible:
        // See below
    default:
        break
    }
} catch {
    print("Unexpected error: \(error)")
}
```

## Error codes

### `.notPermitted`

The app isn't permitted to schedule this task.

**Causes:**
1. The task identifier is not listed in `BGTaskSchedulerPermittedIdentifiers` in Info.plist.
2. The required `UIBackgroundModes` value (`fetch` or `processing`) is not set.

**Fix:** Check `setup.md` — both keys must be present and the identifier must match exactly (case-sensitive).

---

### `.tooManyPendingTaskRequests`

Too many pending tasks of the same type are already queued.

**Limits:** 1 refresh task, 10 processing tasks.

**Fix:** Cancel one or more existing requests before resubmitting:

```swift
BGTaskScheduler.shared.getPendingTaskRequests { requests in
    if let oldest = requests.first {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: oldest.identifier)
    }
    try? BGTaskScheduler.shared.submit(newRequest)
}
```

---

### `.unavailable`

The app or extension can't schedule background work at all.

**Causes:**
1. The user disabled "Background App Refresh" in Settings → General → Background App Refresh.
2. The app is running in **Simulator** — background task simulation is not supported (use a real device).
3. A keyboard/widget extension didn't set `RequestsOpenAccess = YES` in Info.plist, or the user didn't grant open access.

**Fix:** On device, prompt the user to re-enable background refresh. In development, switch to a physical device.

---

### `.immediateRunIneligible`

Only thrown for `BGContinuedProcessingTaskRequest` submitted with `strategy = .fail`.

**Cause:** The system is at its concurrent task limit and can't start the task immediately.

**Fix:** Either switch to `.queue` strategy (default), or cancel other pending tasks and retry:

```swift
request.strategy = .fail
do {
    try BGTaskScheduler.shared.submit(request)
} catch let error as BGTaskScheduler.Error where error.code == .immediateRunIneligible {
    BGTaskScheduler.shared.cancelAllTaskRequests()
    try? BGTaskScheduler.shared.submit(request)
}
```

## Expiration handler vs setTaskCompleted

These two are separate concerns:

| | `expirationHandler` | `setTaskCompleted(success:)` |
|-|---------------------|------------------------------|
| **Who calls it** | System (before time runs out) | Your code |
| **When** | Shortly before background time expires, or when user cancels (BGContinuedProcessingTask) | After your work finishes or in the expiration handler |
| **Missing it** | System marks task failed without warning | System may kill the app |

Always set the expiration handler. Always call `setTaskCompleted`.
