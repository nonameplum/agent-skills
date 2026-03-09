---
name: background-tasks
description: Apple BackgroundTasks framework for iOS/iPadOS background processing. Use when scheduling background work, refreshing app content, running long processing tasks, implementing BGAppRefreshTask, BGProcessingTask, BGContinuedProcessingTask, or dealing with BGTaskScheduler setup, registration, submission, expiration handlers, and debugger testing commands.
---

# Background Tasks

Apple's BackgroundTasks framework for scheduling and running work while your app is suspended or backgrounded.

## Choose the right task type

| Goal | Task class | Time limit | Trigger |
|------|-----------|------------|---------|
| Short content refresh | `BGAppRefreshTask` | ~30 seconds | System-decided |
| Heavy processing (ML, DB, sync) | `BGProcessingTask` | Minutes | System-decided, device idle |
| Foreground job that must survive backgrounding | `BGContinuedProcessingTask` | Unlimited | User action only |
| Health research data processing | `BGHealthResearchTask` | Minutes | System-decided, device idle |

**Limits**: max 1 refresh task + 10 processing tasks schedulable at any time.

## Decision tree

1. **Setting up for the first time?**
   → `references/setup.md` (Info.plist keys, UIBackgroundModes, registration)

2. **Refreshing content periodically?**
   → `references/app-refresh.md` (BGAppRefreshTask, reschedule pattern)

3. **Running heavy background work?**
   → `references/processing.md` (BGProcessingTask, power/network requirements)

4. **Foreground task that must survive backgrounding?**
   → `references/continued-processing.md` (BGContinuedProcessingTask, GPU, progress, Live Activity)

5. **Managing task lifecycle (cancel, limits, pending tasks)?**
   → `references/scheduling.md`

6. **Handling submit errors?**
   → `references/error-handling.md` (notPermitted, tooManyPendingTaskRequests, unavailable)

7. **Testing during development?**
   → `references/testing.md` (LLDB debugger commands, device-only limitation)

## Key rules

- Register **all** launch handlers before `applicationDidFinishLaunching` returns.
- Always set `expirationHandler` — missing it causes the system to silently mark the task failed.
- Always call `setTaskCompleted(success:)` — missing it may cause the system to kill your app.
- Reschedule inside the launch handler, not after it returns.
- `BGContinuedProcessingTask` must be submitted as a result of a **user action**; it starts in the foreground.

## Reference files

- `references/setup.md` — Info.plist, UIBackgroundModes, registration
- `references/app-refresh.md` — BGAppRefreshTask pattern
- `references/processing.md` — BGProcessingTask pattern
- `references/continued-processing.md` — BGContinuedProcessingTask, GPU, progress reporting
- `references/scheduling.md` — earliestBeginDate, cancel, limits, pending task inspection
- `references/error-handling.md` — BGTaskScheduler.Error codes and causes
- `references/testing.md` — LLDB simulation commands
- `references/_index.md` — Full navigation index
- `backgroundtasks.md` — Full Apple API reference (raw docs)
