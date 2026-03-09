<!--
Downloaded via https://llm.codes by @steipete on February 26, 2026 at 01:31 PM
Source URL: https://developer.apple.com/documentation/backgroundtasks
Total pages processed: 146
URLs filtered: Yes
Content de-duplicated: Yes
Availability strings filtered: Yes
Code blocks only: No
-->

# https://developer.apple.com/documentation/backgroundtasks

Framework

# Background Tasks

Support background processing in your app by wrapping your app’s most critical work in framework-provided tasks.

## Overview

Use this framework to keep your app content up to date and run tasks requiring minutes to complete even if your app is in the background. Longer tasks can leverage external power, network connectivity, and the GPU on supported devices.

To launch your app in the background and perform necessary work, register launch handlers for framework-provided tasks and schedule the tasks as needed.

Your app can also use a framework-provided task to execute critical jobs in the foreground and complete them in the background if a person backgrounds your app before the job completes.

## Topics

### Essentials

Background Tasks updates

Learn about important changes in Background Tasks.

`class BGTaskScheduler`

A class for scheduling tasks that add background support to your app’s most critical work.

`class BGTask`

An abstract class for the framework’s tasks.

### Background tasks

Using background tasks to update your app

Configure your app to perform tasks in the background to make efficient use of processing time and power.

Refreshing and Maintaining Your App Using Background Tasks

Use scheduled background tasks for refreshing your app content and for performing maintenance.

Choosing Background Strategies for Your App

Select the best method of scheduling background runtime for your app.

`class BGProcessingTask`

A time-consuming processing task that runs while the app is in the background.

`class BGAppRefreshTask`

An object representing a short task typically used to refresh content that’s run while the app is in the background.

`class BGHealthResearchTask`

A time-consuming, necessary processing task that runs while the app is in the background to prepare data essential to a health research study.

### Foreground tasks with background support

Performing long-running tasks on iOS and iPadOS

Use a continuous background task to do work that can complete as needed.

`class BGContinuedProcessingTask`

A task that starts in the foreground and can continue running in the background as needed.

`Background GPU Access`

The entitlement the system requires for a continuous background task to use the GPU.

### Task requests

`class BGProcessingTaskRequest`

A request to launch your app in the background to execute a processing task that can take minutes to complete.

`class BGAppRefreshTaskRequest`

A request to launch your app in the background to execute a short refresh task.

`class BGTaskRequest`

An abstract class for representing task requests.

`class BGHealthResearchTaskRequest`

A request to launch your app in the background to execute processing for a health research study in which a user participates.

`class BGContinuedProcessingTaskRequest`

A request for a workload that the system continues processing even if a person backgrounds the app.

### Development and testing

Starting and Terminating Tasks During Development

Use the debugger during development to start tasks and to terminate them before completion.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler

- Background Tasks
- BGTaskScheduler

Class

# BGTaskScheduler

A class for scheduling tasks that add background support to your app’s most critical work.

class BGTaskScheduler

## Mentioned in

Performing long-running tasks on iOS and iPadOS

## Overview

Background tasks give your app a way to run code even when the app is suspended:

- To register, schedule, and run tasks in the background, see Using background tasks to update your app.

- To submit work in the foreground that can finish even if the app moves to the background, see Performing long-running tasks on iOS and iPadOS.

## Topics

### Getting the shared task scheduler

`class var shared: BGTaskScheduler`

The shared background task scheduler instance.

### Checking task requirements

`class var supportedResources: BGContinuedProcessingTaskRequest.Resources`

Additional system resources that a continuous background task can request.

### Scheduling a task

Register a launch handler for the task with the associated identifier that’s executed on the specified queue.

`func submit(BGTaskRequest) throws`

Submit a previously registered background task for execution.

### Canceling a task

`func cancel(taskRequestWithIdentifier: String)`

Cancel a previously scheduled task request.

`func cancelAllTaskRequests()`

Cancel all scheduled task requests.

### Getting all scheduled tasks

Request a list of unexecuted scheduled task requests.

### Handling errors

`struct Error`

The Errors for the `BGTaskSchedulerError` domain.

`enum Code`

An enumeration of the task scheduling errors.

`class let errorDomain: String`

The background tasks error domain as a string.

## Relationships

### Inherits From

- `NSObject`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`

## See Also

### Essentials

Background Tasks updates

Learn about important changes in Background Tasks.

`class BGTask`

An abstract class for the framework’s tasks.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtask

- Background Tasks
- BGTask

Class

# BGTask

An abstract class for the framework’s tasks.

class BGTask

## Mentioned in

Performing long-running tasks on iOS and iPadOS

## Overview

With the exception of `BGContinuedProcessingTask`, which your app executes in the foreground, the system executes `BGTask` subclasses on behalf of your app, while your app is in the background.

## Topics

### Reading Task Information

`var identifier: String`

The string identifier of the task.

### Configuring a Task

A handler called shortly before the task’s background time expires.

`func setTaskCompleted(success: Bool)`

Informs the background task scheduler that the task is complete.

## Relationships

### Inherits From

- `NSObject`

### Inherited By

- `BGAppRefreshTask`
- `BGContinuedProcessingTask`
- `BGProcessingTask`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`

## See Also

### Essentials

Background Tasks updates

Learn about important changes in Background Tasks.

`class BGTaskScheduler`

A class for scheduling tasks that add background support to your app’s most critical work.

---

# https://developer.apple.com/documentation/backgroundtasks/refreshing-and-maintaining-your-app-using-background-tasks

- Background Tasks
- Refreshing and Maintaining Your App Using Background Tasks

Sample Code

# Refreshing and Maintaining Your App Using Background Tasks

Use scheduled background tasks for refreshing your app content and for performing maintenance.

Download

Xcode 14.3+

## Overview

This sample code project must be run on a physical device.

## See Also

### Background tasks

Using background tasks to update your app

Configure your app to perform tasks in the background to make efficient use of processing time and power.

Choosing Background Strategies for Your App

Select the best method of scheduling background runtime for your app.

`class BGProcessingTask`

A time-consuming processing task that runs while the app is in the background.

`class BGAppRefreshTask`

An object representing a short task typically used to refresh content that’s run while the app is in the background.

`class BGHealthResearchTask`

A time-consuming, necessary processing task that runs while the app is in the background to prepare data essential to a health research study.

---

# https://developer.apple.com/documentation/backgroundtasks/choosing-background-strategies-for-your-app

- Background Tasks
- Choosing Background Strategies for Your App

Article

# Choosing Background Strategies for Your App

Select the best method of scheduling background runtime for your app.

## Overview

If your app needs computing resources to complete tasks when it’s not running in the foreground, you can select from many strategies to obtain background runtime. Selecting the right strategies for your app depends on how it functions in the background.

Some apps perform work for a short time while in the foreground and must continue uninterrupted if they go to the background. Other apps defer that work to perform in the background at a later time or even at night while the device charges. Some apps need background processing time at varied and unpredictable times, such as when an external event or message arrives.

Apps involved in health research studies can obtain background runtime to process data essential for the study. Apps can also request to launch in the background for studies in which the user participates.

Select one or more methods for your app based on how you schedule activity in the background.

### Continue Foreground Work in the Background

The system may place apps in the background at any time. If your app performs critical work that must continue while it runs in the background, use `beginBackgroundTask(withName:expirationHandler:)` to alert the system. Consider this approach if your app needs to finish sending a message or complete saving a file.

The system grants your app a limited amount of time to perform its work once it enters the background. Don’t exceed this time, and use the expiration handler to cover the case where the time has depleted to cancel or defer the work.

Once your work completes, call `endBackgroundTask(_:)` before the time limit expires so that your app suspends properly. The system terminates your app if you fail to call this method.

If the task is one that takes some time, such as downloading or uploading files, use `URLSession`. See Downloading files in the background for more information.

### Defer Intensive Work

To preserve battery life and performance, you can schedule backgrounds tasks for periods of low activity, such as overnight when the device charges. Use this approach when your app manages heavy workloads, such as training machine learning models or performing database maintenance.

Schedule these types of background tasks using `BGProcessingTask`, and the system decides the best time to launch your background task.

Apps involved in health research studies can have time-consuming tasks essential for the study and might need to complete processing the background. Schedule these types of background tasks using `BGHealthResearchTask`.

### Update Your App’s Content

Your app may require short bursts of background time to perform content refresh or other work; for example, your app may fetch content from the server periodically, or regularly update its internal state. In this situation, use `BGAppRefreshTask` by requesting `BGAppRefreshTaskRequest`.

Your app can use `BGHealthResearchTaskRequest` to launch in the background and process data for a health research study in which the user participates.

The system decides the best time to launch your background task, and provides your app up to 30 seconds of background runtime. Complete your work within this time period and call `setTaskCompleted(success:)`, or the system terminates your app. See Background Tasks for more information.

### Wake Your App with a Background Push

Background pushes silently wake your app in the background. They don’t display an alert, play a sound, or badge your app’s icon. If your app obtains content from a server infrequently or at irregular intervals, use background pushes to notify your app when new content becomes available. A messaging app with a muted conversation might use a background push solution, and so might an email app that processes incoming mail without alerting the user.

When sending a background push, set `content-available`: to `1` without `alert`, `sound`, or `badge`. The system decides when to launch the app to download the content. To ensure your app launches, set `apns-priority`to `5`, and `apns-push-type` to `background`.

Once the system delivers the remote notification with `application(_:didReceiveRemoteNotification:fetchCompletionHandler:)`, your app has up to 30 seconds to complete its work. After your app performs the work, call the passed completion handler as soon as possible to conserve power. If you send background pushes more frequently than three times per hour, the system imposes rate limitations. See Pushing background updates to your App for more information.

### Request Background Time and Notify the User

If your app needs to perform a task in the background and show a notification to the user, use a Notification Service Extension. For example, an email app might need to notify a user after downloading a new email. Subclass `UNNotificationServiceExtension` and bundle the system extension with your app. Upon receiving a push notification, your service extension wakes up and obtains background runtime through `didReceive(_:withContentHandler:)`.

When your extension completes its work, it must call the content handler with the content you want to deliver to the user. Your extension has a limited amount of time to modify the content and execute the `contentHandler` block.

## See Also

### Background tasks

Using background tasks to update your app

Configure your app to perform tasks in the background to make efficient use of processing time and power.

Refreshing and Maintaining Your App Using Background Tasks

Use scheduled background tasks for refreshing your app content and for performing maintenance.

`class BGProcessingTask`

A time-consuming processing task that runs while the app is in the background.

`class BGAppRefreshTask`

An object representing a short task typically used to refresh content that’s run while the app is in the background.

`class BGHealthResearchTask`

A time-consuming, necessary processing task that runs while the app is in the background to prepare data essential to a health research study.

---

# https://developer.apple.com/documentation/backgroundtasks/bgprocessingtask

- Background Tasks
- BGProcessingTask

Class

# BGProcessingTask

A time-consuming processing task that runs while the app is in the background.

class BGProcessingTask

## Mentioned in

Choosing Background Strategies for Your App

## Overview

Use processing tasks for long data updates, processing data, and app maintenance. Although processing tasks can run for minutes, the system can interrupt the process. Add an expiration handler by setting `expirationHandler` for any required cleanup.

Executing processing tasks requires setting the `processing` `UIBackgroundModes` capability. For information on setting this capability, see `BGTaskScheduler`.

Processing tasks run only when the device is idle. The system terminates any background processing tasks running when the user starts using the device. Background refresh tasks aren’t affected.

## Relationships

### Inherits From

- `BGTask`

### Inherited By

- `BGHealthResearchTask`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`

## See Also

### Background tasks

Using background tasks to update your app

Configure your app to perform tasks in the background to make efficient use of processing time and power.

Refreshing and Maintaining Your App Using Background Tasks

Use scheduled background tasks for refreshing your app content and for performing maintenance.

Select the best method of scheduling background runtime for your app.

`class BGAppRefreshTask`

An object representing a short task typically used to refresh content that’s run while the app is in the background.

`class BGHealthResearchTask`

A time-consuming, necessary processing task that runs while the app is in the background to prepare data essential to a health research study.

---

# https://developer.apple.com/documentation/backgroundtasks/bgapprefreshtask

- Background Tasks
- BGAppRefreshTask

Class

# BGAppRefreshTask

An object representing a short task typically used to refresh content that’s run while the app is in the background.

class BGAppRefreshTask

## Mentioned in

Choosing Background Strategies for Your App

## Overview

Use app refresh tasks for updating your app with small bits of information, such as the latest stock values.

Executing app refresh tasks requires setting the `fetch` `UIBackgroundModes` capability. For information on setting this capability, see `BGTaskScheduler`.

## Relationships

### Inherits From

- `BGTask`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`

## See Also

### Background tasks

Using background tasks to update your app

Configure your app to perform tasks in the background to make efficient use of processing time and power.

Refreshing and Maintaining Your App Using Background Tasks

Use scheduled background tasks for refreshing your app content and for performing maintenance.

Select the best method of scheduling background runtime for your app.

`class BGProcessingTask`

A time-consuming processing task that runs while the app is in the background.

`class BGHealthResearchTask`

A time-consuming, necessary processing task that runs while the app is in the background to prepare data essential to a health research study.

---

# https://developer.apple.com/documentation/backgroundtasks/bghealthresearchtask

- Background Tasks
- BGHealthResearchTask

Class

# BGHealthResearchTask

A time-consuming, necessary processing task that runs while the app is in the background to prepare data essential to a health research study.

tvOS

class BGHealthResearchTask

## Mentioned in

Choosing Background Strategies for Your App

## Relationships

### Inherits From

- `BGProcessingTask`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`

## See Also

### Background tasks

Using background tasks to update your app

Configure your app to perform tasks in the background to make efficient use of processing time and power.

Refreshing and Maintaining Your App Using Background Tasks

Use scheduled background tasks for refreshing your app content and for performing maintenance.

Select the best method of scheduling background runtime for your app.

`class BGProcessingTask`

A time-consuming processing task that runs while the app is in the background.

`class BGAppRefreshTask`

An object representing a short task typically used to refresh content that’s run while the app is in the background.

---

# https://developer.apple.com/documentation/backgroundtasks/performing-long-running-tasks-on-ios-and-ipados

- Background Tasks
- Performing long-running tasks on iOS and iPadOS

Article

# Performing long-running tasks on iOS and iPadOS

Use a continuous background task to do work that can complete as needed.

## Overview

On iOS and iPadOS, apps can execute long-running jobs using the Continuous Background Task ( `BGContinuedProcessingTask`), which enables your app’s critical work that can take minutes or more, to complete in the background if a person backgrounds the app before the job completes.

Unlike other `BGTask` subclasses, `BGContinuedProcessingTask` starts in the foreground. In addition, your app needs to run the task only in response to someone’s action, such as tapping a button. If a person backgrounds the app before the task completes, a continuous background task can still perform operations, for example, Core ML processing or sensor data analysis, that leverage the GPU (on supported devices). In the background, continuous background tasks can also use the network and perform intenstive CPU-based operations, for example, image processing with Core Image, Vision, and Accelerate. Example tasks include:

- Exporting video in a film-editing app, or audio in a digital audio workstation (DAW)

- Creating thumbnails for a new batch of photo uploads

- Applying visual filters (HDR, etc) or compressing images for social media posts

For added flexibility, you can set the system to fail any task if, under resource constraints, the system can’t begin processing the task immediately. Otherwise, the system queues the task to begin as soon as possible.

When the system runs a continuous background task and a person backgrounds the app, the system keeps them informed of the task’s progress through a system interface. For power and performance considerations, people can cancel a continuous background task if they desire, through the interface. Your app regularly reports progress of the task, which enables the system to make informed suggestions through the interface about possibly stuck tasks that a person can cancel.

If a person cancels a task through the interface, the framework invokes the task’s expiration handler and the app handles the failure. Otherwise, the framework returns control to the app’s completion handler with a success status.

## Create a Continuous Background Task request

To begin a job that you want to complete even if a person backgrounds the app, start by creating a task request ( `BGContinuedProcessingTaskRequest`). Choose a name the system can use to identify the specific job in the `taskIdentifier` parameter of the initializer and prefix it with your app’s bundle ID:

// Create the task request.
let request = BGContinuedProcessingTaskRequest(
identifier: taskIdentifier,
title: "A video export",
subtitle: "About to start...",
)

Make the `task-name` portion of the task identifier unique for this specific job. The system displays the `title` and `subtitle` arguments you choose in a Live Activity, where a person can monitor the job’s progress and cancel it, if they choose.

## Enable background GPU use

If your job includes API that can utilize the GPU, enable background GPU use for your task by setting `requiredResources` to `gpu`. First, check whether the device supports background GPU use by seeing if `supportedResources` contains `.gpu`:

if BGTaskScheduler.supportedResources.contains(.gpu) {
request.requiredResources = .gpu
}

The system requires your app to have the `Background GPU Access` entitlement with a value of `true` to use the GPU in the background. To do that, enable the Background GPU Access capability on your app’s target. For more information about capabilities in Xcode, see Adding capabilities to your app.

## Choose a processing strategy

When the system is busy or resource constrained, it might queue your task request for later execution. The default submission strategy, `BGContinuedProcessingTaskRequest.SubmissionStrategy.queue`, instructs the system to add your task request to a queue if there’s no immediately available room to run it.

If instead you want the task submission to fail if the system is unable to run the task immediately, set `strategy` to `BGContinuedProcessingTaskRequest.SubmissionStrategy.fail` .

request.strategy = .fail

The system cancels a `fail` task right away if it can’t begin processing the task immediately, for example, when the system reaches a maximum number of concurrent tasks.

## Run the continuous background task

To run the job, register the task request with the shared `BGTaskScheduler` using the unique `taskIdentifier`:

BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { task in
guard let task = task as? BGContinuedProcessingTask else { return }
...

The `register(forTaskWithIdentifier:using:launchHandler:)` launch handler provides the `BGContinuedProcessingTask` reference for you to control execution.

Inside the launch handler, define your task’s long-running code:

// App-defined function that registers a continuous background task and defines its long-running work.
private func register() {
// Submission bookkeeping.
if submitted {
return
}
submitted = true

// Register the continuous background task.
scheduler.register(forTaskWithIdentifier: taskIdentifier, using: nil) { task in
guard let task = task as? BGContinuedProcessingTask else {
return
}
/* Do long-running work here. */
}
}

Next, submit the request by passing it to the shared scheduler’s `submit(_:)` method:

// App-defined function that submits a video export job through a continuous background task.
private func submit() {
// Create the task request.
let request = BGContinuedProcessingTaskRequest(identifier: taskIdentifier, title: "A video export", subtitle: "About to start...")

// Submit the task request.
do {
try scheduler.submit(request)
} catch {
print("Failed to submit request: \(error)")
}
}

## Report progress

The system displays the job and other continuous background tasks in a Live Activity to inform people of background task progress. It’s important to display accurate progress, as a person can cancel a task through the Live Activity widget if the task appears to be stuck.

To set progress, use the `ProgressReporting` protocol that `BGContinuedProcessingTask` conforms to:

// Create a progress instance.
let stepCount: Int64 = 100 // For example, percentage of completion.
let progress = Progress(totalUnitCount: stepCount)

for i in 1...stepCount {
// Update progress.
task.progress.completedUnitCount = Int64(i)
}

The system also prioritizes the termination of tasks that reflect minimal progress, if resource constraints occur at run time.

## Respond to task completion

Prepare to handle task failure or success by checking the tasks `expirationHandler`:

/// App-defined function that exports a video through a continuous background task.

var wasExpired = false

// Check the expiration handler to confirm job completion.
task.expirationHandler = {
wasExpired = true
}

// Update progress.
let progress = task.progress
progress.totalUnitCount = 100
while !progress.isFinished && !wasExpired {
progress.completedUnitCount += 1
let formattedProgress = String(format: "%.2f", progress.fractionCompleted * 100)

// Update task for displayed progress.
task.updateTitle(task.title, subtitle: "Completed \(formattedProgress)%")
sleep(1)
}

// Check progress to confirm job completion.
if progress.isFinished {
return .success(())
} else {
return .failure(.expired)
}
}

A task can fail if your code encounters an error or the system expires your task, as occurs when a person cancels the task in the system UI.

## See Also

### Foreground tasks with background support

`class BGContinuedProcessingTask`

A task that starts in the foreground and can continue running in the background as needed.

`Background GPU Access`

The entitlement the system requires for a continuous background task to use the GPU.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtask

- Background Tasks
- BGContinuedProcessingTask

Class

# BGContinuedProcessingTask

A task that starts in the foreground and can continue running in the background as needed.

class BGContinuedProcessingTask

## Mentioned in

Performing long-running tasks on iOS and iPadOS

## Overview

This task works with `BGContinuedProcessingTaskRequest`.

The system displays the progress of this task in a Live Activity and a person can cancel it through the interface if they wish.

The system can terminate a continuous background task abruptly depending on run-time conditions, for example, under resource constraints. Your implementation needs to report progress using the `ProgressReporting` protocol that this task conforms to. The system prioritizes the termination of tasks that reflect minimal or no progress, when resources become constrained.

For more information on Continuous Background Task requests, see Performing long-running tasks on iOS and iPadOS.

## Topics

### Titling the task

`var title: String`

The localized title displayed to a person.

`var subtitle: String`

The localized subtitle displayed to a person.

`func updateTitle(String, subtitle: String)`

Update the task title and subtitle that the system displays to a person.

## Relationships

### Inherits From

- `BGTask`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`
- `ProgressReporting`

## See Also

### Foreground tasks with background support

Use a continuous background task to do work that can complete as needed.

`Background GPU Access`

The entitlement the system requires for a continuous background task to use the GPU.

---

# https://developer.apple.com/documentation/backgroundtasks/bgprocessingtaskrequest

- Background Tasks
- BGProcessingTaskRequest

Class

# BGProcessingTaskRequest

A request to launch your app in the background to execute a processing task that can take minutes to complete.

class BGProcessingTaskRequest

## Topics

### Initializing a Processing Task Request

`init(identifier: String)`

Return a new processing task request for the specified identifier.

### Setting Task Request Options

`var requiresExternalPower: Bool`

A Boolean specifying if the processing task requires a device connected to power.

`var requiresNetworkConnectivity: Bool`

A Boolean specifying if the processing task requires network connectivity.

## Relationships

### Inherits From

- `BGTaskRequest`

### Inherited By

- `BGHealthResearchTaskRequest`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCopying`
- `NSObjectProtocol`

## See Also

### Task requests

`class BGAppRefreshTaskRequest`

A request to launch your app in the background to execute a short refresh task.

`class BGTaskRequest`

An abstract class for representing task requests.

`class BGHealthResearchTaskRequest`

A request to launch your app in the background to execute processing for a health research study in which a user participates.

`class BGContinuedProcessingTaskRequest`

A request for a workload that the system continues processing even if a person backgrounds the app.

---

# https://developer.apple.com/documentation/backgroundtasks/bgapprefreshtaskrequest

- Background Tasks
- BGAppRefreshTaskRequest

Class

# BGAppRefreshTaskRequest

A request to launch your app in the background to execute a short refresh task.

class BGAppRefreshTaskRequest

## Mentioned in

Choosing Background Strategies for Your App

## Topics

### Initializing a refresh task request

`init(identifier: String)`

Return a new refresh task request for the specified identifier.

## Relationships

### Inherits From

- `BGTaskRequest`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCopying`
- `NSObjectProtocol`

## See Also

### Task requests

`class BGProcessingTaskRequest`

A request to launch your app in the background to execute a processing task that can take minutes to complete.

`class BGTaskRequest`

An abstract class for representing task requests.

`class BGHealthResearchTaskRequest`

A request to launch your app in the background to execute processing for a health research study in which a user participates.

`class BGContinuedProcessingTaskRequest`

A request for a workload that the system continues processing even if a person backgrounds the app.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskrequest

- Background Tasks
- BGTaskRequest

Class

# BGTaskRequest

An abstract class for representing task requests.

class BGTaskRequest

## Topics

### Configuring a Task Request

`var earliestBeginDate: Date?`

The earliest date and time at which to run the task.

`var identifier: String`

The identifier of the task associated with the request.

## Relationships

### Inherits From

- `NSObject`

### Inherited By

- `BGAppRefreshTaskRequest`
- `BGContinuedProcessingTaskRequest`
- `BGProcessingTaskRequest`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCopying`
- `NSObjectProtocol`

## See Also

### Task requests

`class BGProcessingTaskRequest`

A request to launch your app in the background to execute a processing task that can take minutes to complete.

`class BGAppRefreshTaskRequest`

A request to launch your app in the background to execute a short refresh task.

`class BGHealthResearchTaskRequest`

A request to launch your app in the background to execute processing for a health research study in which a user participates.

`class BGContinuedProcessingTaskRequest`

A request for a workload that the system continues processing even if a person backgrounds the app.

---

# https://developer.apple.com/documentation/backgroundtasks/bghealthresearchtaskrequest

- Background Tasks
- BGHealthResearchTaskRequest

Class

# BGHealthResearchTaskRequest

A request to launch your app in the background to execute processing for a health research study in which a user participates.

class BGHealthResearchTaskRequest

## Mentioned in

Choosing Background Strategies for Your App

## Topics

### Setting file permissions

`var protectionTypeOfRequiredData: NSString`

The file protection required to access health research data relevant to complete the task.

## Relationships

### Inherits From

- `BGProcessingTaskRequest`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCopying`
- `NSObjectProtocol`

## See Also

### Task requests

`class BGProcessingTaskRequest`

A request to launch your app in the background to execute a processing task that can take minutes to complete.

`class BGAppRefreshTaskRequest`

A request to launch your app in the background to execute a short refresh task.

`class BGTaskRequest`

An abstract class for representing task requests.

`class BGContinuedProcessingTaskRequest`

A request for a workload that the system continues processing even if a person backgrounds the app.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest

- Background Tasks
- BGContinuedProcessingTaskRequest

Class

# BGContinuedProcessingTaskRequest

A request for a workload that the system continues processing even if a person backgrounds the app.

class BGContinuedProcessingTaskRequest

## Mentioned in

Performing long-running tasks on iOS and iPadOS

## Overview

The app submits this request from the foreground. Submission needs to occur as a result of a person’s action, such as tapping a button. The framework begins processing the task immediately, if possible, and the system allows it to continue running even if the app moves to the background.

For more information on Continuous Background Task requests, see Performing long-running tasks on iOS and iPadOS.

## Topics

### Creating a task request

`init(identifier: String, title: String, subtitle: String)`

Creates an instance on behalf of the currently foregrounded app.

### Identifying resource dependencies

`var requiredResources: BGContinuedProcessingTaskRequest.Resources`

An option that indicates any special system resources that the task requires.

`struct Resources`

Options that specify additional system resources a background task needs.

### Choosing a processing strategy

`var strategy: BGContinuedProcessingTaskRequest.SubmissionStrategy`

The submission strategy for the scheduler to abide by.

`enum SubmissionStrategy`

The ways your app suggests the system handle your task’s submission under varying conditions.

### Titling the task

`var subtitle: String`

The localized subtitle displayed to a person.

`var title: String`

The localized task title displayed to a person.

## Relationships

### Inherits From

- `BGTaskRequest`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCopying`
- `NSObjectProtocol`

## See Also

### Task requests

`class BGProcessingTaskRequest`

A request to launch your app in the background to execute a processing task that can take minutes to complete.

`class BGAppRefreshTaskRequest`

A request to launch your app in the background to execute a short refresh task.

`class BGTaskRequest`

An abstract class for representing task requests.

`class BGHealthResearchTaskRequest`

A request to launch your app in the background to execute processing for a health research study in which a user participates.

---

# https://developer.apple.com/documentation/backgroundtasks/starting-and-terminating-tasks-during-development

- Background Tasks
- Starting and Terminating Tasks During Development

Article

# Starting and Terminating Tasks During Development

Use the debugger during development to start tasks and to terminate them before completion.

## Overview

The delay between the time you schedule a background task and when the system launches your app to run the task can be many hours. While developing your app, you can use two private functions to start a task and to force early termination of the task according to your selected timeline. The debug functions work only on devices.

### Launch a Task

To launch a task:

1. Set a breakpoint in the code that executes after a successful call to `submit(_:)`.

2. Run your app on a device until the breakpoint pauses your app.

3. In the debugger, execute the line shown below, substituting the identifier of the desired task for `TASK_IDENTIFIER`.

4. Resume your app. The system calls the launch handler for the desired task.

e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"TASK_IDENTIFIER"]

### Force Early Termination of a Task

To force termination of a task:

1. Set a breakpoint in the desired task.

2. Launch the task using the debugger as described in the previous section.

3. Wait for your app to pause at the breakpoint.

4. In the debugger, execute the line shown below, substituting the identifier of the desired task for `TASK_IDENTIFIER`.

5. Resume your app. The system calls the expiration handler for the desired task.

e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"TASK_IDENTIFIER"]

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler)



---

# https://developer.apple.com/documentation/backgroundtasks/bgtask)



---

# https://developer.apple.com/documentation/backgroundtasks/refreshing-and-maintaining-your-app-using-background-tasks)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/choosing-background-strategies-for-your-app)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgprocessingtask)



---

# https://developer.apple.com/documentation/backgroundtasks/bgapprefreshtask)



---

# https://developer.apple.com/documentation/backgroundtasks/bghealthresearchtask)



---

# https://developer.apple.com/documentation/backgroundtasks/performing-long-running-tasks-on-ios-and-ipados)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtask)



---

# https://developer.apple.com/documentation/backgroundtasks/bgprocessingtaskrequest)



---

# https://developer.apple.com/documentation/backgroundtasks/bgapprefreshtaskrequest)



---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskrequest)



---

# https://developer.apple.com/documentation/backgroundtasks/bghealthresearchtaskrequest)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/starting-and-terminating-tasks-during-development)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtask/identifier

- Background Tasks
- BGTask
- identifier

Instance Property

# identifier

The string identifier of the task.

var identifier: String { get }

## Discussion

The identifier is the same as the one used to register the launch handler in `register(forTaskWithIdentifier:using:launchHandler:)`.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtask/expirationhandler

- Background Tasks
- BGTask
- expirationHandler

Instance Property

# expirationHandler

A handler called shortly before the task’s background time expires.

## Parameters

`expirationHandler`

The expiration handler takes no arguments and has no return value. Use the handler to cancel any ongoing work and to do any required cleanup in as short a time as possible.

The handler may be called before the background process uses the full amount of its allocated time.

## Mentioned in

Performing long-running tasks on iOS and iPadOS

## Discussion

The time allocated by the system for expiration handlers doesn’t vary with the number of background tasks. All expiration handlers must complete before the allocated time.

Not setting an expiration handler results in the system marking your task as complete and unsuccessful instead of sending a warning.

The manager sets the value `expirationHandler` to `nil` after the handler completes.

## See Also

### Configuring a Task

`func setTaskCompleted(success: Bool)`

Informs the background task scheduler that the task is complete.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtask/settaskcompleted(success:)

#app-main)

- Background Tasks
- BGTask
- setTaskCompleted(success:)

Instance Method

# setTaskCompleted(success:)

Informs the background task scheduler that the task is complete.

func setTaskCompleted(success: Bool)

## Parameters

`success`

A `Boolean` indicating if the task completed successfully or not.

## Mentioned in

Choosing Background Strategies for Your App

## Discussion

Not calling `setTaskCompleted(success:)` before the time for the task expires may result in the system killing your app.

You can reschedule an unsuccessful required task.

## See Also

### Configuring a Task

A handler called shortly before the task’s background time expires.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtask),



---

# https://developer.apple.com/documentation/backgroundtasks/bgtask/identifier)



---

# https://developer.apple.com/documentation/backgroundtasks/bgtask/expirationhandler)



---

# https://developer.apple.com/documentation/backgroundtasks/bgtask/settaskcompleted(success:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgprocessingtaskrequest/init(identifier:)

#app-main)

- Background Tasks
- BGProcessingTaskRequest
- init(identifier:)

Initializer

# init(identifier:)

Return a new processing task request for the specified identifier.

init(identifier: String)

## Parameters

`identifier`

The string identifier of the processing task associated with the request.

---

# https://developer.apple.com/documentation/backgroundtasks/bgprocessingtaskrequest/requiresexternalpower

- Background Tasks
- BGProcessingTaskRequest
- requiresExternalPower

Instance Property

# requiresExternalPower

A Boolean specifying if the processing task requires a device connected to power.

var requiresExternalPower: Bool { get set }

## See Also

### Setting Task Request Options

`var requiresNetworkConnectivity: Bool`

A Boolean specifying if the processing task requires network connectivity.

---

# https://developer.apple.com/documentation/backgroundtasks/bgprocessingtaskrequest/requiresnetworkconnectivity

- Background Tasks
- BGProcessingTaskRequest
- requiresNetworkConnectivity

Instance Property

# requiresNetworkConnectivity

A Boolean specifying if the processing task requires network connectivity.

var requiresNetworkConnectivity: Bool { get set }

## See Also

### Setting Task Request Options

`var requiresExternalPower: Bool`

A Boolean specifying if the processing task requires a device connected to power.

---

# https://developer.apple.com/documentation/backgroundtasks/bgprocessingtaskrequest/init(identifier:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgprocessingtaskrequest/requiresexternalpower)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgprocessingtaskrequest/requiresnetworkconnectivity)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/shared

- Background Tasks
- BGTaskScheduler
- shared

Type Property

# shared

The shared background task scheduler instance.

class var shared: BGTaskScheduler { get }

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/supportedresources

- Background Tasks
- BGTaskScheduler
- supportedResources

Type Property

# supportedResources

Additional system resources that a continuous background task can request.

class var supportedResources: BGContinuedProcessingTaskRequest.Resources { get }

## Mentioned in

Performing long-running tasks on iOS and iPadOS

## Discussion

The `BGContinuedProcessingTaskRequest.Resources` enumeration indicates optional system resources that a specific `BGContinuedProcessingTaskRequest` instance can request through its `requiredResources` property.

Before requesting a resource, check this property to ensure that the device supports it.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/register(fortaskwithidentifier:using:launchhandler:)

#app-main)

- Background Tasks
- BGTaskScheduler
- register(forTaskWithIdentifier:using:launchHandler:)

Instance Method

# register(forTaskWithIdentifier:using:launchHandler:)

Register a launch handler for the task with the associated identifier that’s executed on the specified queue.

func register(
forTaskWithIdentifier identifier: String,
using queue: dispatch_queue_t?,

## Parameters

`identifier`

A string containing the identifier of the task.

`queue`

A queue for executing the task. Pass `nil` to use a default background queue.

`launchHandler`

The system runs the block of code for the launch handler when it launches the app in the background. The block takes a single parameter, a `BGTask` object used for assigning an expiration handler and for setting a completion status. The block has no return value.

## Mentioned in

Performing long-running tasks on iOS and iPadOS

## Return value

Returns `true` if the launch handler was registered. Returns `false` if the identifier isn’t included in the `BGTaskSchedulerPermittedIdentifiers``Info.plist`.

## Discussion

Every identifier in the `BGTaskSchedulerPermittedIdentifiers` requires a handler. Registration of all launch handlers must be complete before the end of `applicationDidFinishLaunching(_:)`.

## See Also

### Scheduling a task

`func submit(BGTaskRequest) throws`

Submit a previously registered background task for execution.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/submit(_:)

#app-main)

- Background Tasks
- BGTaskScheduler
- submit(\_:)

Instance Method

# submit(\_:)

Submit a previously registered background task for execution.

func submit(_ taskRequest: BGTaskRequest) throws

## Parameters

`taskRequest`

A background task request object specifying the task identifier and optional configuration information.

## Mentioned in

Performing long-running tasks on iOS and iPadOS

Starting and Terminating Tasks During Development

## Discussion

Submitting a task request for an unexecuted task that’s already in the queue replaces the previous task request.

There can be a total of 1 refresh task and 10 processing tasks scheduled at any time. Trying to schedule more tasks returns `BGTaskScheduler.Error.Code.tooManyPendingTaskRequests`.

## See Also

### Scheduling a task

Register a launch handler for the task with the associated identifier that’s executed on the specified queue.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/cancel(taskrequestwithidentifier:)

#app-main)

- Background Tasks
- BGTaskScheduler
- cancel(taskRequestWithIdentifier:)

Instance Method

# cancel(taskRequestWithIdentifier:)

Cancel a previously scheduled task request.

func cancel(taskRequestWithIdentifier identifier: String)

## Parameters

`identifier`

The string identifier of the task request to cancel.

## See Also

### Canceling a task

`func cancelAllTaskRequests()`

Cancel all scheduled task requests.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/cancelalltaskrequests()

#app-main)

- Background Tasks
- BGTaskScheduler
- cancelAllTaskRequests()

Instance Method

# cancelAllTaskRequests()

Cancel all scheduled task requests.

func cancelAllTaskRequests()

## See Also

### Canceling a task

`func cancel(taskRequestWithIdentifier: String)`

Cancel a previously scheduled task request.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error

- Background Tasks
- BGTaskScheduler
- BGTaskScheduler.Error

Structure

# BGTaskScheduler.Error

The Errors for the `BGTaskSchedulerError` domain.

struct Error

## Topics

### Getting the error codes

`enum Code`

An enumeration of the task scheduling errors.

`static var notPermitted: BGTaskScheduler.Error.Code`

A task scheduling error that indicates the app isn’t permitted to launch the task.

`static var tooManyPendingTaskRequests: BGTaskScheduler.Error.Code`

A task scheduling error that indicates there are too many pending tasks of the type requested.

`static var unavailable: BGTaskScheduler.Error.Code`

A task scheduling error that indicates the app or extension can’t schedule background work.

### Getting the error domain

`static var errorDomain: String`

The background tasks error domain as a string.

### Type Properties

`static var immediateRunIneligible: BGTaskScheduler.Error.Code`

## Relationships

### Conforms To

- `CustomNSError`
- `Equatable`
- `Error`
- `Hashable`
- `Sendable`
- `SendableMetatype`

## See Also

### Handling errors

`class let errorDomain: String`

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code

- Background Tasks
- BGTaskScheduler
- BGTaskScheduler.Error
- BGTaskScheduler.Error.Code

Enumeration

# BGTaskScheduler.Error.Code

An enumeration of the task scheduling errors.

enum Code

## Topics

### Identifying an error

`case notPermitted`

A task scheduling error that indicates the app isn’t permitted to launch the task.

`case tooManyPendingTaskRequests`

A task scheduling error that indicates there are too many pending tasks of the type requested.

`case unavailable`

A task scheduling error that indicates the app or extension can’t schedule background work.

`case immediateRunIneligible`

A task scheduling error that indicates a task request didn’t run immediately due to system conditions.

### Initializers

`init?(rawValue: Int)`

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `Hashable`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`

## See Also

### Handling errors

`struct Error`

The Errors for the `BGTaskSchedulerError` domain.

`class let errorDomain: String`

The background tasks error domain as a string.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/errordomain

- Background Tasks
- BGTaskScheduler
- errorDomain

Type Property

# errorDomain

The background tasks error domain as a string.

class let errorDomain: String

## See Also

### Handling errors

`struct Error`

The Errors for the `BGTaskSchedulerError` domain.

`enum Code`

An enumeration of the task scheduling errors.

---

# https://developer.apple.com/documentation/backgroundtasks/performing-long-running-tasks-on-ios-and-ipados).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/shared)



---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/supportedresources)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/register(fortaskwithidentifier:using:launchhandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/submit(_:))



---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/cancel(taskrequestwithidentifier:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/cancelalltaskrequests())

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/getpendingtaskrequests(completionhandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error)



---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code)



---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/errordomain)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/BackgroundTasks

Framework

# Background Tasks

Support background processing in your app by wrapping your app’s most critical work in framework-provided tasks.

## Overview

Use this framework to keep your app content up to date and run tasks requiring minutes to complete even if your app is in the background. Longer tasks can leverage external power, network connectivity, and the GPU on supported devices.

To launch your app in the background and perform necessary work, register launch handlers for framework-provided tasks and schedule the tasks as needed.

Your app can also use a framework-provided task to execute critical jobs in the foreground and complete them in the background if a person backgrounds your app before the job completes.

## Topics

### Essentials

Background Tasks updates

Learn about important changes in Background Tasks.

`class BGTaskScheduler`

A class for scheduling tasks that add background support to your app’s most critical work.

`class BGTask`

An abstract class for the framework’s tasks.

### Background tasks

Using background tasks to update your app

Configure your app to perform tasks in the background to make efficient use of processing time and power.

Refreshing and Maintaining Your App Using Background Tasks

Use scheduled background tasks for refreshing your app content and for performing maintenance.

Choosing Background Strategies for Your App

Select the best method of scheduling background runtime for your app.

`class BGProcessingTask`

A time-consuming processing task that runs while the app is in the background.

`class BGAppRefreshTask`

An object representing a short task typically used to refresh content that’s run while the app is in the background.

`class BGHealthResearchTask`

A time-consuming, necessary processing task that runs while the app is in the background to prepare data essential to a health research study.

### Foreground tasks with background support

Performing long-running tasks on iOS and iPadOS

Use a continuous background task to do work that can complete as needed.

`class BGContinuedProcessingTask`

A task that starts in the foreground and can continue running in the background as needed.

`Background GPU Access`

The entitlement the system requires for a continuous background task to use the GPU.

### Task requests

`class BGProcessingTaskRequest`

A request to launch your app in the background to execute a processing task that can take minutes to complete.

`class BGAppRefreshTaskRequest`

A request to launch your app in the background to execute a short refresh task.

`class BGTaskRequest`

An abstract class for representing task requests.

`class BGHealthResearchTaskRequest`

A request to launch your app in the background to execute processing for a health research study in which a user participates.

`class BGContinuedProcessingTaskRequest`

A request for a workload that the system continues processing even if a person backgrounds the app.

### Development and testing

Starting and Terminating Tasks During Development

Use the debugger during development to start tasks and to terminate them before completion.

---

# https://developer.apple.com/documentation/backgroundtasks/bgprocessingtask),



---

# https://developer.apple.com/documentation/backgroundtasks/bghealthresearchtask).



---

# https://developer.apple.com/documentation/backgroundtasks/bgapprefreshtaskrequest).



---

# https://developer.apple.com/documentation/backgroundtasks/bgtask/settaskcompleted(success:)),

),#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtask/title

- Background Tasks
- BGContinuedProcessingTask
- title

Instance Property

# title

The localized title displayed to a person.

var title: String { get }

## Discussion

Define the value of this property as a parameter to the request initializer: `init(identifier:title:subtitle:)`. After that, this property is read only, however you can update the title by calling `updateTitle(_:subtitle:)`.

## See Also

### Titling the task

`var subtitle: String`

The localized subtitle displayed to a person.

`func updateTitle(String, subtitle: String)`

Update the task title and subtitle that the system displays to a person.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtask/subtitle

- Background Tasks
- BGContinuedProcessingTask
- subtitle

Instance Property

# subtitle

The localized subtitle displayed to a person.

var subtitle: String { get }

## Discussion

Define the value of this property as a parameter to the request initializer: `init(identifier:title:subtitle:)`. After that, this property is read only, however you can update the subtitle by calling `updateTitle(_:subtitle:)`.

## See Also

### Titling the task

`var title: String`

The localized title displayed to a person.

`func updateTitle(String, subtitle: String)`

Update the task title and subtitle that the system displays to a person.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtask/updatetitle(_:subtitle:)

#app-main)

- Background Tasks
- BGContinuedProcessingTask
- updateTitle(\_:subtitle:)

Instance Method

# updateTitle(\_:subtitle:)

Update the task title and subtitle that the system displays to a person.

func updateTitle(
_ title: String,
subtitle: String
)

## Parameters

`title`

The localized title displayed to a person.

`subtitle`

The localized subtitle displayed to a person.

## Discussion

The system displays Continuous Background Task requests in a Live Activity for a person to monitor progress and cancel a task, if they wish.

## See Also

### Titling the task

`var title: String`

`var subtitle: String`

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtask/title)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtask/subtitle)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtask/updatetitle(_:subtitle:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler).



---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/requiredresources

- Background Tasks
- BGContinuedProcessingTaskRequest
- requiredResources

Instance Property

# requiredResources

An option that indicates any special system resources that the task requires.

var requiredResources: BGContinuedProcessingTaskRequest.Resources { get set }

## Mentioned in

Performing long-running tasks on iOS and iPadOS

## Discussion

To request background GPU support for the task, set this property to `gpu`. First, check whether the device supports background GPU use; see `supportedResources`.

The default value is `BGContinuedProcessingTaskRequestResourcesDefault`.

## See Also

### Identifying resource dependencies

`struct Resources`

Options that specify additional system resources a background task needs.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/resources/gpu

- Background Tasks
- BGContinuedProcessingTaskRequest
- BGContinuedProcessingTaskRequest.Resources
- gpu

Type Property

# gpu

An option that indicates a long-running task requires the GPU.

static var gpu: BGContinuedProcessingTaskRequest.Resources { get }

## Mentioned in

Performing long-running tasks on iOS and iPadOS

## Discussion

The system requires your app to have the `Background GPU Access` entitlement with a value of `true` to use the GPU in the background. To do that, enable the Background GPU Access capability on your app’s target. For more information about capabilities in Xcode, see Adding capabilities to your app.

Not all devices support background GPU use. For more information, see Performing long-running tasks on iOS and iPadOS.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/submissionstrategy/queue

- Background Tasks
- BGContinuedProcessingTaskRequest
- BGContinuedProcessingTaskRequest.SubmissionStrategy
- BGContinuedProcessingTaskRequest.SubmissionStrategy.queue

Case

# BGContinuedProcessingTaskRequest.SubmissionStrategy.queue

An option that queues a continuous background task to begin as soon as possible.

case queue

## Mentioned in

Performing long-running tasks on iOS and iPadOS

## Discussion

This option adds the task request to the back of a queue. The system runs the task as soon as possible. The system might be unable to run a submitted task immediately if the system is currently at the maximum level of concurrent tasks.

## See Also

### Choosing a strategy

`case fail`

An option that fails the submission of a continuous background task if the system can’t run it immediately.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/strategy

- Background Tasks
- BGContinuedProcessingTaskRequest
- strategy

Instance Property

# strategy

The submission strategy for the scheduler to abide by.

var strategy: BGContinuedProcessingTaskRequest.SubmissionStrategy { get set }

## Mentioned in

Performing long-running tasks on iOS and iPadOS

## Discussion

The default value is `BGContinuedProcessingTaskRequest.SubmissionStrategy.queue`.

## See Also

### Choosing a processing strategy

`enum SubmissionStrategy`

The ways your app suggests the system handle your task’s submission under varying conditions.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/submissionstrategy/fail

- Background Tasks
- BGContinuedProcessingTaskRequest
- BGContinuedProcessingTaskRequest.SubmissionStrategy
- BGContinuedProcessingTaskRequest.SubmissionStrategy.fail

Case

# BGContinuedProcessingTaskRequest.SubmissionStrategy.fail

An option that fails the submission of a continuous background task if the system can’t run it immediately.

case fail

## Mentioned in

Performing long-running tasks on iOS and iPadOS

## Discussion

Task processing might not start right away if the system is currently resource constrainted.

## See Also

### Choosing a strategy

`case queue`

An option that queues a continuous background task to begin as soon as possible.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtask)),

),#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest)).

).#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/requiredresources)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/resources/gpu).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/submissionstrategy/queue),

,#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/strategy)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/submissionstrategy/fail)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtask/expirationhandler):



---

# https://developer.apple.com/documentation/backgroundtasks/bghealthresearchtaskrequest/protectiontypeofrequireddata

- Background Tasks
- BGHealthResearchTaskRequest
- protectionTypeOfRequiredData

Instance Property

# protectionTypeOfRequiredData

The file protection required to access health research data relevant to complete the task.

unowned(unsafe) var protectionTypeOfRequiredData: NSString { get set }

---

# https://developer.apple.com/documentation/backgroundtasks/bghealthresearchtaskrequest/protectiontypeofrequireddata)



---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/init(identifier:title:subtitle:)

#app-main)

- Background Tasks
- BGContinuedProcessingTaskRequest
- init(identifier:title:subtitle:)

Initializer

# init(identifier:title:subtitle:)

Creates an instance on behalf of the currently foregrounded app.

init(
identifier: String,
title: String,
subtitle: String
)

## Parameters

`identifier`

The task identifier.

`title`

The localized title displayed to a person before the task begins running.

`subtitle`

The localized subtitle displayed to a person before the task begins running.

## Discussion

Apps and their extensions need to use this method to initialize any tasks due to the underlying association to the currently foregrounded app. Note that `earliestBeginDate` is ignored by the scheduler in favor of `NSDate.now`.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/resources

- Background Tasks
- BGContinuedProcessingTaskRequest
- BGContinuedProcessingTaskRequest.Resources

Structure

# BGContinuedProcessingTaskRequest.Resources

Options that specify additional system resources a background task needs.

struct Resources

## Overview

The following properties are of this type:

- Continuous Background Task request ( `BGContinuedProcessingTaskRequest`) property `requiredResources`.

- `BGTaskScheduler` property `supportedResources`.

## Topics

### Identiying a resource

`static var gpu: BGContinuedProcessingTaskRequest.Resources`

An option that indicates a long-running task requires the GPU.

### Creating a resource

`init(rawValue: Int)`

Initializes a required resource for a Continuous Background Task by raw value.

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `ExpressibleByArrayLiteral`
- `OptionSet`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`
- `SetAlgebra`

## See Also

### Identifying resource dependencies

`var requiredResources: BGContinuedProcessingTaskRequest.Resources`

An option that indicates any special system resources that the task requires.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/submissionstrategy

- Background Tasks
- BGContinuedProcessingTaskRequest
- BGContinuedProcessingTaskRequest.SubmissionStrategy

Enumeration

# BGContinuedProcessingTaskRequest.SubmissionStrategy

The ways your app suggests the system handle your task’s submission under varying conditions.

enum SubmissionStrategy

## Overview

The Continuous Background Task request ( `BGContinuedProcessingTaskRequest`) property `strategy` is of this type.

For more information on submission strategies, see Performing long-running tasks on iOS and iPadOS.

## Topics

### Choosing a strategy

`case fail`

An option that fails the submission of a continuous background task if the system can’t run it immediately.

`case queue`

An option that queues a continuous background task to begin as soon as possible.

### Creating a strategy

`init?(rawValue: Int)`

Creates a submission strategy.

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `Hashable`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`

## See Also

### Choosing a processing strategy

`var strategy: BGContinuedProcessingTaskRequest.SubmissionStrategy`

The submission strategy for the scheduler to abide by.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/subtitle

- Background Tasks
- BGContinuedProcessingTaskRequest
- subtitle

Instance Property

# subtitle

The localized subtitle displayed to a person.

var subtitle: String { get set }

## Discussion

Define the value of this property as a parameter to the request initializer: `init(identifier:title:subtitle:)`.

## See Also

### Titling the task

`var title: String`

The localized task title displayed to a person.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/title

- Background Tasks
- BGContinuedProcessingTaskRequest
- title

Instance Property

# title

The localized task title displayed to a person.

var title: String { get set }

## Discussion

Define the value of this property as a parameter to the request initializer: `init(identifier:title:subtitle:)`.

## See Also

### Titling the task

`var subtitle: String`

The localized subtitle displayed to a person.

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/init(identifier:title:subtitle:))



---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/resources)



---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/submissionstrategy)



---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/subtitle)



---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/title)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskrequest/earliestbegindate

- Background Tasks
- BGTaskRequest
- earliestBeginDate

Instance Property

# earliestBeginDate

The earliest date and time at which to run the task.

var earliestBeginDate: Date? { get set }

## Discussion

Specify `nil` for no start delay.

Setting the property indicates that the background task shouldn’t start any earlier than this date. However, the system doesn’t guarantee launching the task at the specified date, but only that it won’t begin sooner.

## See Also

### Configuring a Task Request

`var identifier: String`

The identifier of the task associated with the request.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskrequest/identifier

- Background Tasks
- BGTaskRequest
- identifier

Instance Property

# identifier

The identifier of the task associated with the request.

var identifier: String { get }

## See Also

### Configuring a Task Request

`var earliestBeginDate: Date?`

The earliest date and time at which to run the task.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskrequest/earliestbegindate)



---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskrequest/identifier)



---

# https://developer.apple.com/documentation/backgroundtasks/bgapprefreshtaskrequest/init(identifier:)

#app-main)

- Background Tasks
- BGAppRefreshTaskRequest
- init(identifier:)

Initializer

# init(identifier:)

Return a new refresh task request for the specified identifier.

init(identifier: String)

## Parameters

`identifier`

The string identifier of the refresh task associated with the request.

---

# https://developer.apple.com/documentation/backgroundtasks/bgapprefreshtaskrequest/init(identifier:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/submit(_:)).

).#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/register(fortaskwithidentifier:using:launchhandler:)).

).#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code/toomanypendingtaskrequests

- Background Tasks
- BGTaskScheduler
- BGTaskScheduler.Error
- BGTaskScheduler.Error.Code
- BGTaskScheduler.Error.Code.tooManyPendingTaskRequests

Case

# BGTaskScheduler.Error.Code.tooManyPendingTaskRequests

A task scheduling error that indicates there are too many pending tasks of the type requested.

case tooManyPendingTaskRequests

## Discussion

Try canceling some existing task requests and then resubmit the request that failed.

## See Also

### Identifying an error

`case notPermitted`

A task scheduling error that indicates the app isn’t permitted to launch the task.

`case unavailable`

A task scheduling error that indicates the app or extension can’t schedule background work.

`case immediateRunIneligible`

A task scheduling error that indicates a task request didn’t run immediately due to system conditions.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code/toomanypendingtaskrequests).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/notpermitted

- Background Tasks
- BGTaskScheduler
- BGTaskScheduler.Error
- notPermitted

Type Property

# notPermitted

A task scheduling error that indicates the app isn’t permitted to launch the task.

static var notPermitted: BGTaskScheduler.Error.Code { get }

## Discussion

There are two causes for this error:

- The app didn’t set the appropriate mode in the `UIBackgroundModes` array.

- The task identifier of the submitted task wasn’t in the `BGTaskSchedulerPermittedIdentifiers` array in The Info.plist File.

## See Also

### Getting the error codes

`enum Code`

An enumeration of the task scheduling errors.

`static var tooManyPendingTaskRequests: BGTaskScheduler.Error.Code`

A task scheduling error that indicates there are too many pending tasks of the type requested.

`static var unavailable: BGTaskScheduler.Error.Code`

A task scheduling error that indicates the app or extension can’t schedule background work.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/toomanypendingtaskrequests

- Background Tasks
- BGTaskScheduler
- BGTaskScheduler.Error
- tooManyPendingTaskRequests

Type Property

# tooManyPendingTaskRequests

A task scheduling error that indicates there are too many pending tasks of the type requested.

static var tooManyPendingTaskRequests: BGTaskScheduler.Error.Code { get }

## Discussion

Try canceling some existing task requests and then resubmit the request that failed.

## See Also

### Getting the error codes

`enum Code`

An enumeration of the task scheduling errors.

`static var notPermitted: BGTaskScheduler.Error.Code`

A task scheduling error that indicates the app isn’t permitted to launch the task.

`static var unavailable: BGTaskScheduler.Error.Code`

A task scheduling error that indicates the app or extension can’t schedule background work.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/unavailable

- Background Tasks
- BGTaskScheduler
- BGTaskScheduler.Error
- unavailable

Type Property

# unavailable

A task scheduling error that indicates the app or extension can’t schedule background work.

static var unavailable: BGTaskScheduler.Error.Code { get }

## Discussion

This error usually occurs for one of three reasons:

- A person disabled background refresh in settings.

- The app runs on Simulator which doesn’t support background processing.

- The extension either didn’t set `RequestsOpenAccess` to `YES` in The Info.plist File, or a person didn’t grant open access.

## See Also

### Getting the error codes

`enum Code`

An enumeration of the task scheduling errors.

`static var notPermitted: BGTaskScheduler.Error.Code`

A task scheduling error that indicates the app isn’t permitted to launch the task.

`static var tooManyPendingTaskRequests: BGTaskScheduler.Error.Code`

A task scheduling error that indicates there are too many pending tasks of the type requested.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/errordomain

- Background Tasks
- BGTaskScheduler
- BGTaskScheduler.Error
- errorDomain

Type Property

# errorDomain

The background tasks error domain as a string.

static var errorDomain: String { get }

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/immediaterunineligible

- Background Tasks
- BGTaskScheduler
- BGTaskScheduler.Error
- immediateRunIneligible

Type Property

# immediateRunIneligible

static var immediateRunIneligible: BGTaskScheduler.Error.Code { get }

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/notpermitted)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/toomanypendingtaskrequests)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/unavailable)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/errordomain)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/immediaterunineligible)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code/notpermitted

- Background Tasks
- BGTaskScheduler
- BGTaskScheduler.Error
- BGTaskScheduler.Error.Code
- BGTaskScheduler.Error.Code.notPermitted

Case

# BGTaskScheduler.Error.Code.notPermitted

A task scheduling error that indicates the app isn’t permitted to launch the task.

case notPermitted

## Discussion

There are two causes for this error:

- The app didn’t set the appropriate mode in the `UIBackgroundModes` array.

- The task identifier of the submitted task wasn’t in the `BGTaskSchedulerPermittedIdentifiers` array in The Info.plist File.

## See Also

### Identifying an error

`case tooManyPendingTaskRequests`

A task scheduling error that indicates there are too many pending tasks of the type requested.

`case unavailable`

A task scheduling error that indicates the app or extension can’t schedule background work.

`case immediateRunIneligible`

A task scheduling error that indicates a task request didn’t run immediately due to system conditions.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code/unavailable

- Background Tasks
- BGTaskScheduler
- BGTaskScheduler.Error
- BGTaskScheduler.Error.Code
- BGTaskScheduler.Error.Code.unavailable

Case

# BGTaskScheduler.Error.Code.unavailable

A task scheduling error that indicates the app or extension can’t schedule background work.

case unavailable

## Discussion

This error usually occurs for one of three reasons:

- A person disabled background refresh in settings.

- The app runs on Simulator which doesn’t support background processing.

- The extension either didn’t set `RequestsOpenAccess` to `YES` in The Info.plist File, or a person didn’t grant open access.

## See Also

### Identifying an error

`case notPermitted`

A task scheduling error that indicates the app isn’t permitted to launch the task.

`case tooManyPendingTaskRequests`

A task scheduling error that indicates there are too many pending tasks of the type requested.

`case immediateRunIneligible`

A task scheduling error that indicates a task request didn’t run immediately due to system conditions.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code/immediaterunineligible

- Background Tasks
- BGTaskScheduler
- BGTaskScheduler.Error
- BGTaskScheduler.Error.Code
- BGTaskScheduler.Error.Code.immediateRunIneligible

Case

# BGTaskScheduler.Error.Code.immediateRunIneligible

A task scheduling error that indicates a task request didn’t run immediately due to system conditions.

case immediateRunIneligible

## Discussion

The framework throws this error when a `BGContinuedProcessingTaskRequest` that your app submits with `strategy` set to `BGContinuedProcessingTaskRequest.SubmissionStrategy.fail` isn’t able to begin right away due to runtime conditions.

If the task that fails submission is of high importance and your app has other tasks submitted, you can try canceling the other task requests and resubmit the failed request.

## See Also

### Identifying an error

`case notPermitted`

A task scheduling error that indicates the app isn’t permitted to launch the task.

`case tooManyPendingTaskRequests`

A task scheduling error that indicates there are too many pending tasks of the type requested.

`case unavailable`

A task scheduling error that indicates the app or extension can’t schedule background work.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code/init(rawvalue:)

#app-main)

- Background Tasks
- BGTaskScheduler
- BGTaskScheduler.Error
- BGTaskScheduler.Error.Code
- init(rawValue:)

Initializer

# init(rawValue:)

init?(rawValue: Int)

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code/notpermitted)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code/toomanypendingtaskrequests)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code/unavailable)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code/immediaterunineligible)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/error/code/init(rawvalue:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/getpendingtaskrequests(completionhandler:)

#app-main)

- Background Tasks
- BGTaskScheduler
- getPendingTaskRequests(completionHandler:)

Instance Method

# getPendingTaskRequests(completionHandler:)

Request a list of unexecuted scheduled task requests.

## Parameters

`completionHandler`

The completion handler called with the pending tasks. The handler may execute on a background thread.

The handler takes a single parameter `tasksRequests`, an array of `BGTaskRequest` objects. The array is empty if there are no scheduled tasks.

The objects passed in the array are copies of the existing requests. Changing the attributes of a request has no effect. To change the attributes submit a new task request using `submit(_:)`.

## Discussion

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/init(identifier:title:subtitle:)).

).#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtask/updatetitle(_:subtitle:)).

).#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequestresources/bgcontinuedprocessingtaskrequestresourcesdefault

- Background Tasks
- BGContinuedProcessingTaskRequest.Resources
- BGContinuedProcessingTaskRequestResourcesDefault

Enumeration Case

# BGContinuedProcessingTaskRequestResourcesDefault

An option for a task with no additional required system resources.

BGContinuedProcessingTaskRequestResourcesDefault

## Discussion

Unless informed otherwise, the scheduler assumes the default resources, allowing background CPU and network access.

## See Also

### Identiying a resource

`static var gpu: BGContinuedProcessingTaskRequest.Resources`

An option that indicates a long-running task requires the GPU.

---

# https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler/supportedresources).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequestresources/bgcontinuedprocessingtaskrequestresourcesdefault).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/submissionstrategy/queue).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/submissionstrategy/queue)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/resources/init(rawvalue:)

#app-main)

- Background Tasks
- BGContinuedProcessingTaskRequest
- BGContinuedProcessingTaskRequest.Resources
- init(rawValue:)

Initializer

# init(rawValue:)

Initializes a required resource for a Continuous Background Task by raw value.

init(rawValue: Int)

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/requiredresources).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/resources/gpu)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/resources/init(rawvalue:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/submissionstrategy/init(rawvalue:)

#app-main)

- Background Tasks
- BGContinuedProcessingTaskRequest
- BGContinuedProcessingTaskRequest.SubmissionStrategy
- init(rawValue:)

Initializer

# init(rawValue:)

Creates a submission strategy.

init?(rawValue: Int)

---

# https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtaskrequest/submissionstrategy/init(rawvalue:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

