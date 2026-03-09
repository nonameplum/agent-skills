# Reference Index

Quick navigation for Background Tasks topics.

## Setup & Configuration

| File | Description |
|------|-------------|
| `setup.md` | Info.plist keys, UIBackgroundModes, handler registration |

## Task Types

| File | Description |
|------|-------------|
| `app-refresh.md` | BGAppRefreshTask — short content refresh (~30s), reschedule pattern |
| `processing.md` | BGProcessingTask — long background work, power/network requirements |
| `continued-processing.md` | BGContinuedProcessingTask — foreground job with background continuation, GPU, progress |

## Lifecycle & Debugging

| File | Description |
|------|-------------|
| `scheduling.md` | earliestBeginDate, cancel, task limits, inspecting pending requests |
| `error-handling.md` | BGTaskScheduler.Error codes and how to resolve each |
| `testing.md` | LLDB commands for simulating launch and expiration on device |

## Quick Links by Problem

### "I need to..."

- **Add background refresh to my app** → `setup.md`, then `app-refresh.md`
- **Run a long task overnight** → `setup.md`, then `processing.md`
- **Export/process while user navigates away** → `continued-processing.md`
- **Cancel a scheduled task** → `scheduling.md`
- **Test without waiting hours** → `testing.md`

### "I'm getting an error about..."

- **notPermitted** → `error-handling.md` + `setup.md` (missing Info.plist key or UIBackgroundModes)
- **tooManyPendingTaskRequests** → `error-handling.md` + `scheduling.md`
- **unavailable** → `error-handling.md` (Simulator, background refresh disabled)
- **immediateRunIneligible** → `error-handling.md` (BGContinuedProcessingTask .fail strategy)

## Full API Reference

See `backgroundtasks.md` (parent folder) for the complete Apple documentation dump.
