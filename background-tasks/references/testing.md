# Testing During Development

Background tasks are normally delayed by hours. During development, use the LLDB debugger to trigger them immediately.

> **Device only.** These commands do not work in Simulator. Simulator does not support background task execution at all — `submit(_:)` will throw `.unavailable`.

## Simulate task launch

1. Set a breakpoint in code that runs after a successful `submit(_:)` call.
2. Run the app on a physical device until the breakpoint hits.
3. In the Xcode debugger console, paste:

```
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.example.app.refresh"]
```

Replace `com.example.app.refresh` with your task's identifier.

4. Resume the app (`continue` in the debugger). The system calls your launch handler.

## Simulate task expiration

1. Set a breakpoint inside your running task handler.
2. Launch the task using the simulate command above.
3. Wait for the breakpoint to hit inside the handler.
4. In the debugger console, paste:

```
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"com.example.app.refresh"]
```

5. Resume. The system calls your `expirationHandler`.

## Checklist for a complete test run

- [ ] App registered the task identifier before `applicationDidFinishLaunching` returned
- [ ] Identifier in `BGTaskSchedulerPermittedIdentifiers` (Info.plist)
- [ ] `UIBackgroundModes` contains the right value (`fetch` or `processing`)
- [ ] Breakpoint set after `submit(_:)` succeeds
- [ ] Run on a **physical device**, not Simulator
- [ ] Simulate launch → verify handler executes and work starts
- [ ] Simulate expiration → verify `expirationHandler` cancels work cleanly and calls `setTaskCompleted(success: false)`
- [ ] Normal completion path → verify `setTaskCompleted(success: true)` is called

## Simulating BGContinuedProcessingTask cancellation

Simulate user cancellation (through the Live Activity) by forcing expiration:

```
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"com.example.app.video-export"]
```

Verify that `expirationHandler` is invoked and `setTaskCompleted(success: false)` is called.
