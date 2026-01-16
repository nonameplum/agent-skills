<!--
Downloaded via https://llm.codes by @steipete on January 16, 2026 at 01:02 PM
Source URL: https://developer.apple.com/documentation/healthkit
Total pages processed: 188
URLs filtered: Yes
Content de-duplicated: Yes
Availability strings filtered: Yes
Code blocks only: No
-->

# https://developer.apple.com/documentation/healthkit

Framework

# HealthKit

Access and share health and fitness data while maintaining the user’s privacy and control.

## Overview

HealthKit provides a central repository for health and fitness data on iPhone and Apple Watch. With the user’s permission, apps communicate with the HealthKit store to access and share this data.

Creating a complete, personalized health and fitness experience includes a variety of tasks:

- Collecting and storing health and fitness data

- Analyzing and visualizing the data

- Enabling social interactions

HealthKit apps take a collaborative approach to building this experience. Your app doesn’t need to provide all of these features. Instead, you can focus just on the subset of tasks that most interests you.

For example, users can select their favorite weight-tracking, step-counting, and health challenge app, each calibrated to their personal needs. Because HealthKit apps freely exchange data (with user permission), the combined suite provides a more customized experience than any single app on its own. For example, when a group of friends joins a daily step-counting challenge, each person can use their preferred hardware device and app to track their steps, while everyone in the group uses the same social app for the challenge.

HealthKit is also designed to manage and merge data from multiple sources. For example, users can view and manage all of their data in the Health App, including adding data, deleting data, and changing an app’s permissions. Therefore, your app needs to handle these changes, even when they occur outside your app.

## Topics

### Essentials

About the HealthKit framework

Learn about the architecture and design of the HealthKit framework.

Set up and configure your HealthKit store.

Authorizing access to health data

Request permission to read and share data in your app.

Protecting user privacy

Respect and safeguard your user’s privacy.

HealthKit updates

Learn about important changes to HealthKit.

HealthKitUI

Display user interface that enables a person to view and interact with their health data.

### Health data

Saving data to HealthKit

Create and share HealthKit samples.

Reading data from HealthKit

Use queries to request sample data from HealthKit.

`class HKHealthStore`

The access point for all data managed by HealthKit.

Creating a Mobility Health App

Create a health app that allows a clinical care team to send and receive mobility data.

Specify the kind of data used in HealthKit.

Create and save health and fitness samples.

Query health and fitness data.

Visualizing HealthKit State of Mind in visionOS

Incorporate HealthKit State of Mind into your app and visualize the data in visionOS.

Logging symptoms associated with a medication

Fetch medications and dose events from the HealthKit store, and create symptom samples to associate with them.

### Workout data

Manage workouts, workout sessions, and activity summaries.

### Errors

`struct HKError`

An error returned from a HealthKit method.

`let HKErrorDomain: String`

The domain for all HealthKit errors.

`enum Code`

Error codes returned by HealthKit.

---

# https://developer.apple.com/documentation/healthkit/about-the-healthkit-framework

- HealthKit
- About the HealthKit framework

Article

# About the HealthKit framework

Learn about the architecture and design of the HealthKit framework.

## Overview

Share health and fitness data between apps using the HealthKit framework. Rather than developers creating custom data types and units, HealthKit constrains data types and units to a predefined list. This ensures that all apps understand what the data means and how they can use it.

Additionally, the framework uses a large number of subclasses, producing deep hierarchies of similar classes. Often, these classes have subtle but important differences between them. For example, you use an `HKQuantitySample` object to store data with a numeric value and an `HKCategorySample` object to store a value selected from an enumeration.

HealthKit also uses pairs of closely related classes that you need to use together. For example, the `HKObject` and `HKObjectType` abstract classes have largely parallel hierarchies of concrete subclasses. When working with objects and object types, you must use matching subclasses.

### HealthKit data

HealthKit saves a variety of data types in the HealthKit Store:

Characteristic data

Characteristics that typically don’t change, such as the user’s birthdate, blood type, biological sex, and skin type. You can read this data directly from the HealthKit store, using the `dateOfBirth()`, `bloodType()`, `biologicalSex()`, and `fitzpatrickSkinType()` methods. Your application can’t save characteristic data. The user must enter or modify this data using the Health app.

Sample data

Samples that represent a measurement at a particular point in time. All sample classes are subclasses of the `HKSample` class, which is a subclass of the `HKObject` class. For more information, see Samples.

Workout data

Samples that store information about fitness and exercise activities. While `HKWorkout` is a subclass of `HKSample`, it behaves somewhat differently than other sample subclasses. For more information, see Workout data.

Source data

Information about a sample’s source. The `HKSourceRevision` object contains information about the app or device that saved the sample. The `HKDevice` object contains information about the hardware device that generated the data.

Deleted objects

An object that represents a sample after something deletes it from the HealthKit store. HealthKit uses an `HKDeletedObject` instance to temporarily store the UUID of deleted samples. You can use deleted objects to respond when the user or another app deletes an object. For more information, see `HKAnchoredObjectQuery` and `HKDeletedObject`.

### Properties of objects and samples

The `HKObject` class is the superclass of all HealthKit sample types. All `HKObject` subclasses are immutable. Each object has the following properties:

UUID

A unique identifier for that particular entry.

Metadata

A dictionary containing additional information about the entry. The metadata can contain both predefined and custom keys. The predefined keys facilitate the sharing of data between apps. Custom keys help extend a given HealthKit object type, adding app-specific data to the entry.

Source Revision

The source of the sample. The source can be a device that directly saves data into HealthKit or an app. HealthKit automatically records each object’s source and version when it saves the data to the HealthKit store. This property is available only on objects retrieved from the store.

Device

The hardware device that generated the data stored in this sample.

The `HKSample` class is a subclass of `HKObject`. Sample objects represent data at a particular point in time, and all sample objects are subclasses of the `HKSample` class. They have the following properties:

Type

The sample type, such as a sleep analysis sample, a height sample, or a step count sample.

Start date

The sample’s start time.

End date

The sample’s end time. If the sample represents a single point in time, the end time should equal the start time. If the sample represents data collected over a time interval, the end time should occur after the start time.

Samples are further divided into four concrete subclasses:

Category samples

Data that can you can classify into a finite set of categories. See `HKCategorySample`.

Quantity samples

Data that you can store as numeric values. Quantity samples are the most common data types in HealthKit. These include the user’s height and weight, as well as other data such as the number of steps taken, the user’s temperature, and their pulse rate. See `HKQuantitySample`.

Correlations

Composite data containing one or more samples. HealthKit uses correlations to represent food and blood pressure. You should always use a correlation when creating food or blood pressure data. See `HKCorrelation`.

Workouts

Data representing a physical activity, like running, swimming, or even play. Workouts often have _type_, _duration_, _distance_, and _energy burned_ properties. You can also associate a workout with additional, fine-grained samples. Unlike correlations, the workout doesn’t contain these samples; however, you can query for them using the workout. For more information, see `HKWorkout`.

### Threading

The HealthKit store is thread-safe, and most HealthKit objects are immutable. In general, you can use HealthKit safely in a multithreaded environment.

For more information about multithreading and concurrent programming, see Concurrency Programming Guide.

### Syncing data between devices

iPhone, Apple Watch, and visionOS each have their own HealthKit store. iPadOS 17 and later also has its own HealthKit store. It is also available on iPadOS apps running on Vision Pro. HealthKit automatically syncs data between these devices. To save space, old data is periodically purged from Apple Watch. Use `earliestPermittedSampleDate()` to determine the earliest samples available on Apple Watch.

While the HealthKit framework is available on iPadOS 16 and earlier and on MacOS 13 and later, these devices don’t have a copy of the HealthKit store. This means you can include HealthKit code in apps running on these devices, simplifying the creation of multiplatform apps. However, they can’t read or write HealthKit data, and calls to `isHealthDataAvailable()` return `false`.

## See Also

### Essentials

Set up and configure your HealthKit store.

Authorizing access to health data

Request permission to read and share data in your app.

Protecting user privacy

Respect and safeguard your user’s privacy.

HealthKit updates

Learn about important changes to HealthKit.

HealthKitUI

Display user interface that enables a person to view and interact with their health data.

---

# https://developer.apple.com/documentation/healthkit/setting-up-healthkit

Collection

- HealthKit
- Setting up HealthKit

# Setting up HealthKit

Set up and configure your HealthKit store.

## Overview

Before using HealthKit, you must perform the following steps:

1. Enable HealthKit in your app.

2. Ensure HealthKit is available on the current device.

3. Create your app’s HealthKit store.

4. Request permission to read and share data.

The following sections describe the first three steps in detail. For more information on requesting authorization, see Authorizing access to health data. For a practical example of how to set up and use HealthKit, see Build a workout app for Apple Watch.

### Enable HealthKit

Before you can use HealthKit, you must enable the HealthKit capabilities for your app. In Xcode, select the project and add the HealthKit capability. Only select the Clinical Health Records checkbox if your app needs to access the user’s clinical records. App Review may reject apps that enable the Clinical Health Records capability if the app doesn’t actually use the health record data. For more information, see Accessing Health Records.

For a detailed discussion about enabling capabilities, see Configuring HealthKit access.

When you enable the HealthKit capabilities on an iOS app, Xcode adds HealthKit to the list of required device capabilities, which prevents users from purchasing or installing the app on devices that don’t support HealthKit.

If HealthKit isn’t required for the correct operation of your app, delete the `healthkit` entry from the “Required device capabilities” array. Delete this entry from either the Target Properties list on the app’s Info tab or from the app’s `Info.plist` file.

For more information on required device capabilities, see the `UIRequiredDeviceCapabilities`.

### Ensure HealthKit’s availability

Call the `isHealthDataAvailable()` method to confirm that HealthKit is available on the user’s device.

if HKHealthStore.isHealthDataAvailable() {
// Add code to use HealthKit here.
}

Call this method before calling any other HealthKit methods. If HealthKit isn’t available on the device (for example, on iPadOS 16 or earlier, or macOS), other HealthKit methods fail with an `errorHealthDataUnavailable` error. If HealthKit is restricted (for example, in an enterprise environment), the methods fail with an `errorHealthDataRestricted` error.

### Create the HealthKit store

If HealthKit is both enabled and available, instantiate an `HKHealthStore` object for your app as shown:

let healthStore = HKHealthStore()

You need only a single HealthKit store per app. These are long-lived objects; you create the store once, and keep a reference for later use.

## Topics

### Entitlements

`HealthKit Entitlement`

A Boolean value that indicates whether the app may request user authorization to access health and activity data that appears in the Health app.

`HealthKit Capabilities Entitlement`

Health data types that require additional permission.

### Information property list keys

`NSHealthUpdateUsageDescription`

A message to the user that explains why the app requested permission to save samples to the HealthKit store.

`NSHealthShareUsageDescription`

A message that explains to people why the app requests permission to read samples from the HealthKit store.

`NSHealthRequiredReadAuthorizationTypeIdentifiers`

The clinical record data types that your app must get permission to read.

`NSHealthClinicalHealthRecordsShareUsageDescription`

A message to the user that explains why the app requested permission to read clinical records.

## See Also

### Essentials

About the HealthKit framework

Learn about the architecture and design of the HealthKit framework.

Authorizing access to health data

Request permission to read and share data in your app.

Protecting user privacy

Respect and safeguard your user’s privacy.

HealthKit updates

Learn about important changes to HealthKit.

HealthKitUI

Display user interface that enables a person to view and interact with their health data.

---

# https://developer.apple.com/documentation/healthkit/authorizing-access-to-health-data

- HealthKit
- Authorizing access to health data

Article

# Authorizing access to health data

Request permission to read and share data in your app.

## Overview

To help protect people’s privacy, HealthKit requires fine-grained authorization. You need to request permission to both read and share each data type before your app attempts to use the data. However, you don’t need to request permission for all data types at once. Instead, it might make more sense to wait until you need to access the data before asking for permission.

As part of the privacy protections, your app doesn’t know whether someone granted or denied permission to read data from HealthKit. If they denied permission, attempts to read data from HealthKit return only samples that your app successfully saved to the HealthKit store. Additionally, in a Guest User session on Apple Vision Pro, the guest can view previously authorized data, but can’t access unauthorized data or change the authorizations.

Requesting permission to read and share data is only one part of protecting your user’s privacy. For more information, see Protecting user privacy.

### Enable HealthKit

Before you can request authorization to read or save HealthKit data, you need to add the HealthKit capability to your app. You must also provide custom messages for the Health permissions sheet.

Xcode requires separate custom messages for reading and writing HealthKit data. Set the `NSHealthShareUsageDescription` key to customize the message for reading data and the `NSHealthUpdateUsageDescription` key to customize the message for writing data.

For projects created using Xcode 13 or later, set these keys in the Target Properties list on the app’s Info tab. For projects created with Xcode 12 or earlier, set these keys in the app’s `Info.plist` file. For more information, see `Information Property List`.

Finally, check that Health data is available on the current device by calling `isHealthDataAvailable()` before calling any other HealthKit methods. For more information, see Setting up HealthKit.

### Request permission

To request permission to read or write data, start by creating the HealthKit data types that you want to read or write. The following example creates data types for active energy burned, distance cycling, distance walking or running, distance in a wheelchair, and heart rate.

// Create the HealthKit data types your app
// needs to read and write.
let allTypes: Set = [\
HKQuantityType.workoutType(),\
HKQuantityType(.activeEnergyBurned),\
HKQuantityType(.distanceCycling),\
HKQuantityType(.distanceWalkingRunning),\
HKQuantityType(.distanceWheelchair),\
HKQuantityType(.heartRate)\
]

Next, you can request read or write access to that data. To request access from the HealthKit store, call `requestAuthorization(toShare:read:)`.

do {
// Check that Health data is available on the device.
if HKHealthStore.isHealthDataAvailable() {

// Asynchronously request authorization to the data.
try await healthStore.requestAuthorization(toShare: allTypes, read: allTypes)
}
} catch {

// Typically, authorization requests only fail if you haven't set the
// usage and share descriptions in your app's Info.plist, or if
// Health data isn't available on the current device.
fatalError("*** An unexpected error occurred while requesting authorization: \(error.localizedDescription) ***")
}

To request access from SwiftUI, use the `healthDataAccessRequest(store:shareTypes:readTypes:trigger:completion:)``modifier.`

import SwiftUI
import HealthKitUI

struct MyView: View {
@State var authenticated = false
@State var trigger = false

var body: some View {
Button("Access health data") {
// OK to read or write HealthKit data here.
}
.disabled(!authenticated)

// If HealthKit data is available, request authorization
// when this view appears.
.onAppear() {

// Check that Health data is available on the device.
if HKHealthStore.isHealthDataAvailable() {
// Modifying the trigger initiates the health data
// access request.
trigger.toggle()
}
}

// Requests access to share and read HealthKit data types
// when the trigger changes.
.healthDataAccessRequest(store: healthStore,
shareTypes: allTypes,
readTypes: allTypes,
trigger: trigger) { result in
switch result {

case .success(_):
authenticated = true
case .failure(let error):
// Handle the error here.
fatalError("*** An error occurred while requesting authentication: \(error) ***")
}
}
}
}

Any time your app requests new permissions, the system displays a form with all the requested data types shown. People can toggle individual read and share permissions on and off.

### Check for authorization before saving data

If someone grants permission to share a data type, you can create new samples of that type and save them to the HealthKit store. However, before attempting to save any data, check to see if your app is authorized to share that data type by calling the `authorizationStatus(for:)` method. If you haven’t yet requested permission, any attempts to save fail with an `HKError.Code.errorAuthorizationNotDetermined` error. If they’ve denied permission, attempts to save fail with an `HKError.Code.errorAuthorizationDenied` error.

### Support Guest User sessions on Vision Pro

To protect their privacy, people can put their Vision Pro in a Guest User session before sharing it. This session lets the owner control which apps the guest can use, and what data they can see. For more information, refer to Let another person use your Apple Vision Pro with Guest User.

A Guest User session has the following affects on HealthKit:

- If the owner has already authorized access to the data, the guest can read that data from the HealthKit store.

- The guest can’t authorize any additional data types.

- The system obscures Health data in the Privacy and Security and Health Data panels in Settings.

- Any attempts to save data or otherwise mutate data in the HealthKit store fails with an `HKError.Code.errorNotPermissibleForGuestUserMode` error (or `HKError.Code.errorHealthDataRestricted` on apps running in iOS 17).

Any attempt to request authorization for HealthKit data types fails silently. The system doesn’t display the authorization sheet during a Guest User session.

If your app receives an `HKError.Code.errorNotPermissibleForGuestUserMode` error, you can silently ignore the error for passive or periodic saves. Silently dropping the changes ensures that they don’t persist past the Guest User session without interrupting the guest’s experience. However, if the guest performs an action that would obviously result in saving data (for example, tapping a Save button), you can display an alert telling them that the action isn’t available during a Guest User session.

### Specify required clinical record types

If your app requires access to specific clinical record data to function properly, specify the required clinical record types in your app’s `Info.plist` file using the `NSHealthRequiredReadAuthorizationTypeIdentifiers` key. This key defines the data types that your app must have permission to read. Set the value to an array of strings containing the type identifiers for your required types. For a list of type identifiers, see `HKClinicalTypeIdentifier`.

To protect people’s privacy, you must specify three or more required clinical record types. If a person denies authorization to any of the types, authorization fails with an `HKError.Code.errorRequiredAuthorizationDenied` error; the system doesn’t tell your app which record types the person denied access to.

## See Also

### Essentials

About the HealthKit framework

Learn about the architecture and design of the HealthKit framework.

Set up and configure your HealthKit store.

Protecting user privacy

Respect and safeguard your user’s privacy.

HealthKit updates

Learn about important changes to HealthKit.

HealthKitUI

Display user interface that enables a person to view and interact with their health data.

---

# https://developer.apple.com/documentation/healthkit/protecting-user-privacy

- HealthKit
- Protecting user privacy

Article

# Protecting user privacy

Respect and safeguard your user’s privacy.

## Overview

Because health data can be sensitive, HealthKit provides users with fine-grained control over the information that apps can share. The user must explicitly grant each app permission to read and write data to the HealthKit store. Users can grant or deny permission separately for each type of data.

For example, a user could let your app read step count data, but prevent it from reading blood glucose levels. To prevent possible information leaks, an app isn’t aware when the user denies permission to read data. From the app’s point of view, no data of that type exists.

### Access encrypted data

The user’s device stores all HealthKit data locally. For security, the device encrypts the HealthKit store when the user locks the device. As a result, your app may not be able to read data from the store when it runs in the background. However, your app can still write to the store, even when the phone is locked. HealthKit temporarily caches the data and saves it to the encrypted store as soon as the user unlocks the phone.

### Specify how your app uses the health data

In addition, your app must not access the HealthKit APIs unless the use is for health or fitness purposes and this usage is clear in both your marketing text and your user interface. Specifically, the following guidelines apply to all HealthKit apps:

- Your app may not use information gained through the use of the HealthKit framework for advertising or similar services. Note that you may still serve advertising in an app that uses the HealthKit framework, but you can’t use data from the HealthKit store to serve ads.

- You must not disclose any information gained through HealthKit to a third party without express permission from the user. Even with permission, you can only share information to a third party if they also provide a health or fitness service to the user.

- You can’t sell information gained through HealthKit to advertising platforms, data brokers, or information resellers.

- If the user consents, you may share their HealthKit data with a third party for medical research.

- You must clearly disclose to the user how you and your app will use their HealthKit data.

### Provide a

You must also provide a for any app that uses the HealthKit framework. You can find guidance on creating a at the following sites:

- Personal Health Record model (for non-HIPAA apps):

- HIPAA model (for HIPAA covered apps):

These models, developed by the Office of the National Coordinator for Health Information Technology (ONC), are designed to improve user experience and comprehension with plain language and approachable designs that explain how your app collects and shares user data. These models aren’t intended to replace a web-based , and developers should consult ONC guidance regarding which model is appropriate for a given app. These models are provided for your reference only, and Apple expressly disclaims all liability for your use of such models.

## See Also

### Essentials

About the HealthKit framework

Learn about the architecture and design of the HealthKit framework.

Set up and configure your HealthKit store.

Authorizing access to health data

Request permission to read and share data in your app.

HealthKit updates

Learn about important changes to HealthKit.

HealthKitUI

Display user interface that enables a person to view and interact with their health data.

---

# https://developer.apple.com/documentation/healthkit/saving-data-to-healthkit

- HealthKit
- Saving data to HealthKit

Article

# Saving data to HealthKit

Create and share HealthKit samples.

## Overview

Your app can create new samples and add them to the HealthKit store. Although all sample types follow a similar procedure, each type has its own variations:

1. Look up the type identifier for your data. For example, to record the user’s weight, you use the `bodyMass` type identifier. For the complete list of type identifiers, see Data types.

2. Use the convenience methods on the `HKObjectType` class to create the correct object type for your data. For example, to save the user’s weight, you’d create an `HKQuantityType` object using the `quantityType(forIdentifier:)` method. For a list of convenience methods, see `HKObjectType`.

3. Instantiate an object of the matching `HKSample` subclass using the object type.

4. Save the object to the HealthKit store using the `save(_:withCompletion:)` method.

Each `HKSample` subclass has its own convenience methods for instantiating sample objects, which modify the steps described in the list above.

For quantity samples, create an instance of the `HKQuantity` class. The quantity’s units must correspond to the allowable units described in the type identifier’s documentation. For example, the `height` documentation states that it uses length units. Therefore, your quantity must use centimeters, meters, feet, inches, or another compatible unit. For more information, see `HKQuantitySample`.

For category samples, the sample’s value must correspond to the enum described in the type identifier’s documentation. For example, the `sleepAnalysis` documentation states that it uses the `HKCategoryValueSleepAnalysis` enum. Therefore, you must pass a value from this enum when creating this sample. For more information, see `HKCategorySample`.

For correlations, you must first create all the sample objects that the correlation will contain. The correlation’s type identifier describes both the type and the number of objects that can be contained. Don’t save the contained objects into the HealthKit store. They’re stored as part of the correlation. For more information, see `HKCorrelation`.

### Balance performance and details

When saving data to the HealthKit store, you often need to choose between using a single sample to represent the data or splitting the data across multiple, smaller samples. A single, long sample is better from a performance perspective; however, multiple smaller samples gives the user a more detailed look into how their data changes over time. Ideally, you want to find a sample size that’s granular enough to provide the user with useful historical data and you should avoid saving samples that are 24 hours long or longer.

When recording a workout, you can use high frequency data (a minute or less per sample) to provide intensity charts and otherwise analyze the user’s performance over the workout. For less intensive activity, like daily step counts, samples of an hour or less often work best. This lets you produce meaningful daily and hourly graphs.

Most sample types have restrictions on duration. If you attempt to save a sample that doesn’t meet those restrictions, it fails to save. For more details on checking the duration restrictions, refer to `HKSampleType`.

### Work with data in the Health app

The Health app gives users access to all of the data in their HealthKit store. Users can view, add, delete, and manage their data.

Specifically, users can:

- See a dashboard containing their current health data.

- Access all the data stored in HealthKit. Users can view the data by type, by app, or by device.

- Manage each app’s permission to read and write from the HealthKit store.

As a result, the Health app has a few important impacts on developing HealthKit apps. First, remember that users can always modify their data outside your app or even change your permission to access their data. As a result, your app should always query for the current data in the HealthKit store or perform background queries to track changes to the store.

Second, you can also use the Health app to view the data your app is saving to the HealthKit store. This can be particularly useful during early testing, to verify that your app is saving everything as expected.

## See Also

### Health data

Reading data from HealthKit

Use queries to request sample data from HealthKit.

`class HKHealthStore`

The access point for all data managed by HealthKit.

Creating a Mobility Health App

Create a health app that allows a clinical care team to send and receive mobility data.

Specify the kind of data used in HealthKit.

Create and save health and fitness samples.

Query health and fitness data.

Visualizing HealthKit State of Mind in visionOS

Incorporate HealthKit State of Mind into your app and visualize the data in visionOS.

Logging symptoms associated with a medication

Fetch medications and dose events from the HealthKit store, and create symptom samples to associate with them.

---

# https://developer.apple.com/documentation/healthkit/reading-data-from-healthkit

- HealthKit
- Reading data from HealthKit

Article

# Reading data from HealthKit

Use queries to request sample data from HealthKit.

## Overview

There are three main ways to access data from the HealthKit Store:

- **Direct method calls.** The HealthKit store provides methods to directly access characteristic data. These methods only access characteristic data. For more information, see `HKHealthStore`.

- **Queries.** Queries return the current snapshot of the requested data from the HealthKit store.

- **Long-running queries.** These queries continue to run in the background and update your app whenever the system detects changes to the HealthKit store.

### Queries

Queries return the current snapshot of the data in the HealthKit store. All queries run on an anonymous background queue. When the query is complete, it executes the results handler on the background queue. HealthKit provides different types of queries, each designed to return different types of data from the HealthKit store.

- **Sample query.** This is a general-purpose query. Use sample queries to access any type of sample data. Sample queries are particularly useful when you want to sort the results or limit the total number of samples returned. For more information, see `HKSampleQueryDescriptor`.

- **Anchored object query.** Use this query to search for changes to the HealthKit store. The first time you run an anchor query, it returns all the matching samples currently in the store. On subsequent runs, it returns only those items added or deleted since the last run. For more information, see `HKAnchoredObjectQueryDescriptor`.

- **Statistics query.** Use this query to perform statistical calculations over the set of matching samples. You can use statistics queries to calculate the sum, minimum, maximum, or average value in the set. For more information, see `HKStatisticsQueryDescriptor`.

- **Statistics collection query.** Use this query to perform multiple statistics queries over a series of fixed-length time intervals. You often use these queries when creating graphs. They provide a simple method for calculating things such as the total number of calories consumed each day or the number of steps taken during each five-minute interval. For more information, see `HKStatisticsCollectionQueryDescriptor`.

- **Correlation query.** Use this query to perform complex searches of the data contained in a correlation. These queries can contain individual predicates for each of the sample types stored in the correlation. If you just want to match the correlation type, use a sample query instead. For more information, see `HKCorrelationQuery`.

- **Source query.** Use this query to search for sources (apps and devices) that have saved matching samples to the HealthKit store. A source query lists all the sources that are saving a particular sample type. For more information, see `HKSourceQueryDescriptor`.

- **Activity summary query.** Use this query to search for activity summary information for the user. Each activity summary object contains a summary of the user’s activity for a given day. You can query for either a single day or a range of days. For more information, see `HKActivitySummaryQueryDescriptor`.

- **Document query.** Use this query to search for health documents. For more information, see `HKDocumentQuery`.

### Long-running queries

Long-running queries continue to run an anonymous background queue, and update your app whenever the system detects changes to the HealthKit store. In addition, observer queries can register for background delivery. This lets HealthKit wake your app in the background whenever an update occurs.

HealthKit provides the following long-running queries:

- **Observer query.** This long-running query monitors the HealthKit store and alerts you to any changes to matching samples. Use an observer query when you want the system to notify you about changes to the store. You can register observer queries for background delivery. For more information, see `HKObserverQuery`.

- **Anchored object query.** In addition to returning the current snapshot of modified data, an anchored object query can act as a long-running query. If enabled, it continues to run in the background, providing updates when something adds or removes matching samples from the store. Unlike the observer query, these updates include a list of items that have changed; however, you can’t register anchored object queries for background delivery. For more information, see `HKAnchoredObjectQueryDescriptor`

- **Statistics collection query.** In addition to calculating the current snapshot of statistical collections, this query can act as a long-running query. If something adds or removes matching samples from the store, this query recalculates the statistics collections and updates your app. You can’t register statistics collection queries for background delivery. For more information, see `HKStatisticsCollectionQueryDescriptor`.

- **Activity summary query.** In addition to calculating the current snapshot of the user’s activity summary, this query can act as a long-running query. If the user’s activity summary data changes, this query recalculates the activity summary and updates your app. You can’t register activity summary queries for background delivery. For more information, see `HKActivitySummaryQueryDescriptor`.

## See Also

### Health data

Saving data to HealthKit

Create and share HealthKit samples.

`class HKHealthStore`

The access point for all data managed by HealthKit.

Creating a Mobility Health App

Create a health app that allows a clinical care team to send and receive mobility data.

Specify the kind of data used in HealthKit.

Create and save health and fitness samples.

Query health and fitness data.

Visualizing HealthKit State of Mind in visionOS

Incorporate HealthKit State of Mind into your app and visualize the data in visionOS.

Logging symptoms associated with a medication

Fetch medications and dose events from the HealthKit store, and create symptom samples to associate with them.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore

- HealthKit
- HKHealthStore

Class

# HKHealthStore

The access point for all data managed by HealthKit.

class HKHealthStore

## Mentioned in

Executing Observer Queries

Reading data from HealthKit

## Overview

Use a `HKHealthStore` object to request permission to share or read HealthKit data. After you have permission, you can use the HealthKit store to save new samples to the store, or to manage the samples that your app saved. Additionally, you can use the HealthKit store to start, stop, and manage queries.

For more information, see Setting up HealthKit.

## Topics

### Accessing HealthKit

Returns the app’s authorization status for sharing the specified data type.

`enum HKAuthorizationStatus`

Constants indicating the authorization status for a particular data type.

Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

`enum HKAuthorizationRequestStatus`

Values that indicate whether your app needs to request authorization from the user.

Returns a Boolean value that indicates whether HealthKit is available on this device.

Returns a Boolean value that indicates whether the current device supports clinical records.

Requests permission to save and read the specified data types.

Asynchronously requests permission to save and read the specified data types.

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

Requests permission to save and read the data types specified by an extension.

`var authorizationViewControllerPresenter: UIViewController?`

The view controller that presents HealthKit authorization sheets.

### Querying HealthKit data

`func execute(HKQuery)`

Starts executing the provided query.

`func stop(HKQuery)`

Stops a long-running query.

### Reading characteristic data

Reads someone’s biological sex from the HealthKit store.

Reads the user’s blood type from the HealthKit store.

Reads the user’s date of birth from the HealthKit store as a date value.

Deprecated

Reads the user’s date of birth from the HealthKit store as date components.

Reads the user’s Fitzpatrick Skin Type from the HealthKit store.

Reads the user’s wheelchair use from the HealthKit store.

### Working with HealthKit objects

Deletes the specified object from the HealthKit store.

Deletes the specified objects from the HealthKit store.

Deletes objects saved by this application that match the provided type and predicate.

Returns the earliest date permitted for samples.

Saves the provided object to the HealthKit store.

Saves an array of objects to the HealthKit store.

### Accessing the preferred units

Returns the user’s preferred units for the given quantity types.

`static let HKUserPreferencesDidChange: NSNotification.Name`

Notifies observers whenever the user changes his or her preferred units.

### Managing background delivery

Enables the delivery of updates to an app running in the background.

`com.apple.developer.healthkit.background-delivery`

A Boolean value that indicates whether observer queries receive updates while running in the background.

`enum HKUpdateFrequency`

Constants that determine how often the system launches your app in response to changes to HealthKit data.

Disables background deliveries of update notifications for the specified data type.

Disables all background deliveries of update notifications.

### Managing workouts

Calculates the active and resting energy burned based on the total energy burned over the given duration.

Recovers an active workout session.

### Managing workout sessions

A block that the system calls when it starts a mirrored workout session.

Launches or wakes the companion watchOS app to create a new workout session.

`func pause(HKWorkoutSession)`

Pauses the provided workout session.

`func resumeWorkoutSession(HKWorkoutSession)`

Resumes the provided workout session.

### Managing estimates

Recalibrates the prediction algorithm used to calculate the specified sample type.

### Accessing the move mode

Returns the activity move mode for the current user.

### Deprecated symbols

Associates the provided samples with the specified workout.

`func start(HKWorkoutSession)`

Starts a workout session for the current app.

`func end(HKWorkoutSession)`

Ends a workout session for the current app.

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
- `Sendable`
- `SendableMetatype`

## See Also

### Health data

Saving data to HealthKit

Create and share HealthKit samples.

Use queries to request sample data from HealthKit.

Creating a Mobility Health App

Create a health app that allows a clinical care team to send and receive mobility data.

Specify the kind of data used in HealthKit.

Create and save health and fitness samples.

Query health and fitness data.

Visualizing HealthKit State of Mind in visionOS

Incorporate HealthKit State of Mind into your app and visualize the data in visionOS.

Logging symptoms associated with a medication

Fetch medications and dose events from the HealthKit store, and create symptom samples to associate with them.

---

# https://developer.apple.com/documentation/healthkit/creating-a-mobility-health-app

- HealthKit
- Creating a Mobility Health App

Sample Code

# Creating a Mobility Health App

Create a health app that allows a clinical care team to send and receive mobility data.

Download

Xcode 12.4+

## Overview

### Configure the Sample Code Project

Before you run the sample code project in Xcode:

- Download the latest version of Xcode with the iOS 14 SDK. The sample code project requires this version of Xcode.

- Confirm that CareKit is included as a dependency in Swift Packages.

## See Also

### Health data

Saving data to HealthKit

Create and share HealthKit samples.

Reading data from HealthKit

Use queries to request sample data from HealthKit.

`class HKHealthStore`

The access point for all data managed by HealthKit.

Specify the kind of data used in HealthKit.

Create and save health and fitness samples.

Query health and fitness data.

Visualizing HealthKit State of Mind in visionOS

Incorporate HealthKit State of Mind into your app and visualize the data in visionOS.

Logging symptoms associated with a medication

Fetch medications and dose events from the HealthKit store, and create symptom samples to associate with them.

---

# https://developer.apple.com/documentation/healthkit/data-types

Collection

- HealthKit
- Data types

API Collection

# Data types

Specify the kind of data used in HealthKit.

## Overview

HealthKit uses `HKObjectType` subclasses to identify the different types of data stored in HealthKit, from inherent data that doesn’t typically change over time to complex data types that combine multiple samples or compute values over sets of samples.

To create a type object, call the appropriate `HKObjectType` class method, and pass in the desired type identifier.

let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType)

let caloriesConsumed = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)

let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)

You can use the resulting object types to request permission to access the data, save new data to the HealthKit store, or read data from the HealthKit store.

## Topics

### Object type subclasses

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`class HKQuantityType`

A type that identifies samples that store numerical values.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCorrelationType`

A type that identifies samples that group multiple subsamples.

`class HKActivitySummaryType`

A type that identifies activity summary objects.

`class HKAudiogramSampleType`

A type that identifies samples that contain audiogram data.

`class HKElectrocardiogramType`

A type that identifies samples containing electrocardiogram data.

`class HKSeriesType`

A type that indicates the data stored in a series sample.

`class HKClinicalType`

A type that identifies samples that contain clinical record data.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`class HKObjectType`

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

`class HKSampleType`

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

### Characteristic identifiers

`static let activityMoveMode: HKCharacteristicTypeIdentifier`

A characteristic identifier for the user’s activity mode.

`static let biologicalSex: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s sex.

`static let bloodType: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s blood type.

`static let dateOfBirth: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s date of birth.

`static let fitzpatrickSkinType: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s skin type.

`static let wheelchairUse: HKCharacteristicTypeIdentifier`

A characteristic identifier for the user’s use of a wheelchair.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

`static let nikeFuel: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of NikeFuel points the user has earned.

`static let appleExerciseTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the user spent exercising.

`static let appleMoveTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the user has spent performing activities that involve full-body movements during the specified day.

`static let appleStandHour: HKCategoryTypeIdentifier`

A category sample type that counts the number of hours in the day during which the user has stood and moved for at least one minute per hour.

`static let appleStandTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the user has spent standing.

`static let vo2Max: HKQuantityTypeIdentifier`

A quantity sample that measures the maximal oxygen consumption during exercise.

`static let lowCardioFitnessEvent: HKCategoryTypeIdentifier`

An event that indicates the user’s VO2 max values consistently fall below a particular aerobic fitness threshold.

### Attachments

`class HKAttachment`

A file that is attached to a sample in the HealthKit store.

`class HKAttachmentStore`

The access point for attachments associated with samples in the HealthKit store.

`class HKAttachmentDataReader`

A reader that provides access to an attachment’s data.

### Body measurements

`static let height: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s height.

`static let bodyMass: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s weight.

`static let bodyMassIndex: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body mass index.

`static let leanBodyMass: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s lean body mass.

`static let bodyFatPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body fat percentage.

`static let waistCircumference: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s waist circumference.

### Reproductive health

`static let menstrualFlow: HKCategoryTypeIdentifier`

A category sample type that records menstrual cycles.

`static let intermenstrualBleeding: HKCategoryTypeIdentifier`

A category sample type that records spotting outside the normal menstruation period.

`static let infrequentMenstrualCycles: HKCategoryTypeIdentifier`

A category sample that indicates an infrequent menstrual cycle.

`static let irregularMenstrualCycles: HKCategoryTypeIdentifier`

A category sample that indicates an irregular menstrual cycle.

`static let persistentIntermenstrualBleeding: HKCategoryTypeIdentifier`

A category sample that indicates persistent intermenstrual bleeding.

`static let prolongedMenstrualPeriods: HKCategoryTypeIdentifier`

A category sample that indicates a prolonged menstrual cycle.

`static let basalBodyTemperature: HKQuantityTypeIdentifier`

A quantity sample type that records the user’s basal body temperature.

`static let cervicalMucusQuality: HKCategoryTypeIdentifier`

A category sample type that records the quality of the user’s cervical mucus.

`static let ovulationTestResult: HKCategoryTypeIdentifier`

A category sample type that records the result of an ovulation home test.

`static let progesteroneTestResult: HKCategoryTypeIdentifier`

A category type that represents the results from a home progesterone test.

`static let sexualActivity: HKCategoryTypeIdentifier`

A category sample type that records sexual activity.

`static let contraceptive: HKCategoryTypeIdentifier`

A category sample type that records the use of contraceptives.

`static let pregnancy: HKCategoryTypeIdentifier`

A category type that records pregnancy.

`static let pregnancyTestResult: HKCategoryTypeIdentifier`

A category type that represents the results from a home pregnancy test.

`static let lactation: HKCategoryTypeIdentifier`

A category type that records lactation.

### Hearing

`static let environmentalAudioExposure: HKQuantityTypeIdentifier`

A quantity sample type that measures audio exposure to sounds in the environment.

`static let headphoneAudioExposure: HKQuantityTypeIdentifier`

A quantity sample type that measures audio exposure from headphones.

`static let environmentalAudioExposureEvent: HKCategoryTypeIdentifier`

A category sample type that records exposure to potentially damaging sounds from the environment.

`static let headphoneAudioExposureEvent: HKCategoryTypeIdentifier`

A category sample type that records exposure to potentially damaging sounds from headphones.

`static let audioExposureEvent: HKCategoryTypeIdentifier`

A category sample type for audio exposure events.

Deprecated

### Vital signs

`static let heartRate: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s heart rate.

`static let lowHeartRateEvent: HKCategoryTypeIdentifier`

A category sample type for low heart rate events.

`static let highHeartRateEvent: HKCategoryTypeIdentifier`

A category sample type for high heart rate events.

`static let irregularHeartRhythmEvent: HKCategoryTypeIdentifier`

A category sample type for irregular heart rhythm events.

`static let restingHeartRate: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s resting heart rate.

`static let heartRateVariabilitySDNN: HKQuantityTypeIdentifier`

A quantity sample type that measures the standard deviation of heartbeat intervals.

`static let heartRateRecoveryOneMinute: HKQuantityTypeIdentifier`

A quantity sample that records the reduction in heart rate from the peak exercise rate to the rate one minute after exercising ended.

`static let atrialFibrillationBurden: HKQuantityTypeIdentifier`

A quantity type that measures an estimate of the percentage of time a person’s heart shows signs of atrial fibrillation (AFib) while wearing Apple Watch.

`static let walkingHeartRateAverage: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s heart rate while walking.

`let HKDataTypeIdentifierHeartbeatSeries: String`

A series sample containing heartbeat data.

`static let oxygenSaturation: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s oxygen saturation.

`static let bodyTemperature: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body temperature.

`static let bloodPressure: HKCorrelationTypeIdentifier`

A correlation sample that combines a systolic sample and a diastolic sample into a single blood pressure reading.

`static let bloodPressureSystolic: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s systolic blood pressure.

`static let bloodPressureDiastolic: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s diastolic blood pressure.

`static let respiratoryRate: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s respiratory rate.

### Nutrition

Type identifiers used for tracking diet and nutrition.

### Alcohol consumption

`static let bloodAlcoholContent: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s blood alcohol content.

`static let numberOfAlcoholicBeverages: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of standard alcoholic drinks that the user has consumed.

### Mobility

`static let appleWalkingSteadiness: HKQuantityTypeIdentifier`

A quantity sample type that measures the steadiness of the user’s gait.

`static let appleWalkingSteadinessEvent: HKCategoryTypeIdentifier`

A category sample type that records an incident where the user showed a reduced score for their gait’s steadiness.

`static let sixMinuteWalkTestDistance: HKQuantityTypeIdentifier`

A quantity sample type that stores the distance a user can walk during a six-minute walk test.

`static let walkingSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s average speed when walking steadily over flat ground.

`static let walkingStepLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the average length of the user’s step when walking steadily over flat ground.

`static let walkingAsymmetryPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the percentage of steps in which one foot moves at a different speed than the other when walking on flat ground.

`static let walkingDoubleSupportPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the percentage of time when both of the user’s feet touch the ground while walking steadily over flat ground.

`static let stairAscentSpeed: HKQuantityTypeIdentifier`

A quantity sample type measuring the user’s speed while climbing a flight of stairs.

`static let stairDescentSpeed: HKQuantityTypeIdentifier`

A quantity sample type measuring the user’s speed while descending a flight of stairs.

### Symptoms

Identifiers for medical symptoms.

### Lab and test results

`static let bloodGlucose: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s blood glucose level.

`static let electrodermalActivity: HKQuantityTypeIdentifier`

A quantity sample type that measures electrodermal activity.

`static let forcedExpiratoryVolume1: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of air that can be forcibly exhaled from the lungs during the first second of a forced exhalation.

`static let forcedVitalCapacity: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of air that can be forcibly exhaled from the lungs after taking the deepest breath possible.

`static let inhalerUsage: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of puffs the user takes from their inhaler.

`static let insulinDelivery: HKQuantityTypeIdentifier`

A quantity sample that measures the amount of insulin delivered.

`static let numberOfTimesFallen: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of times the user fell.

`static let peakExpiratoryFlowRate: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s maximum flow rate generated during a forceful exhalation.

`static let peripheralPerfusionIndex: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s peripheral perfusion index.

### Mindfulness and sleep

`static let mindfulSession: HKCategoryTypeIdentifier`

A category sample type for recording a mindful session.

`static let sleepAnalysis: HKCategoryTypeIdentifier`

A category sample type for sleep analysis information.

`static let appleSleepingWristTemperature: HKQuantityTypeIdentifier`

A quantity sample type that records the wrist temperature during sleep.

`enum HKAppleSleepingBreathingDisturbancesClassification`

### Self care

`static let toothbrushingEvent: HKCategoryTypeIdentifier`

A category sample type for toothbrushing events.

`static let handwashingEvent: HKCategoryTypeIdentifier`

A category sample type for handwashing events.

### Workouts

`let HKWorkoutTypeIdentifier: String`

The workout type identifier.

`let HKWorkoutRouteTypeIdentifier: String`

A series sample containing location data that defines the route the user took during a workout.

### Clinical records

`struct HKClinicalTypeIdentifier`

A type identifier for the different categories of clinical records.

### UV exposure

`static let uvExposure: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s exposure to UV radiation.

### Vision

`let HKVisionPrescriptionTypeIdentifier: String`

A type identifier for vision prescription samples.

### Diving

`static let underwaterDepth: HKQuantityTypeIdentifier`

A quantity sample that records a person’s depth underwater.

`static let waterTemperature: HKQuantityTypeIdentifier`

A quantity sample that records the water temperature.

### Utilities

`struct BufferedAsyncByteIterator`

An asynchronous iterator for byte data.

## See Also

### Health data

Saving data to HealthKit

Create and share HealthKit samples.

Reading data from HealthKit

Use queries to request sample data from HealthKit.

`class HKHealthStore`

The access point for all data managed by HealthKit.

Creating a Mobility Health App

Create a health app that allows a clinical care team to send and receive mobility data.

Create and save health and fitness samples.

Query health and fitness data.

Visualizing HealthKit State of Mind in visionOS

Incorporate HealthKit State of Mind into your app and visualize the data in visionOS.

Logging symptoms associated with a medication

Fetch medications and dose events from the HealthKit store, and create symptom samples to associate with them.

---

# https://developer.apple.com/documentation/healthkit/samples

Collection

- HealthKit
- Samples

API Collection

# Samples

Create and save health and fitness samples.

## Overview

The HealthKit store saves most health and fitness data using `HKSample` subclasses. All sample subclasses record information at a specified time. If the sample’s `startDate` and `endDate` properties are the same, the sample represents a point in time. If the `endDate` is after the `startDate`, the sample represents a time interval.

HealthKit uses different `HKSample` subclasses to store different types of data:

- `HKQuantitySample` objects store quantities—a numerical value and units. Most HealthKit data types use quantity samples. For example, height, heart rate, and dietary energy consumed all use quantity samples.

- `HKCategorySample` objects store a single option selected from a short list. For example, category samples record sleep data (the user can be in bed, asleep, or awake).

- `HKCorrelation` samples combine two or more samples into a single value. For example, correlation samples represent food intake and blood pressure samples. A food sample contains any number of nutrition samples, while a blood pressure sample contains both a systolic and a diastolic sample.

- HealthKit represents specialized data types with sample subclasses such as `HKCDADocumentSample`, `HKWorkoutRoute`, and `HKWorkout`.

## Topics

### Essentials

Saving data to HealthKit

Create and share HealthKit samples.

Reading and Writing HealthKit Series Data

Share and read heartbeat and quantity series data using series builders and queries.

### Basic samples

`class HKCumulativeQuantitySample`

A sample that represents a cumulative quantity.

`class HKDiscreteQuantitySample`

A sample that represents a discrete quantity.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKCategorySample`

A sample with values from a short list of possible values.

`class HKCorrelation`

A sample that groups multiple related samples into a single entry.

Objects used to specify a quantity for a given unit, and to convert between units.

Constants used to add metadata to objects stored in HealthKit.

### Series data

`class HKQuantitySeriesSampleBuilder`

A builder object for incrementally building a sample that contains multiple quantities.

`class HKHeartbeatSeriesBuilder`

A builder object for incrementally building a heartbeat series.

`class HKHeartbeatSeriesSample`

A sample that represents a series of heartbeats.

### Electrocardiograms

`class HKElectrocardiogram`

A sample for electrocardiogram data.

`class VoltageMeasurement`

The voltage for all leads at a single point in time.

### Audiograms

`class HKAudiogramSample`

A sample that stores an audiogram.

`class HKAudiogramSensitivityPoint`

A hearing sensitivity reading associated with a hearing test.

### Medical records

Accessing Health Records

Read clinical record data from the HealthKit store.

Accessing Sample Data in the Simulator

Set up sample accounts to build and test your app.

Accessing a User’s Clinical Records

Request authorization to query HealthKit for a user’s clinical records and display them in your app.

Accessing Data from a SMART Health Card

Query for and validate a verifiable clinical record.

`class HKClinicalRecord`

A sample that stores a clinical record.

`class HKFHIRResource`

An object containing Fast Healthcare Interoperability Resources (FHIR) data.

`class HKVerifiableClinicalRecord`

A sample that represents the contents of a SMART Health Card or EU Digital COVID Certificate.

`class HKVerifiableClinicalRecordSubject`

The subject associated with a signed clinical record.

`class HKCDADocumentSample`

A Clinical Document Architecture (CDA) sample that stores a single document.

`class HKDocumentSample`

An abstract class that represents a health document in the HealthKit store.

`static let CDA: HKDocumentTypeIdentifier`

The CDA Document type identifier, used when requesting permission to read or share CDA documents.

`class HKDocumentType`

A sample type used to create queries for documents.

### Vision prescriptions

`class HKVisionPrescription`

A sample that stores a vision prescription.

`class HKGlassesPrescription`

A sample that stores a prescription for glasses.

`class HKContactsPrescription`

A sample that store a prescription for contacts.

`class HKGlassesLensSpecification`

An object that contains the glasses prescription data for one eye.

`class HKContactsLensSpecification`

An object that contains the contacts prescription data for one eye.

`class HKLensSpecification`

An abstract superclass for lens specifications.

`class HKVisionPrism`

Prescription data for eye alignment.

`class HKPrescriptionType`

A type that identifies samples that store a prescription.

### Walking steadiness classifications

`enum HKAppleWalkingSteadinessClassification`

A classification of a score based on the steadiness of the user’s gait.

### Attachments

`class HKAttachment`

A file that is attached to a sample in the HealthKit store.

`class HKAttachmentStore`

The access point for attachments associated with samples in the HealthKit store.

`class HKAttachmentDataReader`

A reader that provides access to an attachment’s data.

### Digital signatures

Adding Digital Signatures

Cryptographically sign samples.

### Abstract superclasses

`class HKSample`

A HealthKit sample represents a piece of data associated with a start and end time.

`class HKObject`

A piece of data that can be stored inside the HealthKit store.

### Deprecated classes

`class HKCumulativeQuantitySeriesSample`

A sample representing a series of cumulative quantity values.

Deprecated

## See Also

### Health data

Reading data from HealthKit

Use queries to request sample data from HealthKit.

`class HKHealthStore`

The access point for all data managed by HealthKit.

Creating a Mobility Health App

Create a health app that allows a clinical care team to send and receive mobility data.

Specify the kind of data used in HealthKit.

Query health and fitness data.

Visualizing HealthKit State of Mind in visionOS

Incorporate HealthKit State of Mind into your app and visualize the data in visionOS.

Logging symptoms associated with a medication

Fetch medications and dose events from the HealthKit store, and create symptom samples to associate with them.

---

# https://developer.apple.com/documentation/healthkit/queries

Collection

- HealthKit
- Queries

API Collection

# Queries

Query health and fitness data.

## Overview

Use queries to read sample data from the HealthKit store. You can also use queries to list all the sources for a particular data type, or to perform statistical calculations for a data type. For example, statistical queries can calculate the minimum and maximum heart rate for a given week, or the total step count for a given day.

You run a query by calling the HealthKit store’s `execute(_:)` method. HealthKit returns a snapshot of the current results to the query’s results handler. Long-running queries continue to monitor the HealthKit store, and return any relevant changes to the query’s update handler. To return sorted or filtered results, give the query a sort descriptor or predicate.

## Topics

### Essentials

Reading data from HealthKit

Use queries to request sample data from HealthKit.

### Swift concurrency support

Running Queries with Swift Concurrency

Use Swift concurrency to manage one-shot and long-running queries.

`protocol HKAsyncQuery`

A protocol that defines an asynchronous method for running queries.

`protocol HKAsyncSequenceQuery`

A protocol that defines a method for running queries that returns results using an asynchronous sequence.

`struct HKSamplePredicate`

A predicate for queries that return a collection of matching sample objects.

### Basic queries

`struct HKSampleQueryDescriptor`

A query interface that reads samples using Swift concurrency.

`class HKSampleQuery`

A general query that returns a snapshot of all the matching samples currently saved in the HealthKit store.

`class HKCorrelationQuery`

A query that performs complex searches based on the correlation’s contents, and returns a snapshot of all matching samples.

`class HKQueryDescriptor`

A descriptor that specifies a set of samples based on the data type and a predicate.

`class HKQuery`

An abstract class for all the query classes in HealthKit.

### Series queries

`struct HKQuantitySeriesSampleQueryDescriptor`

A query interface that reads the series data associated with quantity samples using Swift concurrency.

`class HKQuantitySeriesSampleQuery`

A query that accesses the series data associated with a quantity sample.

`struct HKWorkoutRouteQueryDescriptor`

A query interface that reads the location data stored in a workout route using Swift concurrency.

`class HKWorkoutRouteQuery`

A query to access the location data stored in a workout route.

`struct HKHeartbeatSeriesQueryDescriptor`

A query interface that reads the heartbeat series data stored in a heartbeat sample using Swift concurrency.

`class HKHeartbeatSeriesQuery`

A query that returns the heartbeat data contained in a heartbeat series sample.

`struct HKElectrocardiogramQueryDescriptor`

A query interface that reads the underlying voltage measurements for an electrocardiogram sample using Swift concurrency.

`class HKElectrocardiogramQuery`

A query that returns the underlying voltage measurements for an electrocardiogram sample.

`class HKWorkoutEffortRelationship`

`class HKWorkoutEffortRelationshipQuery`

### Long-running queries

`struct HKActivitySummaryQueryDescriptor`

A query interface that reads activity summaries using Swift concurrency.

`class HKActivitySummaryQuery`

A query for reading activity summary objects from the HealthKit store.

`struct HKAnchoredObjectQueryDescriptor`

A query interface that runs anchored object queries using Swift concurrency.

`class HKAnchoredObjectQuery`

A query that returns changes to the HealthKit store, including a snapshot of new changes and continuous monitoring as a long-running query.

`class HKObserverQuery`

A long-running query that monitors the HealthKit store and updates your app when the HealthKit store saves or deletes a matching sample.

### Sources and devices

`struct HKSourceQueryDescriptor`

A query interface that uses Swift concurrency to read the apps and devices that produced the matching samples.

`class HKSourceRevision`

An object indicating the source of a HealthKit sample.

`class HKSource`

An object indicating the app or device that created a HealthKit sample

`class HKDevice`

A device that generates data for HealthKit.

`class HKSourceQuery`

A query that returns a list of sources, such as apps and devices, that have saved matching queries to the HealthKit store.

### Statistics

Executing Statistical Queries

Create and run statistical queries.

Executing Statistics Collection Queries

Calculate statistical data for graphs and charts.

`struct HKStatisticsQueryDescriptor`

A query descriptor that calculates the minimum, maximum, average, or sum over a set of samples from the HealthKit store.

`class HKStatisticsQuery`

A query that performs statistical calculations over a set of matching quantity samples, and returns the results.

`struct HKStatisticsCollectionQueryDescriptor`

A query descriptor that gathers a collection of statistics calculated over a series of fixed-length time intervals.

`class HKStatisticsCollectionQuery`

A query that performs multiple statistics queries over a series of fixed-length time intervals.

`class HKStatistics`

An object that represents the result of calculating the minimum, maximum, average, or sum over a set of samples from the HealthKit store.

`class HKStatisticsCollection`

An object that manages a collection of statistics, representing the results calculated over separate time intervals.

`struct HKStatisticsOptions`

Options for specifying the statistic to calculate.

### Clinical record queries

`struct HKVerifiableClinicalRecordQueryDescriptor`

A query interface that provides one-time access to a SMART Health Card or EU Digital COVID Certificate using Swift concurrency.

`class HKVerifiableClinicalRecordQuery`

A query for one-time access to a SMART Health Card or EU Digital COVID Certificate.

`struct HKVerifiableClinicalRecordSourceType`

The source type for the verifiable clinical record.

`struct HKVerifiableClinicalRecordCredentialType`

The type of record returned by a verifiable clinical record query.

`class HKDocumentQuery`

A query that returns a snapshot of all matching documents currently saved in the HealthKit store.

### Medication queries

`class HKClinicalCoding`

A clinical coding that represents a medical concept using a standardized coding system.

`class HKHealthConceptIdentifier`

A unique identifier for a specific health concept within a domain.

`class HKMedicationConcept`

An object that describes a specific medication concept.

`class HKMedicationDoseEvent`

`class HKMedicationDoseEventType`

`class HKUserAnnotatedMedication`

A reference to the tracked medication and the details a person can customize.

`class HKUserAnnotatedMedicationQuery`

`class HKUserAnnotatedMedicationType`

`struct HKHealthConceptDomain`

A domain that represents a health concept.

`struct HKMedicationGeneralForm`

The manufactured form of a medication.

`struct HKUserAnnotatedMedicationQueryDescriptor`

## See Also

### Health data

Saving data to HealthKit

Create and share HealthKit samples.

`class HKHealthStore`

The access point for all data managed by HealthKit.

Creating a Mobility Health App

Create a health app that allows a clinical care team to send and receive mobility data.

Specify the kind of data used in HealthKit.

Create and save health and fitness samples.

Visualizing HealthKit State of Mind in visionOS

Incorporate HealthKit State of Mind into your app and visualize the data in visionOS.

Logging symptoms associated with a medication

Fetch medications and dose events from the HealthKit store, and create symptom samples to associate with them.

---

# https://developer.apple.com/documentation/healthkit/visualizing-healthkit-state-of-mind-in-visionos

- HealthKit
- Visualizing HealthKit State of Mind in visionOS

Sample Code

# Visualizing HealthKit State of Mind in visionOS

Incorporate HealthKit State of Mind into your app and visualize the data in visionOS.

Download

Xcode 16.1+

## Overview

### Configure the sample code project

Before you run the sample code project:

1. Open the sample with the latest version of Xcode.

2. Set the developer team for the project target to let Xcode automatically manage the provisioning profile. For more information, see Assign a project to a team.

## See Also

### Health data

Saving data to HealthKit

Create and share HealthKit samples.

Reading data from HealthKit

Use queries to request sample data from HealthKit.

`class HKHealthStore`

The access point for all data managed by HealthKit.

Creating a Mobility Health App

Create a health app that allows a clinical care team to send and receive mobility data.

Specify the kind of data used in HealthKit.

Create and save health and fitness samples.

Query health and fitness data.

Logging symptoms associated with a medication

Fetch medications and dose events from the HealthKit store, and create symptom samples to associate with them.

---

# https://developer.apple.com/documentation/healthkit/logging-symptoms-associated-with-a-medication

- HealthKit
- Logging symptoms associated with a medication

Sample Code

# Logging symptoms associated with a medication

Fetch medications and dose events from the HealthKit store, and create symptom samples to associate with them.

Download

Xcode 26.0+

## Overview

### Configure the sample code project

Before you run the sample code project:

1. Open the sample with the latest version of Xcode.

2. Set the developer team for the project target to let Xcode automatically manage the provisioning profile. For more information, see Set the bundle ID and Assign the project to a team.

To play with the sample app:

1. Launch the Health app on your iPhone, select the Browse tab, and tap Medications.

2. In the Medications view, add Acetaminophen 500 mg Oral Capsule, Carbinoxamine Maleate Biphasic Release Oral Capsule (10 mg), or Ciprofloxacin Injection 200 mg/20 mL as a sample medication. The sample app associates symptoms with these three medications using their RxNorm codes by mapping the codes to their symptoms in the `SideEffects` dictionary in `SideEffects.swift`.

3. For each medication, log a dose as _taken_ in the As Needed Medications section. The sample app forms a predicate to only look for doses marked as `taken`.

4. Build and run the sample app on the iPhone to see the medication list after providing authorization. Tap a medication to see the most-recent dose event and associated symptoms. When tapping a medication, an additional authorization sheet prompts for authorization to access symptoms data.

5. To add more medications in the Health app and view them in the sample app, add their RxNorm codes to the `SideEffects` dictionary, along with their associated symptoms. For instance, for piroxicam, the RxNorm code is 105929, and the symptoms can be headache, loss of appetite, and nausea. To view the symptoms, modify `SideEffects` by adding the following code:

"105929": [SymptomModel(name: "Headache", categoryID: .headache),\
SymptomModel(name: "Diarrhea", categoryID: .diarrhea),\
SymptomModel(name: "Nausea", categoryID: .nausea)]

6. Log doses for medications over time, and observe them in the Charts tab of the sample app.

## See Also

### Health data

Saving data to HealthKit

Create and share HealthKit samples.

Reading data from HealthKit

Use queries to request sample data from HealthKit.

`class HKHealthStore`

The access point for all data managed by HealthKit.

Creating a Mobility Health App

Create a health app that allows a clinical care team to send and receive mobility data.

Specify the kind of data used in HealthKit.

Create and save health and fitness samples.

Query health and fitness data.

Visualizing HealthKit State of Mind in visionOS

Incorporate HealthKit State of Mind into your app and visualize the data in visionOS.

---

# https://developer.apple.com/documentation/healthkit/workouts-and-activity-rings

Collection

- HealthKit
- Workouts and activity rings

API Collection

# Workouts and activity rings

Manage workouts, workout sessions, and activity summaries.

## Overview

A workout is a sample that contains data about an exercise or fitness activity. You save workout data using the `HKWorkout` class. In many ways, workouts are identical to any other HealthKit sample—the same advice and APIs apply to both workouts and samples. However, workouts do have a number of unique features, described in `HKWorkout`.

Workout sessions let you track the user’s activity on Apple Watch. While a workout session is active, your app can continue to run in the background. This lets your app monitor the user and gather data throughout the activity. Additionally, it ensures that your app appears whenever the user checks their watch. After the session ends, your app saves the activity’s data as a workout sample. For more information on setting up and running workout sessions, see `HKWorkoutSession`.

The Activity Rings display a summary of the user’s daily activity on Apple Watch and in the Activity app. Activity summaries provide access to the data displayed in the user’s Move, Exercise, and Stand rings. To see how your workout samples contribute to these rings, see Fill the Activity rings. To learn more about accessing and displaying activity data in your app, see Activity rings.

Finally, workout routes record the user’s path during an outdoor activity (for example, while walking, running, or cycling). Routes can be associated with a workout sample. For more information, see Creating a workout route and Reading route data.

## Topics

### Samples

Adding samples to a workout

Create associated samples that add details to a workout.

Accessing condensed workout samples

Read series data from condensed workouts.

Dividing a HealthKit workout into activities

Partition multisport and interval workouts into activities that represent the different parts of the workout.

`class HKWorkout`

A workout sample that stores information about a single physical activity.

`class HKWorkoutActivity`

An object that describes an activity within a longer workout.

`class HKWorkoutBuilder`

A builder object that incrementally constructs a workout.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`let HKWorkoutTypeIdentifier: String`

The workout type identifier.

`enum HKWorkoutActivityType`

The type of activity performed during a workout.

`enum HKWorkoutSessionType`

The type of session.

`class HKWorkoutEvent`

An object representing an important event during a workout.

### Sessions

Running workout sessions

Track a workout on Apple Watch.

Build a workout app for Apple Watch

Create your own workout app, quickly and easily, with HealthKit and SwiftUI.

Building a multidevice workout app

Mirror a workout from a watchOS app to its companion iOS app, and perform bidirectional communication between them.

Building a workout app for iPhone and iPad

Start a workout in iOS, control it from the Lock Screen with App Intents, and present the workout status with Live Activities.

`class HKWorkoutSession`

A session that tracks a person’s workout.

`class HKWorkoutConfiguration`

An object that contains configuration information about a workout session.

`enum HKWorkoutSessionState`

A workout session’s state.

`class HKLiveWorkoutBuilder`

A builder object that constructs a workout incrementally based on live data from an active workout session.

`class HKLiveWorkoutDataSource`

A data source that automatically provides live data from an active workout session.

### Activity rings

`class HKActivitySummary`

An object that contains the move, exercise, and stand data for a given day.

`struct HKActivitySummaryQueryDescriptor`

A query interface that reads activity summaries using Swift concurrency.

`class HKActivitySummaryQuery`

A query for reading activity summary objects from the HealthKit store.

`class HKActivityRingView`

A view that uses the Move, Exercise, and Stand activity rings to display data from a HealthKit activity summary object.

`class HKActivityMoveModeObject`

An object that contains a movement mode value.

### Route data

Creating a workout route

Record the user’s route during a workout.

Reading route data

Access the user’s route for a workout.

`class HKWorkoutRouteBuilder`

A builder object that incrementally constructs a workout route.

`class HKWorkoutRoute`

A sample that contains a workout’s route data.

`struct HKWorkoutRouteQueryDescriptor`

A query interface that reads the location data stored in a workout route using Swift concurrency.

`class HKWorkoutRouteQuery`

A query to access the location data stored in a workout route.

`let HKWorkoutRouteTypeIdentifier: String`

A series sample containing location data that defines the route the user took during a workout.

`class HKSeriesBuilder`

An abstract base class for building series samples.

`class HKSeriesSample`

An abstract base class that defines samples that contain a series of items.

---

# https://developer.apple.com/documentation/healthkit/hkerror

- HealthKit
- HKError

Structure

# HKError

An error returned from a HealthKit method.

struct HKError

## Topics

### Accessing errors

`enum Code`

Error codes returned by HealthKit.

`static var noError: HKError.Code`

No error occurred.

`static var errorHealthDataUnavailable: HKError.Code`

The user accessed HealthKit on an unsupported device.

`static var errorHealthDataRestricted: HKError.Code`

A Mobile Device Management (MDM) profile restricts the use of HealthKit on this device.

`static var errorInvalidArgument: HKError.Code`

The app passed an invalid argument to the HealthKit API.

`static var errorAuthorizationDenied: HKError.Code`

The user hasn’t given the app permission to save data.

`static var errorAuthorizationNotDetermined: HKError.Code`

The app hasn’t yet asked the user for the authorization required to complete the task.

`static var errorRequiredAuthorizationDenied: HKError.Code`

The user hasn’t granted the application authorization to access all the required clinical record types.

`static var errorDatabaseInaccessible: HKError.Code`

The HealthKit data is unavailable because it’s protected and the device is locked.

`static var errorUserCanceled: HKError.Code`

The user canceled the operation.

`static var errorAnotherWorkoutSessionStarted: HKError.Code`

Another app started a workout session.

`static var errorUserExitedWorkoutSession: HKError.Code`

The user exited your application while a workout session was running.

`static var errorNoData: HKError.Code`

Data is unavailable for the requested query and predicate.

### Type Properties

`static var errorBackgroundWorkoutSessionNotAllowed: HKError.Code`

`static var errorDataSizeExceeded: HKError.Code`

`static var errorDomain: String`

`static var errorNotPermissibleForGuestUserMode: HKError.Code`

The app attempted to write HealthKit data while in a Guest User session in visionOS.

`static var errorWorkoutActivityNotAllowed: HKError.Code`

`static var unknownError: HKError.Code`

## Relationships

### Conforms To

- `CustomNSError`
- `Equatable`
- `Error`
- `Hashable`
- `Sendable`
- `SendableMetatype`

## See Also

### Errors

`let HKErrorDomain: String`

The domain for all HealthKit errors.

---

# https://developer.apple.com/documentation/healthkit/hkerrordomain

- HealthKit
- HKErrorDomain

Global Variable

# HKErrorDomain

The domain for all HealthKit errors.

let HKErrorDomain: String

## See Also

### Errors

`struct HKError`

An error returned from a HealthKit method.

`enum Code`

Error codes returned by HealthKit.

---

# https://developer.apple.com/documentation/healthkit/hkerror/code

- HealthKit
- HKError
- HKError.Code

Enumeration

# HKError.Code

Error codes returned by HealthKit.

enum Code

## Mentioned in

Executing Statistics Collection Queries

## Topics

### Errors

`case errorHealthDataUnavailable`

HealthKit accessed on an unsupported device, such as an iPad.

`case errorHealthDataRestricted`

A Mobile Device Management (MDM) profile restricts the use of HealthKit on this device.

`case errorInvalidArgument`

The app passed an invalid argument to the HealthKit API.

`case errorAuthorizationDenied`

The user hasn’t given the app permission to save data.

`case errorAuthorizationNotDetermined`

The app hasn’t yet asked the user for the authorization required to complete the task.

`case errorRequiredAuthorizationDenied`

The user hasn’t granted the application authorization to access all the required clinical record types.

`case errorDatabaseInaccessible`

The HealthKit data is unavailable because it’s protected and the device is locked.

`case errorUserCanceled`

The user canceled the operation.

`case errorAnotherWorkoutSessionStarted`

Another app started a workout session.

`case errorUserExitedWorkoutSession`

The user exited your application while a workout session was running.

`case errorNoData`

Data is unavailable for the requested query and predicate.

### Enumeration Cases

`case errorBackgroundWorkoutSessionNotAllowed`

`case errorDataSizeExceeded`

`case errorNotPermissibleForGuestUserMode`

The app attempted to write HealthKit data while in a Guest User session in visionOS.

`case errorWorkoutActivityNotAllowed`

`case unknownError`

### Initializers

`init?(rawValue: Int)`

### Type Properties

`static var noError: HKError.Code`

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `Hashable`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`

## See Also

### Errors

`struct HKError`

An error returned from a HealthKit method.

`let HKErrorDomain: String`

The domain for all HealthKit errors.

---

# https://developer.apple.com/documentation/healthkit/healthkit-enumerations

Collection

- HealthKit
- HealthKit Enumerations

API Collection

# HealthKit Enumerations

## Topics

### Enumerations

`enum HKAudiogramConductionType`

`enum HKAudiogramSensitivityTestSide`

`enum HKCategoryValueVaginalBleeding`

`enum Answer`

`enum Risk`

`enum Association`

`enum Kind`

`enum Label`

`enum ValenceClassification`

`enum HKWorkoutEffortRelationshipQueryOptions`

`enum HKBiologicalSex`

Constants indicating the user’s sex.

`enum HKBloodType`

Constants indicating the user’s blood type.

`enum HKFitzpatrickSkinType`

Categories representing the user’s skin type based on the Fitzpatrick scale.

`enum HKWheelchairUse`

Constants indicating the user’s wheelchair use.

## See Also

---

# https://developer.apple.com/documentation/healthkit/healthkit-classes

Collection

- HealthKit
- HealthKit Classes

API Collection

# HealthKit Classes

## Topics

### Classes

`class HKAudiogramSensitivityPointClampingRange`

Defines the range within which an ear’s sensitivity point may have been clamped, if any.

`class HKAudiogramSensitivityTest`

`class HKBiologicalSexObject`

This class acts as a wrapper for the `HKBiologicalSex` enumeration.

`class HKBloodTypeObject`

This class acts as a wrapper for the `HKBloodType` enumeration.

`class HKFitzpatrickSkinTypeObject`

This class acts as a wrapper for the `HKFitzpatrickSkinType` enumeration.

`class HKGAD7Assessment`

`class HKPHQ9Assessment`

`class HKScoredAssessment`

`class HKScoredAssessmentType`

`class HKStateOfMind`

`class HKStateOfMindType`

`class HKWheelchairUseObject`

This class acts as a wrapper for the wheelchair use enumeration.

## See Also

---

# https://developer.apple.com/documentation/healthkit/healthkit-constants

Collection

- HealthKit
- HealthKit Constants

API Collection

# HealthKit Constants

## Topics

### Constants

`let HKDataTypeIdentifierStateOfMind: String`

`let HKMetadataKeyAppleFitnessPlusCatalogIdentifier: String`

`let HKMetadataKeyMaximumLightIntensity: String`

A key that indicates the maximum intensity of light for an outdoor time sample.

`let HKPredicateKeyPathWorkoutEffortRelationship: String`

## See Also

---

# https://developer.apple.com/documentation/healthkit/healthkit-data-types

Collection

- HealthKit
- HealthKit Data Types

API Collection

# HealthKit Data Types

## Topics

### Data Types

`struct HKScoredAssessmentTypeIdentifier`

`struct HKWorkoutEffortRelationshipQueryDescriptor`

## See Also

---

# https://developer.apple.com/documentation/healthkit/healthkit-functions

Collection

- HealthKit
- HealthKit Functions

API Collection

# HealthKit Functions

## See Also

---

# https://developer.apple.com/documentation/healthkit/healthkit-macros

Collection

- HealthKit
- Macros

API Collection

# Macros

## Topics

### Macros

`var HKAnchoredObjectQueryNoAnchor: Int32`

An anchor that returns all of the matching samples currently in the HealthKit store.

## See Also

---

# https://developer.apple.com/documentation/healthkit/healthkit-variables

Collection

- HealthKit
- HealthKit Variables

API Collection

# HealthKit Variables

## Topics

### Variables

`static let bleedingAfterPregnancy: HKCategoryTypeIdentifier`

A category type that records bleeding after pregnancy as a symptom.

`static let bleedingDuringPregnancy: HKCategoryTypeIdentifier`

A category type that records bleeding during pregnancy as a symptom.

`static let sleepApneaEvent: HKCategoryTypeIdentifier`

`let HKDevicePropertyKeyFirmwareVersion: String`

The device’s firmware version.

`let HKDevicePropertyKeyHardwareVersion: String`

The device’s hardware version.

`let HKDevicePropertyKeyLocalIdentifier: String`

A unique identifier for the device on the hardware running the app. For more information, see `localIdentifier`.

`let HKDevicePropertyKeyManufacturer: String`

The device’s manufacturer.

`let HKDevicePropertyKeyModel: String`

The device’s model.

`let HKDevicePropertyKeyName: String`

The device’s name.

`let HKDevicePropertyKeySoftwareVersion: String`

The device’s software version.

`let HKDevicePropertyKeyUDIDeviceIdentifier: String`

The device’s UDI Device Identifier.

`let HKPredicateKeyPathCount: String`

A key path for the sample’s count.

`static let GAD7: HKScoredAssessmentTypeIdentifier`

`static let PHQ9: HKScoredAssessmentTypeIdentifier`

`let HKSourceRevisionAnyOperatingSystem: OperatingSystemVersion`

A constant that matches any operating system.

`let HKSourceRevisionAnyProductType: String`

A constant that matches any product type.

`let HKSourceRevisionAnyVersion: String`

A constant that matches any version.

`let HKDataTypeIdentifierUserAnnotatedMedicationConcept: String`

`let HKMedicationDoseEventTypeIdentifierMedicationDoseEvent: String`

`let HKPredicateKeyPathLogOrigin: String`

The key path you use to create predicates that query by the dose event’s medication log origin.

`let HKPredicateKeyPathMedicationConceptIdentifier: String`

The key path you use to create predicates that query by the dose event’s medication concept identifier.

`let HKPredicateKeyPathScheduledDate: String`

The key path you use to create predicates that query by the dose event’s scheduled date.

`let HKPredicateKeyPathStatus: String`

The key path you use to create predicates that query by a dose event’s log status.

`let HKUserAnnotatedMedicationPredicateKeyPathHasSchedule: String`

The key path you use to create predicates for whether or not a medication has a schedule.

`let HKUserAnnotatedMedicationPredicateKeyPathIsArchived: String`

The key path you use to create predicates for the medication’s archived status.

## See Also

---

# https://developer.apple.com/documentation/healthkit/about-the-healthkit-framework)



---

# https://developer.apple.com/documentation/healthkit/setting-up-healthkit)



---

# https://developer.apple.com/documentation/healthkit/authorizing-access-to-health-data)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/protecting-user-privacy)



---

# https://developer.apple.com/documentation/healthkit/saving-data-to-healthkit)



---

# https://developer.apple.com/documentation/healthkit/reading-data-from-healthkit)



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore)



---

# https://developer.apple.com/documentation/healthkit/creating-a-mobility-health-app)



---

# https://developer.apple.com/documentation/healthkit/data-types)



---

# https://developer.apple.com/documentation/healthkit/samples)



---

# https://developer.apple.com/documentation/healthkit/queries)



---

# https://developer.apple.com/documentation/healthkit/visualizing-healthkit-state-of-mind-in-visionos)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/logging-symptoms-associated-with-a-medication)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/workouts-and-activity-rings)



---

# https://developer.apple.com/documentation/healthkit/hkerror)



---

# https://developer.apple.com/documentation/healthkit/hkerrordomain)



---

# https://developer.apple.com/documentation/healthkit/hkerror/code)



---

# https://developer.apple.com/documentation/healthkit/healthkit-enumerations)



---

# https://developer.apple.com/documentation/healthkit/healthkit-classes)



---

# https://developer.apple.com/documentation/healthkit/healthkit-constants)



---

# https://developer.apple.com/documentation/healthkit/healthkit-data-types)



---

# https://developer.apple.com/documentation/healthkit/healthkit-functions)



---

# https://developer.apple.com/documentation/healthkit/healthkit-macros)



---

# https://developer.apple.com/documentation/healthkit/healthkit-variables)



---

# https://developer.apple.com/documentation/healthkit/executing-observer-queries

- HealthKit
- Queries
- HKObserverQuery
- Executing Observer Queries

Article

# Executing Observer Queries

Create and run observer queries.

## Overview

Observer queries are long-running queries that monitor the HealthKit store on a background thread, and update your app when the HealthKit store saves or deletes a matching sample. By default, observer queries only return results while your app is in the foreground; however, you can configure your app to also receive update notifications in the background.

### Create Observer Queries

To create an observer query, call the `init(sampleType:predicate:updateHandler:)` initializer. Start by creating a type object for the samples you want to observe. The following example creates a type object for step counts.

guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
// This should never fail when using a defined constant.
fatalError("*** Unable to get the step count type ***")
}

Next, create the observer query.

let query = HKObserverQuery(sampleType: stepCountType, predicate: nil) { (query, completionHandler, errorOrNil) in

if let error = errorOrNil {
// Properly handle the error.
return
}

// Take whatever steps are necessary to update your app.
// This often involves executing other queries to access the new data.

// If you have subscribed for background updates you must call the completion handler here.
// completionHandler()
}

After the query is instantiated, call the HealthKit store’s `execute(_:)` method.

store.execute(query)

This runs the query on an anonymous background queue. Whenever a matching sample is added to or deleted from the HealthKit store, the system calls the query’s update handler on the same background queue (but not necessarily the same thread).

To stop the query, call the HealthKit store’s `stop(_:)` method.

### Receive Background Deliveries

Apps can also register to receive updates while in the background by calling the HealthKit store’s `enableBackgroundDelivery(for:frequency:withCompletion:)` method. This method registers your app for background notifications. HealthKit wakes your app when the store receives new samples of the specified type. HealthKit notifies your app at most once per time period defined by the frequency you specified when registering.

As soon as your app launches, HealthKit calls the update handler for any observer queries that match the newly saved data. If you plan on supporting background delivery, set up all your observer queries in your app delegate’s `application(_:didFinishLaunchingWithOptions:)` method. By setting up the queries in `application(_:didFinishLaunchingWithOptions:)`, you ensure that the queries are instantiated and ready to use before HealthKit delivers the updates.

After your observer queries have finished processing the new data, you must call the update’s completion handler to notify HealthKit that you have successfully received the background delivery.

For more information on managing background deliveries, see Managing Background Deliveries in `HKHealthStore`. For more information on the background delivery completion handler, see `HKObserverQueryCompletionHandler`.

## See Also

### Creating Observer Queries

Instantiates and returns a query that monitors the HealthKit store and responds to changes.

Creates a query that monitors the HealthKit store and responds to any changes matching any of the query descriptors you provided.

`typealias HKObserverQueryCompletionHandler`

The completion handler for background deliveries.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/authorizationstatus(for:)

#app-main)

- HealthKit
- HKHealthStore
- authorizationStatus(for:)

Instance Method

# authorizationStatus(for:)

Returns the app’s authorization status for sharing the specified data type.

## Parameters

`type`

The type of data. This can be any concrete subclass of the `HKObjectType` class (any of the `HKCharacteristicType` , `HKQuantityType`, `HKCategoryType`, `HKWorkoutType` or `HKCorrelationType` classes).

## Return Value

A value indicating the app’s authorization status for this type. For a list of possible values, see `HKAuthorizationStatus`.

## Mentioned in

Authorizing access to health data

## Discussion

This method checks the authorization status for saving data to the HealthKit store.

To help prevent possible leaks of sensitive health information, your app cannot determine whether or not a user has granted permission to read data. If you are not given permission, it simply appears as if there is no data of the requested type in the HealthKit store. If your app is given share permission but not read permission, you see only the data that your app has written to the store. Data from other sources remains hidden.

## See Also

### Accessing HealthKit

`enum HKAuthorizationStatus`

Constants indicating the authorization status for a particular data type.

Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

`enum HKAuthorizationRequestStatus`

Values that indicate whether your app needs to request authorization from the user.

Returns a Boolean value that indicates whether HealthKit is available on this device.

Returns a Boolean value that indicates whether the current device supports clinical records.

Requests permission to save and read the specified data types.

Asynchronously requests permission to save and read the specified data types.

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

Requests permission to save and read the data types specified by an extension.

`var authorizationViewControllerPresenter: UIViewController?`

The view controller that presents HealthKit authorization sheets.

---

# https://developer.apple.com/documentation/healthkit/hkauthorizationstatus

- HealthKit
- HKAuthorizationStatus

Enumeration

# HKAuthorizationStatus

Constants indicating the authorization status for a particular data type.

enum HKAuthorizationStatus

## Overview

This status indicates whether the user has authorized your app to save data of the given type.

To help maintain the privacy of sensitive health data, HealthKit does not tell you when the user denies your app permission to query data. Instead, it simply appears as if HealthKit does not have any data matching your query. Your app will receive only the data that it has written to HealthKit. Data from other sources remains hidden from your app. For more information on privacy in HealthKit, see `HealthKit`.

## Topics

### Constants

`case notDetermined`

The user has not yet chosen to authorize access to the specified data type.

`case sharingDenied`

The user has explicitly denied your app permission to save data of the specified type.

`case sharingAuthorized`

The user has explicitly authorized your app to save data of the specified type.

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

### Accessing HealthKit

Returns the app’s authorization status for sharing the specified data type.

Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

`enum HKAuthorizationRequestStatus`

Values that indicate whether your app needs to request authorization from the user.

Returns a Boolean value that indicates whether HealthKit is available on this device.

Returns a Boolean value that indicates whether the current device supports clinical records.

Requests permission to save and read the specified data types.

Asynchronously requests permission to save and read the specified data types.

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

Requests permission to save and read the data types specified by an extension.

`var authorizationViewControllerPresenter: UIViewController?`

The view controller that presents HealthKit authorization sheets.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/getrequeststatusforauthorization(toshare:read:completion:)

#app-main)

- HealthKit
- HKHealthStore
- getRequestStatusForAuthorization(toShare:read:completion:)

Instance Method

# getRequestStatusForAuthorization(toShare:read:completion:)

Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

func getRequestStatusForAuthorization(

)
func statusForAuthorizationRequest(

## Discussion

When working with clinical types, users may need to reauthorize access when new data is added.

## See Also

### Accessing HealthKit

Returns the app’s authorization status for sharing the specified data type.

`enum HKAuthorizationStatus`

Constants indicating the authorization status for a particular data type.

`enum HKAuthorizationRequestStatus`

Values that indicate whether your app needs to request authorization from the user.

Returns a Boolean value that indicates whether HealthKit is available on this device.

Returns a Boolean value that indicates whether the current device supports clinical records.

Requests permission to save and read the specified data types.

Asynchronously requests permission to save and read the specified data types.

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

Requests permission to save and read the data types specified by an extension.

`var authorizationViewControllerPresenter: UIViewController?`

The view controller that presents HealthKit authorization sheets.

---

# https://developer.apple.com/documentation/healthkit/hkauthorizationrequeststatus

- HealthKit
- HKAuthorizationRequestStatus

Enumeration

# HKAuthorizationRequestStatus

Values that indicate whether your app needs to request authorization from the user.

enum HKAuthorizationRequestStatus

## Topics

### Statuses

`case unknown`

The authorization request status could not be determined because an error occurred.

`case shouldRequest`

The application has not yet requested authorization for all the specified data types.

`case unnecessary`

The application has already requested authorization for all the specified data types.

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

### Accessing HealthKit

Returns the app’s authorization status for sharing the specified data type.

`enum HKAuthorizationStatus`

Constants indicating the authorization status for a particular data type.

Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

Returns a Boolean value that indicates whether HealthKit is available on this device.

Returns a Boolean value that indicates whether the current device supports clinical records.

Requests permission to save and read the specified data types.

Asynchronously requests permission to save and read the specified data types.

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

Requests permission to save and read the data types specified by an extension.

`var authorizationViewControllerPresenter: UIViewController?`

The view controller that presents HealthKit authorization sheets.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/ishealthdataavailable()

#app-main)

- HealthKit
- HKHealthStore
- isHealthDataAvailable()

Type Method

# isHealthDataAvailable()

Returns a Boolean value that indicates whether HealthKit is available on this device.

## Return Value

`true` if HealthKit is available; otherwise, `false`.

## Mentioned in

About the HealthKit framework

Authorizing access to health data

## Discussion

By default, HealthKit data is available on iOS, watchOS, and visionOS. HealthKit data is also available to iPads running iPadOS 17 or later, and to iOS apps running on Vision Pro. Devices running in an enterprise environment may restrict access to HealthKit data.

The HealthKit framework is available on devices running iPadOS 16 and earlier and macOS 13 and later, but your app can’t read or write HealthKit data. Calls to `isHealthDataAvailable()` return `false`.

## See Also

### Accessing HealthKit

Returns the app’s authorization status for sharing the specified data type.

`enum HKAuthorizationStatus`

Constants indicating the authorization status for a particular data type.

Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

`enum HKAuthorizationRequestStatus`

Values that indicate whether your app needs to request authorization from the user.

Returns a Boolean value that indicates whether the current device supports clinical records.

Requests permission to save and read the specified data types.

Asynchronously requests permission to save and read the specified data types.

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

Requests permission to save and read the data types specified by an extension.

`var authorizationViewControllerPresenter: UIViewController?`

The view controller that presents HealthKit authorization sheets.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/supportshealthrecords()

#app-main)

- HealthKit
- HKHealthStore
- supportsHealthRecords()

Instance Method

# supportsHealthRecords()

Returns a Boolean value that indicates whether the current device supports clinical records.

## Discussion

This method returns `true` if the device is set to a locale where clinical records are supported, or if the user already has clinical records downloaded to their HealthKit store. Otherwise, it returns `false`.

This method lets users switch their locale without losing their health records.

## See Also

### Accessing HealthKit

Returns the app’s authorization status for sharing the specified data type.

`enum HKAuthorizationStatus`

Constants indicating the authorization status for a particular data type.

Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

`enum HKAuthorizationRequestStatus`

Values that indicate whether your app needs to request authorization from the user.

Returns a Boolean value that indicates whether HealthKit is available on this device.

Requests permission to save and read the specified data types.

Asynchronously requests permission to save and read the specified data types.

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

Requests permission to save and read the data types specified by an extension.

`var authorizationViewControllerPresenter: UIViewController?`

The view controller that presents HealthKit authorization sheets.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/requestauthorization(toshare:read:completion:)

#app-main)

- HealthKit
- HKHealthStore
- requestAuthorization(toShare:read:completion:)

Instance Method

# requestAuthorization(toShare:read:completion:)

Requests permission to save and read the specified data types.

func requestAuthorization(

)

## Parameters

`typesToShare`

A set containing the data types you want to share. This set can contain any concrete subclass of the `HKSampleType` class (any of the `HKQuantityType`, `HKCategoryType`, `HKWorkoutType`, or `HKCorrelationType` classes ). If the user grants permission, your app can create and save these data types to the HealthKit store.

`typesToRead`

A set containing the data types you want to read. This set can contain any concrete subclass of the `HKObjectType` class (any of the `HKCharacteristicType` , `HKQuantityType`, `HKCategoryType`, `HKWorkoutType`, or `HKCorrelationType` classes). If the user grants permission, your app can read these data types from the HealthKit store.

`completion`

A block called after the user finishes responding to the request. The system calls this block with the following parameters:

`success`

A Boolean value that indicates whether the request succeeded. This value doesn’t indicate whether the user actually granted permission. The parameter is `false` if an error occurred while processing the request; otherwise, it’s `true`.

`error`

An error object. If an error occurred, this object contains information about the error; otherwise, it’s set to `nil`.

## Discussion

HealthKit performs these requests asynchronously. If you call this method with a new data type (a type of data that the user hasn’t previously granted or denied permission for in this app), the system automatically displays the permission form, listing all the requested permissions. After the user has finished responding, this method calls its completion block on a background queue. If the user has already chosen to grant or prohibit access to all of the types specified, HealthKit calls the completion without prompting the user.

Each data type has two separate permissions, one to read it and one to share it. You can make a single request, and include all the data types your app needs.

Customize the messages displayed on the permissions sheet by setting the following keys:

- `NSHealthShareUsageDescription` customizes the message for reading data.

- `NSHealthUpdateUsageDescription` customizes the message for writing data.

For projects created using Xcode 13 or later, set these keys in the Target Properties list on the app’s Info tab. For projects created with Xcode 12 or earlier, set these keys in the apps `Info.plist` file. For more information, see `Information Property List`.

After users have set the permissions for your app, they can always change them using either the Settings or the Health app. Your app appears in the Health app’s Sources tab, even if the user didn’t allow permission to read or share data.

## See Also

### Accessing HealthKit

Returns the app’s authorization status for sharing the specified data type.

`enum HKAuthorizationStatus`

Constants indicating the authorization status for a particular data type.

Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

`enum HKAuthorizationRequestStatus`

Values that indicate whether your app needs to request authorization from the user.

Returns a Boolean value that indicates whether HealthKit is available on this device.

Returns a Boolean value that indicates whether the current device supports clinical records.

Asynchronously requests permission to save and read the specified data types.

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

Requests permission to save and read the data types specified by an extension.

`var authorizationViewControllerPresenter: UIViewController?`

The view controller that presents HealthKit authorization sheets.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/requestauthorization(toshare:read:)

#app-main)

- HealthKit
- HKHealthStore
- requestAuthorization(toShare:read:)

Instance Method

# requestAuthorization(toShare:read:)

Asynchronously requests permission to save and read the specified data types.

visionOS

func requestAuthorization(

## Parameters

`typesToShare`

A set containing the data types you want to share. This set can contain any concrete subclass of the `HKSampleType` class (any of the `HKQuantityType`, `HKCategoryType`, `HKWorkoutType`, or `HKCorrelationType` classes). If the user grants permission, your app can create and save these data types to the HealthKit store.

`typesToRead`

A set containing the data types you want to read. This set can contain any concrete subclass of the `HKObjectType` class (any of the `HKCharacteristicType` , `HKQuantityType`, `HKCategoryType`, `HKWorkoutType`, or `HKCorrelationType` classes ). If the user grants permission, your app can read these data types from the HealthKit store.

## Mentioned in

Authorizing access to health data

## Discussion

HealthKit performs these requests asynchronously. If you call this method with a new data type (a type of data that the user hasn’t previously granted or denied permission for in this app), the system automatically displays the permission form, listing all the requested permissions. If the user has already chosen to grant or prohibit access to all of the types specified, HealthKit returns the request without prompting the user.

Each data type has two separate permissions, one to read it and one to share it. You can make a single request, and include all the data types your app needs.

Customize the messages displayed on the permissions sheet by setting the following keys:

- `NSHealthShareUsageDescription` customizes the message for reading data.

- `NSHealthUpdateUsageDescription` customizes the message for writing data.

For projects created using Xcode 13 or later, set these keys in the Target Properties list on the app’s Info tab. For projects created with Xcode 12 or earlier, set these keys in the apps `Info.plist` file. For more information, see `Information Property List`.

After users have set the permissions for your app, they can always change them using either the Settings or the Health app. Your app appears in the Health app’s Sources tab, even if the user didn’t allow permission to read or share data.

## See Also

### Accessing HealthKit

Returns the app’s authorization status for sharing the specified data type.

`enum HKAuthorizationStatus`

Constants indicating the authorization status for a particular data type.

Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

`enum HKAuthorizationRequestStatus`

Values that indicate whether your app needs to request authorization from the user.

Returns a Boolean value that indicates whether HealthKit is available on this device.

Returns a Boolean value that indicates whether the current device supports clinical records.

Requests permission to save and read the specified data types.

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

Requests permission to save and read the data types specified by an extension.

`var authorizationViewControllerPresenter: UIViewController?`

The view controller that presents HealthKit authorization sheets.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/requestperobjectreadauthorization(for:predicate:completion:)

#app-main)

- HealthKit
- HKHealthStore
- requestPerObjectReadAuthorization(for:predicate:completion:)

Instance Method

# requestPerObjectReadAuthorization(for:predicate:completion:)

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

func requestPerObjectReadAuthorization(
for objectType: HKObjectType,
predicate: NSPredicate?,

)
func requestPerObjectReadAuthorization(
for objectType: HKObjectType,
predicate: NSPredicate?
) async throws

## Parameters

`objectType`

The data type you want to read.

`predicate`

A predicate that further restricts the data type.

`completion`

A completion handler that the system calls after the user responds to the request. The completion handler has the following parameters:

success

A Boolean value that indicates whether the request succeeded. This value doesn’t indicate whether the user actually granted permission. The parameter is `false` if an error occurred while processing the request; otherwise, it’s `true`.

error

An error object. If an error occurred, this object contains information about the error; otherwise, the system passes `nil`.

## Discussion

Some samples require per-object authorization. For these samples, people can select which ones your app can read on a sample-by-sample basis. By default, your app can read any of the per-object authorization samples that it has saved to the HealthKit store; however, you may not always have access to those samples. People can update the authorization status for any of these samples at any time.

Your app can begin by querying for any samples that it already has permission to read.

// Read the newest prescription from the HealthKit store.
let queryDescriptor = HKSampleQueryDescriptor(predicates: [.visionPrescription()],
sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)],
limit: 1)

let prescription: HKVisionPrescription

do {
guard let result = try await queryDescriptor.result(for: store).first else {
print("*** No prescription found. ***")
return
}

prescription = result
} catch {
// Handle the error here.
fatalError("*** An error occurred while reading the most recent vision prescriptions: \(error.localizedDescription) ***")
}

Based on the results, you can then decide whether you need to request authorization for additional samples. Call `requestPerObjectReadAuthorization(for:predicate:completion:)` to prompt someone to modify the samples your app has access to read.

// Request authorization to read vision prescriptions.
do {
try await store.requestPerObjectReadAuthorization(for: .visionPrescriptionType(),
predicate: nil)
} catch HKError.errorUserCanceled {
// Handle the user canceling the authorization request.
print("*** The user canceled the authorization request. ***")
return
} catch {
// Handle the error here.
fatalError("*** An error occurred while requesting permission to read vision prescriptions: \(error.localizedDescription) ***")
}

When your app calls this method, HealthKit displays an authorization sheet that asks for permission to read the samples that match the predicate and object type. The person using your app can then select individual samples to share with your app. The system always asks for permission, regardless of whether they previously granted it.

After the person responds, the system calls the callback handler on an arbitrary background queue.

## See Also

### Accessing HealthKit

Returns the app’s authorization status for sharing the specified data type.

`enum HKAuthorizationStatus`

Constants indicating the authorization status for a particular data type.

Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

`enum HKAuthorizationRequestStatus`

Values that indicate whether your app needs to request authorization from the user.

Returns a Boolean value that indicates whether HealthKit is available on this device.

Returns a Boolean value that indicates whether the current device supports clinical records.

Requests permission to save and read the specified data types.

Asynchronously requests permission to save and read the specified data types.

Requests permission to save and read the data types specified by an extension.

`var authorizationViewControllerPresenter: UIViewController?`

The view controller that presents HealthKit authorization sheets.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/handleauthorizationforextension(completion:)

#app-main)

- HealthKit
- HKHealthStore
- handleAuthorizationForExtension(completion:)

Instance Method

# handleAuthorizationForExtension(completion:)

Requests permission to save and read the data types specified by an extension.

func handleAuthorizationForExtension() async throws

## Parameters

`completion`

A block that is called after the user finishes responding to the request. This block is passed the following parameters:

success

A Boolean value that indicates whether the user responded to the prompt (if any). This value does not indicate whether permission was actually granted. This parameter is `false` if the user canceled the prompt without selecting permissions; otherwise, `true`.

error

An error object. If an error occurred, this object contains information about the error; otherwise, it is set to `nil`.

## Discussion

The host app must implement the application delegate’s `applicationShouldRequestHealthAuthorization(_:)` method. This delegate method is called after an app extension calls `requestAuthorization(toShare:read:completion:)`. The host app is then responsible for calling `handleAuthorizationForExtension(completion:)`. This method prompts the user to authorize both the app and its extensions for the types that the extension requested.

The system performs this request asynchronously. After the user has finished responding, this method calls its completion block on a background queue. If the user has already chosen to grant or prohibit access to all of the types specified, the completion is called without prompting the user.

## See Also

### Accessing HealthKit

Returns the app’s authorization status for sharing the specified data type.

`enum HKAuthorizationStatus`

Constants indicating the authorization status for a particular data type.

Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

`enum HKAuthorizationRequestStatus`

Values that indicate whether your app needs to request authorization from the user.

Returns a Boolean value that indicates whether HealthKit is available on this device.

Returns a Boolean value that indicates whether the current device supports clinical records.

Requests permission to save and read the specified data types.

Asynchronously requests permission to save and read the specified data types.

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

`var authorizationViewControllerPresenter: UIViewController?`

The view controller that presents HealthKit authorization sheets.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/authorizationviewcontrollerpresenter

- HealthKit
- HKHealthStore
- authorizationViewControllerPresenter

Instance Property

# authorizationViewControllerPresenter

The view controller that presents HealthKit authorization sheets.

weak var authorizationViewControllerPresenter: UIViewController? { get set }

## Discussion

By default, the system infers the correct view controller to show HealthKit’s authorization sheet. In some cases, you can improve the user experience by explicitly defining how the system presents the authentication sheets. In particular, consider setting this property when using HealthKit in an iPadOS app.

## See Also

### Accessing HealthKit

Returns the app’s authorization status for sharing the specified data type.

`enum HKAuthorizationStatus`

Constants indicating the authorization status for a particular data type.

Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

`enum HKAuthorizationRequestStatus`

Values that indicate whether your app needs to request authorization from the user.

Returns a Boolean value that indicates whether HealthKit is available on this device.

Returns a Boolean value that indicates whether the current device supports clinical records.

Requests permission to save and read the specified data types.

Asynchronously requests permission to save and read the specified data types.

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

Requests permission to save and read the data types specified by an extension.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/execute(_:)

#app-main)

- HealthKit
- HKHealthStore
- execute(\_:)

Instance Method

# execute(\_:)

Starts executing the provided query.

func execute(_ query: HKQuery)

## Parameters

`query`

A concrete subclass of the `HKQuery` class (any of the classes `HKSampleQuery`, `HKAnchoredObjectQuery`, `HKCorrelationQuery`, `HKObserverQuery`, `HKSourceQuery`, `HKStatisticsQuery`, or `HKStatisticsCollectionQuery`).

## Mentioned in

Executing Activity Summary Queries

Executing Anchored Object Queries

Executing Observer Queries

Executing Sample Queries

Executing Source Queries

## Discussion

HealthKit executes queries asynchronously on a background queue. Most queries automatically stop after they have finished executing. However, long-running queries—such as observer queries and some statistics collection queries—continue to execute in the background. To stop long-running queries, call the `stop(_:)` method.

## See Also

### Querying HealthKit data

`func stop(HKQuery)`

Stops a long-running query.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/stop(_:)

#app-main)

- HealthKit
- HKHealthStore
- stop(\_:)

Instance Method

# stop(\_:)

Stops a long-running query.

func stop(_ query: HKQuery)

## Parameters

`query`

Either an `HKObserverQuery` instance or an `HKStatisticsCollectionQuery` instance.

## Mentioned in

Executing Observer Queries

Reading route data

## Discussion

Use this method on long-running queries only. Most queries automatically stop after they have gathered the requested data. Long-running queries continue to operate on a background thread, watching the HealthKit store for updates. You can cancel these queries by using this method.

## See Also

### Querying HealthKit data

`func execute(HKQuery)`

Starts executing the provided query.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/biologicalsex()

#app-main)

- HealthKit
- HKHealthStore
- biologicalSex()

Instance Method

# biologicalSex()

Reads someone’s biological sex from the HealthKit store.

## Return Value

An object containing information about someone’s biological sex.

## Mentioned in

About the HealthKit framework

## Discussion

For a list of possible values, see `HKBiologicalSex`.

If a person hasn’t set their biological sex or if they’ve denied permission to read the biological sex, this method returns an `HKBiologicalSex.notSet` value.

## Topics

### Possible Values

`class HKBiologicalSexObject`

This class acts as a wrapper for the `HKBiologicalSex` enumeration.

`enum HKBiologicalSex`

Constants indicating the user’s sex.

## See Also

### Reading characteristic data

Reads the user’s blood type from the HealthKit store.

Reads the user’s date of birth from the HealthKit store as a date value.

Deprecated

Reads the user’s date of birth from the HealthKit store as date components.

Reads the user’s Fitzpatrick Skin Type from the HealthKit store.

Reads the user’s wheelchair use from the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/bloodtype()

#app-main)

- HealthKit
- HKHealthStore
- bloodType()

Instance Method

# bloodType()

Reads the user’s blood type from the HealthKit store.

## Return Value

A blood type object that contains information about the user’s blood type.

## Mentioned in

About the HealthKit framework

## Discussion

If the user has not specified a blood type or if the user has denied your app permission to read the blood type, this method returns an `HKBloodType.notSet` value.

## Topics

### Possible Values

`class HKBloodTypeObject`

This class acts as a wrapper for the `HKBloodType` enumeration.

`enum HKBloodType`

Constants indicating the user’s blood type.

## See Also

### Reading characteristic data

Reads someone’s biological sex from the HealthKit store.

Reads the user’s date of birth from the HealthKit store as a date value.

Deprecated

Reads the user’s date of birth from the HealthKit store as date components.

Reads the user’s Fitzpatrick Skin Type from the HealthKit store.

Reads the user’s wheelchair use from the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/dateofbirth()

#app-main)

- HealthKit
- HKHealthStore
- dateOfBirth() Deprecated

Instance Method

# dateOfBirth()

Reads the user’s date of birth from the HealthKit store as a date value.

iOS 8.0–10.0DeprecatediPadOS 8.0–10.0DeprecatedMac Catalyst 13.1–13.1DeprecatedvisionOS 1.0–1.0DeprecatedwatchOS 2.0–3.0Deprecated

## Return Value

An `NSDate` object representing the user’s birthdate, or `nil`.

## Mentioned in

About the HealthKit framework

## Discussion

If the user has not yet specified a birth date, or if the user has denied your app permission to read the birth date, this method returns `nil`.

## See Also

### Reading characteristic data

Reads someone’s biological sex from the HealthKit store.

Reads the user’s blood type from the HealthKit store.

Reads the user’s date of birth from the HealthKit store as date components.

Reads the user’s Fitzpatrick Skin Type from the HealthKit store.

Reads the user’s wheelchair use from the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/dateofbirthcomponents()

#app-main)

- HealthKit
- HKHealthStore
- dateOfBirthComponents()

Instance Method

# dateOfBirthComponents()

Reads the user’s date of birth from the HealthKit store as date components.

## Return Value

An `NSDateComponents` object representing the user’s birthdate in the Gregorian calendar, or `nil`.

## Discussion

If the user has not yet specified a birth date, or if the user has denied your app permission to read the birth date, this method returns `nil`.

## See Also

### Reading characteristic data

Reads someone’s biological sex from the HealthKit store.

Reads the user’s blood type from the HealthKit store.

Reads the user’s date of birth from the HealthKit store as a date value.

Deprecated

Reads the user’s Fitzpatrick Skin Type from the HealthKit store.

Reads the user’s wheelchair use from the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/fitzpatrickskintype()

#app-main)

- HealthKit
- HKHealthStore
- fitzpatrickSkinType()

Instance Method

# fitzpatrickSkinType()

Reads the user’s Fitzpatrick Skin Type from the HealthKit store.

## Return Value

A skin type object representing the skin type selected by the user.

## Mentioned in

About the HealthKit framework

## Discussion

If the user has not yet specified a skin type, or if the user has denied your app permission to read the skin type, this method returns `HKFitzpatrickSkinType.notSet`.

## Topics

### Possible Values

`class HKFitzpatrickSkinTypeObject`

This class acts as a wrapper for the `HKFitzpatrickSkinType` enumeration.

`enum HKFitzpatrickSkinType`

Categories representing the user’s skin type based on the Fitzpatrick scale.

## See Also

### Reading characteristic data

Reads someone’s biological sex from the HealthKit store.

Reads the user’s blood type from the HealthKit store.

Reads the user’s date of birth from the HealthKit store as a date value.

Deprecated

Reads the user’s date of birth from the HealthKit store as date components.

Reads the user’s wheelchair use from the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/wheelchairuse()

#app-main)

- HealthKit
- HKHealthStore
- wheelchairUse()

Instance Method

# wheelchairUse()

Reads the user’s wheelchair use from the HealthKit store.

## Return Value

An object indicating whether the user uses a wheelchair.

## Discussion

If the user has not yet specified their wheelchair use, or if the user has denied your app permission to read the wheelchair use, this method returns `HKWheelchairUse.notSet`.

## Topics

### Possible Values

`class HKWheelchairUseObject`

This class acts as a wrapper for the wheelchair use enumeration.

`enum HKWheelchairUse`

Constants indicating the user’s wheelchair use.

## See Also

### Reading characteristic data

Reads someone’s biological sex from the HealthKit store.

Reads the user’s blood type from the HealthKit store.

Reads the user’s date of birth from the HealthKit store as a date value.

Deprecated

Reads the user’s date of birth from the HealthKit store as date components.

Reads the user’s Fitzpatrick Skin Type from the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/delete(_:withcompletion:)-78l1m

-78l1m#app-main)

- HealthKit
- HKHealthStore
- delete(\_:withCompletion:)

Instance Method

# delete(\_:withCompletion:)

Deletes the specified object from the HealthKit store.

func delete(
_ object: HKObject,

)
func delete(_ object: HKObject) async throws

## Parameters

`object`

An object that this app has previously saved to the HealthKit store.

`completion`

A block that this method calls as soon as the delete operation is complete. This block is passed the following parameters:

success

A Boolean value. This parameter contains `true` if the object was successfully deleted; otherwise, `false`.

error

An error object. If an error occurred, this object contains information about the error; otherwise, it is set to `nil`.

## Discussion

Your app can delete only those objects that it has previously saved to the HealthKit store. If the user revokes sharing permission, you can no longer delete the object. This method operates asynchronously. As soon as the delete operation is finished, it calls the completion block on a background queue.

If your app has not requested permission to share the object’s data type, the method fails with an `HKError.Code.errorAuthorizationNotDetermined` error. If your app has been denied permission to share the object’s data type, it fails with an `HKError.Code.errorAuthorizationDenied` error.

HealthKit stores a temporary `HKDeletedObject` entry, letting you query for recently deleted objects. However, the deleted objects are periodically removed to save storage space. If you want your app to receive notifications about all the deleted objects, set up an observer query, and enable it for background delivery. In the background query’s update handler, create an `HKAnchoredObjectQuery` object to gather the list of recently deleted objects.

## See Also

### Working with HealthKit objects

Deletes the specified objects from the HealthKit store.

Deletes objects saved by this application that match the provided type and predicate.

Returns the earliest date permitted for samples.

Saves the provided object to the HealthKit store.

Saves an array of objects to the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/deleteobjects(of:predicate:withcompletion:)

#app-main)

- HealthKit
- HKHealthStore
- deleteObjects(of:predicate:withCompletion:)

Instance Method

# deleteObjects(of:predicate:withCompletion:)

Deletes objects saved by this application that match the provided type and predicate.

func deleteObjects(
of objectType: HKObjectType,
predicate: NSPredicate,

)
func deleteObjects(
of objectType: HKObjectType,
predicate: NSPredicate

## Parameters

`objectType`

The type of object to be deleted.

`predicate`

A predicate used to filter the objects to be deleted. This method only deletes objects that match the predicate.

`completion`

A block that this method calls as soon as the delete operation is complete. This block is passed the following parameters:

success

A Boolean value. This parameter contains `true` if the objects were successfully deleted; otherwise, `false`.

deletedObjectCount

The number of objects deleted.

error

An error object. If an error occurred, this object contains information about the error; otherwise, it is set to `nil`.

## Discussion

Your app can delete only those objects that it has previously saved to the HealthKit store. If the user revokes sharing permission for an object type, you can no longer delete those objects. This method operates asynchronously. As soon as the delete operation is finished, it calls the completion block on a background queue.

If your app has not requested permission to share an object’s data type, the method fails with an `HKError.Code.errorAuthorizationNotDetermined` error. If your app has been denied permission to share an object’s data type, it fails with an `HKError.Code.errorAuthorizationDenied` error. When deleting multiple objects, if any object cannot be deleted, none of them are deleted.

HealthKit stores temporary `HKDeletedObject` entries, letting you query for recently deleted objects. However, the deleted objects are periodically removed to save storage space. If you want your app to receive notifications about all the deleted objects, set up an observer query, and enable it for background delivery. In the background query’s update handler, create an anchored object query to gather the list of recently deleted objects.

## See Also

### Working with HealthKit objects

Deletes the specified object from the HealthKit store.

Deletes the specified objects from the HealthKit store.

Returns the earliest date permitted for samples.

Saves the provided object to the HealthKit store.

Saves an array of objects to the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/earliestpermittedsampledate()

#app-main)

- HealthKit
- HKHealthStore
- earliestPermittedSampleDate()

Instance Method

# earliestPermittedSampleDate()

Returns the earliest date permitted for samples.

## Return Value

The earliest date that samples can use. You cannot save or query samples prior to this date.

## Mentioned in

About the HealthKit framework

## Discussion

Attempts to save samples earlier than this date fail with an `HKError.Code.errorInvalidArgument` error. Attempts to query samples before this date return samples after this date.

## See Also

### Working with HealthKit objects

Deletes the specified object from the HealthKit store.

Deletes the specified objects from the HealthKit store.

Deletes objects saved by this application that match the provided type and predicate.

Saves the provided object to the HealthKit store.

Saves an array of objects to the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/save(_:withcompletion:)-6fmtg

-6fmtg#app-main)

- HealthKit
- HKHealthStore
- save(\_:withCompletion:)

Instance Method

# save(\_:withCompletion:)

Saves the provided object to the HealthKit store.

func save(
_ object: HKObject,

)
func save(_ object: HKObject) async throws

## Parameters

`object`

The HealthKit object to be saved. This object can be any concrete subclass of the `HKObject` class (any of the `HKCategorySample`, `HKQuantitySample`, `HKCorrelation`, or `HKWorkout` classes).

`completion`

A block that this method calls as soon as the save operation is complete. This block is passed the following parameters:

success

A Boolean value. This parameter contains `true` if the object was successfully saved to the HealthKit store; otherwise, `false`.

error

An error object. If an error occurred, this object contains information about the error; otherwise, it is set to `nil`.

## Mentioned in

Saving data to HealthKit

## Discussion

This method operates asynchronously. As soon as the save operation is finished, it calls the completion block on a background queue.

If your app has not requested permission to share the object’s data type, the method fails with an `HKError.Code.errorAuthorizationNotDetermined` error. If your app has been denied permission to save the object’s data type, it fails with an `HKError.Code.errorAuthorizationDenied` error. Saving an object with the same unique identifier as an object already in the HealthKit store fails with an `HKError.Code.errorInvalidArgument` error.

In iOS 9.0 and later, saving an object to the HealthKit store sets the object’s `sourceRevision` property to a `HKSourceRevision` instance representing the saving app. On earlier versions of iOS, saving an object sets the `source` property to a `HKSource` instance instead. In both cases, these values are available only after the object is retrieved from the HealthKit store. The original object is not changed.

All samples retrieved by iOS 9.0 and later are given a valid `sourceRevision` property. If the sample was saved using an earlier version of iOS, the source revision’s version is set to `nil`.

## See Also

### Working with HealthKit objects

Deletes the specified object from the HealthKit store.

Deletes the specified objects from the HealthKit store.

Deletes objects saved by this application that match the provided type and predicate.

Returns the earliest date permitted for samples.

Saves an array of objects to the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/enablebackgrounddelivery(for:frequency:withcompletion:)

#app-main)

- HealthKit
- HKHealthStore
- enableBackgroundDelivery(for:frequency:withCompletion:)

Instance Method

# enableBackgroundDelivery(for:frequency:withCompletion:)

Enables the delivery of updates to an app running in the background.

iOSiPadOSvisionOS

func enableBackgroundDelivery(
for type: HKObjectType,
frequency: HKUpdateFrequency,

)
func enableBackgroundDelivery(
for type: HKObjectType,
frequency: HKUpdateFrequency
) async throws

## Parameters

`type`

The type of data to observe. This object can be a `HKCharacteristicType` , `HKQuantityType`, `HKCategoryType`, or `HKWorkoutType`. `HKCorrelationType` is not a supported type for background delivery.

`frequency`

The maximum frequency of the updates. The system wakes your app from the background at most once per time period specified. For a complete list of valid frequencies, see `HKUpdateFrequency`.

`completion`

A block that this method calls as soon as it enables background delivery. It passes the following parameters:

`success`

A Boolean value. This parameter contains `true` if the system successfully enabled background delivery; otherwise, `false`.

`error`

An error object. If an error occurred, this object contains information about the error; otherwise, it is `nil`.

## Mentioned in

Executing Observer Queries

## Discussion

Call this method to register your app for background updates.

HealthKit wakes your app whenever a process saves or deletes samples of the specified type. The system wakes your app at most once per time period defined by the specified frequency. Some sample types have a maximum frequency of `HKUpdateFrequency.hourly`. The system enforces this frequency transparently.

For example, on iOS, `stepCount` samples have an hourly maximum frequency.

In watchOS, most data types have an hourly maximum frequency; however, the following data types can receive updates at `HKUpdateFrequency.immediate`:

- `highHeartRateEvent`

- `lowHeartRateEvent`

- `irregularHeartRhythmEvent`

- `environmentalAudioExposureEvent`

- `headphoneAudioExposureEvent`

- `lowCardioFitnessEvent`

- `numberOfTimesFallen`

- `vo2Max`

- `handwashingEvent`

- `toothbrushingEvent`

Also, in watchOS, the background updates share a budget with `WKApplicationRefreshBackgroundTask` tasks. Your app can receive four updates (or background app refresh tasks) an hour, as long as it has a complication on the active watch face.

### Receive Background Updates

As soon as your app launches, HealthKit calls the update handler for any observer queries that match the newly saved data. If you plan on supporting background delivery, set up all your observer queries in your app delegate’s `application(_:didFinishLaunchingWithOptions:)` method. By setting up the queries in `application(_:didFinishLaunchingWithOptions:)`, you ensure that you’ve instantiated your queries, and they’re ready to use before HealthKit delivers the updates.

After your observer queries have finished processing the new data, you must call the update’s completion handler. This lets HealthKit know that your app successfully received the background delivery. If you don’t call the update’s completion handler, HealthKit continues to attempt to launch your app using a backoff algorithm to increase the delay between attempts. If your app fails to respond three times, HealthKit assumes your app can’t receive data and stops sending background updates.

For more information on the background delivery completion handler, see `HKObserverQueryCompletionHandler`.

## See Also

### Related Documentation

`class HKObserverQuery`

A long-running query that monitors the HealthKit store and updates your app when the HealthKit store saves or deletes a matching sample.

### Managing background delivery

`com.apple.developer.healthkit.background-delivery`

A Boolean value that indicates whether observer queries receive updates while running in the background.

`enum HKUpdateFrequency`

Constants that determine how often the system launches your app in response to changes to HealthKit data.

Disables background deliveries of update notifications for the specified data type.

Disables all background deliveries of update notifications.

---

# https://developer.apple.com/documentation/healthkit/hkupdatefrequency

- HealthKit
- HKUpdateFrequency

Enumeration

# HKUpdateFrequency

Constants that determine how often the system launches your app in response to changes to HealthKit data.

enum HKUpdateFrequency

## Overview

For more information, see `HKObserverQuery`.

## Topics

### Constants

`case immediate`

The system launches your app every time it detects a change.

`case hourly`

The system launches your app at most once an hour in response to changes.

`case daily`

The system launches your app at most once a day in response to changes.

`case weekly`

The system launches your app at most once per week in response to changes.

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

### Managing background delivery

Enables the delivery of updates to an app running in the background.

`com.apple.developer.healthkit.background-delivery`

A Boolean value that indicates whether observer queries receive updates while running in the background.

Disables background deliveries of update notifications for the specified data type.

Disables all background deliveries of update notifications.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/disablebackgrounddelivery(for:withcompletion:)

#app-main)

- HealthKit
- HKHealthStore
- disableBackgroundDelivery(for:withCompletion:)

Instance Method

# disableBackgroundDelivery(for:withCompletion:)

Disables background deliveries of update notifications for the specified data type.

iOSiPadOSvisionOS

func disableBackgroundDelivery(
for type: HKObjectType,

)
func disableBackgroundDelivery(for type: HKObjectType) async throws

## Parameters

`type`

The type of data. This object can be any concrete subclass of the `HKObjectType` class (any of the classes `HKCharacteristicType` , `HKQuantityType`, `HKCategoryType`, `HKWorkoutType` or `HKCorrelationType`).

`completion`

A block that this method calls as soon as the background delivery is disabled. This block is passed the following parameters:

success

A Boolean value. This parameter contains `true` if the background delivery was successfully disabled; otherwise, `false`.

error

An error object. If an error occurred, this object contains information about the error; otherwise, it is set to `nil`.

## Discussion

Call this method to prevent your app from receiving any additional update notifications about the specified data type while in the background. This method operates asynchronously. As soon as the background delivery is disabled, this method calls its completion handler on a background queue.

## See Also

### Related Documentation

`class HKObserverQuery`

A long-running query that monitors the HealthKit store and updates your app when the HealthKit store saves or deletes a matching sample.

### Managing background delivery

Enables the delivery of updates to an app running in the background.

`com.apple.developer.healthkit.background-delivery`

A Boolean value that indicates whether observer queries receive updates while running in the background.

`enum HKUpdateFrequency`

Constants that determine how often the system launches your app in response to changes to HealthKit data.

Disables all background deliveries of update notifications.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/disableallbackgrounddelivery(completion:)

#app-main)

- HealthKit
- HKHealthStore
- disableAllBackgroundDelivery(completion:)

Instance Method

# disableAllBackgroundDelivery(completion:)

Disables all background deliveries of update notifications.

iOSiPadOSvisionOS

func disableAllBackgroundDelivery() async throws

## Parameters

`completion`

A block that this method calls as soon as the background deliveries are disabled. This block is passed the following parameters:

success

A Boolean value. This parameter contains `true` if the background deliveries were successfully disabled; otherwise, `false`.

error

An error object. If an error occurred, this object contains information about the error; otherwise, it is set to `nil`.

## Discussion

Call this method to prevent your app from receiving any additional update notifications while in the background. This method operates asynchronously. As soon as the background deliveries are disabled, this method calls its completion handler on a background queue.

## See Also

### Related Documentation

`class HKObserverQuery`

A long-running query that monitors the HealthKit store and updates your app when the HealthKit store saves or deletes a matching sample.

### Managing background delivery

Enables the delivery of updates to an app running in the background.

`com.apple.developer.healthkit.background-delivery`

A Boolean value that indicates whether observer queries receive updates while running in the background.

`enum HKUpdateFrequency`

Constants that determine how often the system launches your app in response to changes to HealthKit data.

Disables background deliveries of update notifications for the specified data type.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/splittotalenergy(_:start:end:resultshandler:)

#app-main)

- HealthKit
- HKHealthStore
- splitTotalEnergy(\_:start:end:resultsHandler:) Deprecated

Instance Method

# splitTotalEnergy(\_:start:end:resultsHandler:)

Calculates the active and resting energy burned based on the total energy burned over the given duration.

iOS 9.0–11.0DeprecatediPadOS 9.0–11.0DeprecatedMac Catalyst 13.1–13.1DeprecatedvisionOS 1.0–1.0DeprecatedwatchOS 2.0–4.0Deprecated

func splitTotalEnergy(
_ totalEnergy: HKQuantity,
start startDate: Date,
end endDate: Date,

)

## Parameters

`totalEnergy`

A quantity object containing the total energy burned during the specified time period.

`startDate`

A date object representing the activity’s start time.

`endDate`

A date object representing the activity’s end time.

`resultsHandler`

A block that is called as soon as the calculations are complete. This block is passed the following parameters:

restingEnergy

A quantity object containing the resting portion of the total energy.

activeEnergy

A quantity object containing the active portion of the total energy.

error

An error object. If an error occurred, this object contains information about the error; otherwise, it is set to `nil`.

## Discussion

This method operates asynchronously. As soon as the calculation is finished, it calls the completion block on a background queue.

This method splits the total calories into the active and resting calories, based on the user’s estimated resting metabolic rate and the activity’s duration. Use the resulting values to create samples representing both the active and resting energy burned.

Active energy samples contribute to Apple Watch’s activity monitoring.

## See Also

### Managing workouts

Recovers an active workout session.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/recoveractiveworkoutsession(completion:)

#app-main)

- HealthKit
- HKHealthStore
- recoverActiveWorkoutSession(completion:)

Instance Method

# recoverActiveWorkoutSession(completion:)

Recovers an active workout session.

## Mentioned in

Running workout sessions

## Discussion

If your app crashes during an active workout session, the system calls your extension delegate’s `handleActiveWorkoutRecovery()` method the next time your app launches. To recover the workout session, call `recoverActiveWorkoutSession(completion:)` from your extension delegate’s `handleActiveWorkoutRecovery()` method. HealthKit then attempts to restore the previous workout session, returning either a new session object or an error to the completion block.

As soon as you receive the session object, you must access its builder and set up your data source and delegates again, as described in Start a session.

## See Also

### Managing workouts

Calculates the active and resting energy burned based on the total energy burned over the given duration.

Deprecated

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/workoutsessionmirroringstarthandler

- HealthKit
- HKHealthStore
- workoutSessionMirroringStartHandler

Instance Property

# workoutSessionMirroringStartHandler

A block that the system calls when it starts a mirrored workout session.

macOS

## Discussion

The system calls this block on the companion iPhone when someone starts a mirrored workout on Apple Watch. If your iOS app isn’t active, the system launches it in the background.

// The HealthKit store calls this closure when Apple Watch starts a remote session.
store.workoutSessionMirroringStartHandler = { mirroredSession in
// Reset the health data.
self.data = HealthData()

// Save a reference to the workout session.
self.session = mirroredSession
logger.debug("*** A session started on the companion Apple Watch. ***")
}

To ensure that your app can always catch incoming mirrored workout sessions, assign this property as soon as your app launches.

The system calls this block from an arbitrary background queue.

## See Also

### Managing workout sessions

Launches or wakes the companion watchOS app to create a new workout session.

`func pause(HKWorkoutSession)`

Pauses the provided workout session.

`func resumeWorkoutSession(HKWorkoutSession)`

Resumes the provided workout session.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/startwatchapp(with:completion:)

#app-main)

- HealthKit
- HKHealthStore
- startWatchApp(with:completion:)

Instance Method

# startWatchApp(with:completion:)

Launches or wakes the companion watchOS app to create a new workout session.

func startWatchApp(
with workoutConfiguration: HKWorkoutConfiguration,

)
func startWatchApp(toHandle workoutConfiguration: HKWorkoutConfiguration) async throws

## Parameters

`workoutConfiguration`

The configuration data for a new workout session on the watch.

`completion`

A block that this method calls after launching the Watch app. The system calls this block, passing the following parameters:

success

A Boolean value. This parameter contains `true` if the watch app launched successfully; otherwise, `false`.

error

An error object. If an error occurred, this object contains information about the error; otherwise, it’s set to `nil`.

## Discussion

Use this method to launch the companion watchOS app on a paired Apple Watch. After launching, the system calls the handle method on the watchOS app’s delegate and passes the provided workout configuration. Use the workout configuration to start a new workout session on the watch.

To launch a mirrored workout from the iOS companion app, call this method in the iOS companion.

let configuration = HKWorkoutConfiguration()
configuration.activityType = .running
configuration.locationType = .outdoor

do {
try await store.startWatchApp(toHandle: configuration)
}
catch {
// Handle the error here.
fatalError("*** An error occurred while starting a workout on Apple Watch: \(error.localizedDescription) ***")
}

logger.debug("*** Workout Session Started ***")

Next, set up the mirrored workout in the `WKApplicationDelegate` object’s `handle(_:)` method.

class AppDelegate: NSObject, WKApplicationDelegate {

func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
Task {
await WorkoutManager.shared.startWorkout()
logger.debug("Successfully started workout")
}
}
}

extension WorkoutManager {
func startWorkout() async {

let configuration = HKWorkoutConfiguration()
configuration.activityType = .running
configuration.locationType = .outdoor

let session: HKWorkoutSession
do {
session = try HKWorkoutSession(healthStore: store,
configuration: configuration)
} catch {
// Handle failure here.
fatalError("*** An error occurred: \(error.localizedDescription) ***")
}

let builder = session.associatedWorkoutBuilder()

let source = HKLiveWorkoutDataSource(healthStore: store,
workoutConfiguration: configuration)

source.enableCollection(for: HKQuantityType(.stepCount), predicate: nil)
builder.dataSource = source

session.delegate = self
builder.delegate = self

self.session = session
self.builder = builder

let start = Date()

// Start the mirrored session on the companion iPhone.
do {
try await session.startMirroringToCompanionDevice()
}
catch {
fatalError("*** Unable to start the mirrored workout: \(error.localizedDescription) ***")
}

// Start the workout session.
session.startActivity(with: start)

do {
try await builder.beginCollection(at: start)
} catch {
// Handle the error here.
fatalError("*** An error occurred while starting the workout: \(error.localizedDescription) ***")
}

logger.debug("*** Workout Session Started ***")
}
}

## See Also

### Managing workout sessions

A block that the system calls when it starts a mirrored workout session.

`func pause(HKWorkoutSession)`

Pauses the provided workout session.

`func resumeWorkoutSession(HKWorkoutSession)`

Resumes the provided workout session.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/pause(_:)

#app-main)

- HealthKit
- HKHealthStore
- pause(\_:)

Instance Method

# pause(\_:)

Pauses the provided workout session.

macOSwatchOS 3.0–5.0Deprecated

func pause(_ workoutSession: HKWorkoutSession)

## Parameters

`workoutSession`

The workout session to pause.

## Discussion

This method pauses the provided session if it is currently running. The workout session’s state transitions to `HKWorkoutSessionStatePaused`, and the system generates an `HKWorkoutEventType.pause` event and passes it to the workout session delegate’s `workoutSession:didGenerateEvent:` method.

## See Also

### Managing workout sessions

A block that the system calls when it starts a mirrored workout session.

Launches or wakes the companion watchOS app to create a new workout session.

`func resumeWorkoutSession(HKWorkoutSession)`

Resumes the provided workout session.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/resumeworkoutsession(_:)

#app-main)

- HealthKit
- HKHealthStore
- resumeWorkoutSession(\_:)

Instance Method

# resumeWorkoutSession(\_:)

Resumes the provided workout session.

macOSwatchOS 3.0–5.0Deprecated

func resumeWorkoutSession(_ workoutSession: HKWorkoutSession)

## Parameters

`workoutSession`

The workout session to resume.

## Discussion

This method resumes the provided session if it is currently paused. The workout session’s state transitions to `HKWorkoutSessionState.running`, and the system generates an `HKWorkoutEventType.resume` event and passes it to the workout session delegate’s `workoutSession:didGenerateEvent:` method.

## See Also

### Managing workout sessions

A block that the system calls when it starts a mirrored workout session.

Launches or wakes the companion watchOS app to create a new workout session.

`func pause(HKWorkoutSession)`

Pauses the provided workout session.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/recalibrateestimates(sampletype:date:completion:)

#app-main)

- HealthKit
- HKHealthStore
- recalibrateEstimates(sampleType:date:completion:)

Instance Method

# recalibrateEstimates(sampleType:date:completion:)

Recalibrates the prediction algorithm used to calculate the specified sample type.

func recalibrateEstimates(
sampleType: HKSampleType,
date: Date,

)
func recalibrateEstimates(
sampleType: HKSampleType,
date: Date
) async throws

## Parameters

`sampleType`

The sample type to recalibrate.

`date`

The effective date for the recalibration.

`completion`

A completion block that the system calls after recalibrating the data used by the prediction algorithm. The system passes the following parameters:

`success`

A Boolean value that indicates whether the system successfully recalibrated the sample type’s estimates.

`error`

If `success` is `false`, this parameter contains error information; otherwise, it’s `nil`.

## Discussion

Your app can use this method to recalibrate HealthKitʼs prediction algorithms after an event that may significantly affect their results. For example, you can recalibrate the `sixMinuteWalkTestDistance` type to use only data collected after a mobility-impacting health event, such as surgery or an injury. Recalibrating `sixMinuteWalkTestDistance` after such an event may yield more accurate estimates during the recovery period.

Check the `HKSampleType` class’s `allowsRecalibrationForEstimates` method to see if a given sample type supports recalibrating the algorithm.

The following sample code recalibrates the estimates for the six-minute walk test.

// Access the HealthKit Store.
let healthStore = HKHealthStore()

// Get the six-minute walk test type.
let sixMinuteWalkType = HKQuantityType(.sixMinuteWalkTestDistance)

// Verify that the type supports resetting estimates.
if sixMinuteWalkType.allowsRecalibrationForEstimates {

// Reset the estimate.
healthStore.recalibrateEstimates(sampleType: sixMinuteWalkType, date: Date()) { (success, error) in

// Check the success value.
if !success {
if let error = error {
// Handle errors here.
}
}
}
}

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/activitymovemode()

#app-main)

- HealthKit
- HKHealthStore
- activityMoveMode()

Instance Method

# activityMoveMode()

Returns the activity move mode for the current user.

## See Also

### Accessing the move mode

`static let HKUserPreferencesDidChange: NSNotification.Name`

Notifies observers whenever the user changes his or her preferred units.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/start(_:)

#app-main)

- HealthKit
- HKHealthStore
- start(\_:) Deprecated

Instance Method

# start(\_:)

Starts a workout session for the current app.

watchOS 2.0–5.0Deprecated

func start(_ workoutSession: HKWorkoutSession)

## Parameters

`workoutSession`

The workout session to start. You cannot restart a workout session that has stopped. If you pass in a session that is running or has stopped, the system returns an `invalidArgumentException` exception.

## Discussion

Workout sessions allow apps to run in the foreground. The current Foreground App appears when the user wakes the watch. Additionally, Apple Watch sets its sensors based on the workout activity and location types for more accurate measurements and better performance.

Apple Watch can only run one workout session at a time. If a second workout is started while your workout is running, your `HKWorkoutSessionDelegate` object receives an HKErrorAnotherWorkoutSession error, and your session ends.

This method returns immediately, however the work is performed asynchronously on an anonymous serial background queue. If successful, the session’s state transitions to `HKWorkoutSessionState.running`, and the system calls the session delegate’s `workoutSession(_:didChangeTo:from:date:)` method.

## See Also

### Deprecated symbols

Associates the provided samples with the specified workout.

Deprecated

`func end(HKWorkoutSession)`

Ends a workout session for the current app.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/end(_:)

#app-main)

- HealthKit
- HKHealthStore
- end(\_:) Deprecated

Instance Method

# end(\_:)

Ends a workout session for the current app.

watchOS 2.0–5.0Deprecated

func end(_ workoutSession: HKWorkoutSession)

## Parameters

`workoutSession`

A currently running workout session. If the session is not running, the system returns an `invalidArgumentException` exception.

## Discussion

This method returns immediately; however, the work is performed asynchronously on an anonymous serial background queue. If successful, the session’s state transitions to `HKWorkoutSessionState.ended`, and the system calls the session delegate’s `workoutSession(_:didChangeTo:from:date:)` method.

## See Also

### Deprecated symbols

Associates the provided samples with the specified workout.

Deprecated

`func start(HKWorkoutSession)`

Starts a workout session for the current app.

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/relateworkouteffortsample(_:with:activity:completion:)

#app-main)

- HealthKit
- HKHealthStore
- relateWorkoutEffortSample(\_:with:activity:completion:)

Instance Method

# relateWorkoutEffortSample(\_:with:activity:completion:)

func relateWorkoutEffortSample(
_ sample: HKSample,
with workout: HKWorkout,
activity: HKWorkoutActivity?,

)
func relateWorkoutEffortSample(
_ sample: HKSample,
with workout: HKWorkout,
activity: HKWorkoutActivity?

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/unrelateworkouteffortsample(_:from:activity:completion:)

#app-main)

- HealthKit
- HKHealthStore
- unrelateWorkoutEffortSample(\_:from:activity:completion:)

Instance Method

# unrelateWorkoutEffortSample(\_:from:activity:completion:)

func unrelateWorkoutEffortSample(
_ sample: HKSample,
from workout: HKWorkout,
activity: HKWorkoutActivity?,

)
func unrelateWorkoutEffortSample(
_ sample: HKSample,
from workout: HKWorkout,
activity: HKWorkoutActivity?

---

# https://developer.apple.com/documentation/healthkit/executing-observer-queries)



---

# https://developer.apple.com/documentation/healthkit/setting-up-healthkit).



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/authorizationstatus(for:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkauthorizationstatus)



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/getrequeststatusforauthorization(toshare:read:completion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkauthorizationrequeststatus)



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/ishealthdataavailable())

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/supportshealthrecords())

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/requestauthorization(toshare:read:completion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/requestauthorization(toshare:read:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/requestperobjectreadauthorization(for:predicate:completion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/handleauthorizationforextension(completion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/authorizationviewcontrollerpresenter)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/execute(_:))



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/stop(_:))



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/biologicalsex())



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/bloodtype())



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/dateofbirth())



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/dateofbirthcomponents())

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/fitzpatrickskintype())

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/wheelchairuse())



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/delete(_:withcompletion:)-78l1m)

-78l1m)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/delete(_:withcompletion:)-17hzm)

-17hzm)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/deleteobjects(of:predicate:withcompletion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/earliestpermittedsampledate())

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/save(_:withcompletion:)-6fmtg)

-6fmtg)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/save(_:withcompletion:)-47iwb)

-47iwb)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/preferredunits(for:completion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/enablebackgrounddelivery(for:frequency:withcompletion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkupdatefrequency)



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/disablebackgrounddelivery(for:withcompletion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/disableallbackgrounddelivery(completion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/splittotalenergy(_:start:end:resultshandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/recoveractiveworkoutsession(completion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/workoutsessionmirroringstarthandler)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/startwatchapp(with:completion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/pause(_:))



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/resumeworkoutsession(_:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/recalibrateestimates(sampletype:date:completion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/activitymovemode())



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/add(_:to:completion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/start(_:))



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/end(_:))



---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/relateworkouteffortsample(_:with:activity:completion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkhealthstore/unrelateworkouteffortsample(_:from:activity:completion:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/healthkit/hkobjecttype

- HealthKit
- HKObjectType

Class

# HKObjectType

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

class HKObjectType

## Mentioned in

Saving data to HealthKit

About the HealthKit framework

## Overview

The `HKObjectType` class is an abstract class. Don’t instantiate an `HKObjectType` object directly. Instead, instantiate one of the following concrete subclasses:

- `HKActivitySummaryType`

- `HKCategoryType`

- `HKCorrelationType`

- `HKCharacteristicType`

- `HKDocumentType`

- `HKQuantityType`

- `HKSeriesType`

- `HKWorkoutType`

The `HKObjectType` class provides a convenience method to create each of these subclasses.

### Work with Object Types

Like many HealthKit classes, HealthKit object types aren’t extensible. Don’t subclass these classes.

Additionally, wherever possible, this class uses a single instance to represent all copies of the same type. For example, if you make two calls to the `quantityType(forIdentifier:)` method with the same identifier, the system returns the same instance. Reusing object types helps reduce HealthKit’s overall memory usage.

## Topics

### Creating quantity types

Returns the shared quantity type for the provided identifier.

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

### Creating category types

Returns the shared category type for the provided identifier.

`struct HKCategoryTypeIdentifier`

Identifiers for creating category types.

### Creating characteristic types

Returns the shared characteristic type for the provided identifier.

`struct HKCharacteristicTypeIdentifier`

The identifiers that create characteristic type objects.

### Creating correlation types

Returns the shared correlation type for the provided identifier.

`struct HKCorrelationTypeIdentifier`

The identifiers that create correlation type objects.

### Creating workout types

Returns the shared `HKWorkoutType` object.

### Creating activity summary types

Returns the shared activity summary type.

### Creating electrocardiogram types

Returns the shared electrocardiogram type.

### Creating audiogram sample types

Returns an audiogram sample type.

### Creating vision prescription types

Returns a shared vision prescription type object.

### Creating clinical record types

Returns the shared clinical type for the provided identifier.

### Creating series types

Returns the shared series type for the provided identifier.

### Creating document types

Returns the shared document type for the provided identifier.

`struct HKDocumentTypeIdentifier`

The identifiers for documents.

### Getting property data

`var identifier: String`

A unique string identifying the HealthKit object type.

Returns a Boolean that indicates whether the data type requires per-object authorization.

## Relationships

### Inherits From

- `NSObject`

### Inherited By

- `HKActivitySummaryType`
- `HKCharacteristicType`
- `HKSampleType`
- `HKUserAnnotatedMedicationType`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Object type subclasses

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`class HKQuantityType`

A type that identifies samples that store numerical values.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCorrelationType`

A type that identifies samples that group multiple subsamples.

`class HKActivitySummaryType`

A type that identifies activity summary objects.

`class HKAudiogramSampleType`

A type that identifies samples that contain audiogram data.

`class HKElectrocardiogramType`

A type that identifies samples containing electrocardiogram data.

`class HKSeriesType`

A type that indicates the data stored in a series sample.

`class HKClinicalType`

A type that identifies samples that contain clinical record data.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`class HKSampleType`

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkcharacteristictype

- HealthKit
- HKCharacteristicType

Class

# HKCharacteristicType

A type that represents data that doesn’t typically change over time.

class HKCharacteristicType

## Overview

The `HKCharacteristicType` class is a concrete subclass of the `HKObjectType` class. To create a characteristic type instance, use the object type’s `characteristicType(forIdentifier:)` convenience method.

Unlike the other object types, characteristic types cannot be used to create and save new HealthKit objects. Instead, users must enter and edit their characteristic data using the Health app. Similarly, you cannot create queries for characteristic types. Instead, use the HealthKit store to access the data (see Reading characteristic data).

HealthKit provides five characteristic types: biological sex, blood type, birthdate, Fitzpatrick skin type, and wheelchair use. These types are used only when asking for permission to read data from the HealthKit store.

## Topics

### Creating Characteristic Types

`convenience init(HKCharacteristicTypeIdentifier)`

Creates a characteristic type using the provided identifier.

## Relationships

### Inherits From

- `HKObjectType`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Related Documentation

`struct HKCharacteristicTypeIdentifier`

The identifiers that create characteristic type objects.

### Object type subclasses

`class HKQuantityType`

A type that identifies samples that store numerical values.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCorrelationType`

A type that identifies samples that group multiple subsamples.

`class HKActivitySummaryType`

A type that identifies activity summary objects.

`class HKAudiogramSampleType`

A type that identifies samples that contain audiogram data.

`class HKElectrocardiogramType`

A type that identifies samples containing electrocardiogram data.

`class HKSeriesType`

A type that indicates the data stored in a series sample.

`class HKClinicalType`

A type that identifies samples that contain clinical record data.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`class HKObjectType`

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

`class HKSampleType`

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytype

- HealthKit
- HKQuantityType

Class

# HKQuantityType

A type that identifies samples that store numerical values.

class HKQuantityType

## Mentioned in

Saving data to HealthKit

## Overview

The `HKQuantityType` class is a concrete subclass of the `HKObjectType` class. To create a quantity type instance, use the object type’s `quantityType(forIdentifier:)` convenience method.

Use quantity types to:

- Request permission to read or write matching quantity samples.

- Create and share matching quantity samples.

- Query for matching quantity samples.

## Topics

### Creating Quantity Types

`convenience init(HKQuantityTypeIdentifier)`

Creates a quantity type using the provided identifier.

### Accessing Quantity Type Data

`var aggregationStyle: HKQuantityAggregationStyle`

The aggregation style for the given quantity type.

`enum HKQuantityAggregationStyle`

Constant values that describe how quantities can be aggregated over time.

Returns a Boolean value that indicates whether the quantity type is compatible with the given unit.

## Relationships

### Inherits From

- `HKSampleType`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

### Object type subclasses

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCorrelationType`

A type that identifies samples that group multiple subsamples.

`class HKActivitySummaryType`

A type that identifies activity summary objects.

`class HKAudiogramSampleType`

A type that identifies samples that contain audiogram data.

`class HKElectrocardiogramType`

A type that identifies samples containing electrocardiogram data.

`class HKSeriesType`

A type that indicates the data stored in a series sample.

`class HKClinicalType`

A type that identifies samples that contain clinical record data.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`class HKObjectType`

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

`class HKSampleType`

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkcategorytype

- HealthKit
- HKCategoryType

Class

# HKCategoryType

A type that identifies samples that contain a value from a small set of possible values.

class HKCategoryType

## Overview

The `HKCategoryType` class is a concrete subclass of the HKObjectType class. To create a category type instance, use the `init(_:)` convenience method. For example, the following code creates a category sample type for handwashing events.

let handwashingCategoryType = HKCategoryType(.handwashingEvent)

Use category types to:

- Request permission to read or write matching category samples.

- Create and share matching category samples.

- Query for matching category samples.

For a complete list of category types, refer to `HKCategoryTypeIdentifier`.

## Topics

### Creating Category Types

`convenience init(HKCategoryTypeIdentifier)`

Creates a category type using the provided identifier.

## Relationships

### Inherits From

- `HKSampleType`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Related Documentation

`struct HKCategoryTypeIdentifier`

Identifiers for creating category types.

`class HKCategorySample`

A sample with values from a short list of possible values.

### Object type subclasses

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`class HKQuantityType`

A type that identifies samples that store numerical values.

`class HKCorrelationType`

A type that identifies samples that group multiple subsamples.

`class HKActivitySummaryType`

A type that identifies activity summary objects.

`class HKAudiogramSampleType`

A type that identifies samples that contain audiogram data.

`class HKElectrocardiogramType`

A type that identifies samples containing electrocardiogram data.

`class HKSeriesType`

A type that indicates the data stored in a series sample.

`class HKClinicalType`

A type that identifies samples that contain clinical record data.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`class HKObjectType`

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

`class HKSampleType`

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkcorrelationtype

- HealthKit
- HKCorrelationType

Class

# HKCorrelationType

A type that identifies samples that group multiple subsamples.

class HKCorrelationType

## Overview

The `HKCorrelationType` class is a concrete subclass of the `HKObjectType` class. To create a correlation type instance, use the object type’s `correlationType(forIdentifier:)` conveniance method.

Use correlation types to:

- Request permission to read or write matching quantity samples.

- Create and share matching quantity samples.

- Query for matching quantity samples.

HealthKit provides two correlation types: blood pressure and food.

### Using Correlation Types

Like many HealthKit classes, correlation types are not extensible and should not be subclassed.

This class reuses the same instance whenever possible. Letting multiple queries share the same workout type helps reduce the overall memory usage.

## Topics

### Creating Correlation Types

`convenience init(HKCorrelationTypeIdentifier)`

Creates a correlation type using the provided identifier.

## Relationships

### Inherits From

- `HKSampleType`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Related Documentation

`struct HKCorrelationTypeIdentifier`

The identifiers that create correlation type objects.

`class HKCorrelation`

A sample that groups multiple related samples into a single entry.

### Object type subclasses

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`class HKQuantityType`

A type that identifies samples that store numerical values.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKActivitySummaryType`

A type that identifies activity summary objects.

`class HKAudiogramSampleType`

A type that identifies samples that contain audiogram data.

`class HKElectrocardiogramType`

A type that identifies samples containing electrocardiogram data.

`class HKSeriesType`

A type that indicates the data stored in a series sample.

`class HKClinicalType`

A type that identifies samples that contain clinical record data.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`class HKObjectType`

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

`class HKSampleType`

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkactivitysummarytype

- HealthKit
- HKActivitySummaryType

Class

# HKActivitySummaryType

A type that identifies activity summary objects.

class HKActivitySummaryType

## Overview

Use the activity summary type to request permission to read `HKActivitySummary` objects from the HealthKit store. To create an activity summary type, use the `HKObjectType` class’s `activitySummaryType()` convenience method.

The `HKActivitySummaryType` class is a concrete subclass of the `HKObjectType` class. Like many HealthKit classes, activity summary types aren’t extensible and you shouldn’t subclass them.

### Access and Modify Activity Summaries

Any workouts that you save to the HealthKit store may affect that day’s summary. For more information, see `HKWorkout`.

To query for activity summary objects, use an `HKActivitySummaryQuery`. You can also create your own `HKActivitySummary` objects (for example, to display in an `HKActivityRingView`), but you can’t save them to the HealthKit store.

## Relationships

### Inherits From

- `HKObjectType`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Related Documentation

`class HKActivitySummary`

An object that contains the move, exercise, and stand data for a given day.

`class HKActivitySummaryQuery`

A query for reading activity summary objects from the HealthKit store.

`class HKActivityRingView`

A view that uses the Move, Exercise, and Stand activity rings to display data from a HealthKit activity summary object.

### Object type subclasses

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`class HKQuantityType`

A type that identifies samples that store numerical values.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCorrelationType`

A type that identifies samples that group multiple subsamples.

`class HKAudiogramSampleType`

A type that identifies samples that contain audiogram data.

`class HKElectrocardiogramType`

A type that identifies samples containing electrocardiogram data.

`class HKSeriesType`

A type that indicates the data stored in a series sample.

`class HKClinicalType`

A type that identifies samples that contain clinical record data.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`class HKObjectType`

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

`class HKSampleType`

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkaudiogramsampletype

- HealthKit
- HKAudiogramSampleType

Class

# HKAudiogramSampleType

A type that identifies samples that contain audiogram data.

class HKAudiogramSampleType

## Overview

The `HKAudiogramSampleType` class is a concrete subclass of the `HKObjectType` class. To create an audiogram sample type instance, use the object type’s `audiogramSampleType()` convenience method.

Use audiogram sample types to:

- Request permission to read or write audiogram samples.

- Create and share audiogram samples.

- Query for audiogram samples.

## Relationships

### Inherits From

- `HKSampleType`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Object type subclasses

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`class HKQuantityType`

A type that identifies samples that store numerical values.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCorrelationType`

A type that identifies samples that group multiple subsamples.

`class HKActivitySummaryType`

A type that identifies activity summary objects.

`class HKElectrocardiogramType`

A type that identifies samples containing electrocardiogram data.

`class HKSeriesType`

A type that indicates the data stored in a series sample.

`class HKClinicalType`

A type that identifies samples that contain clinical record data.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`class HKObjectType`

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

`class HKSampleType`

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkelectrocardiogramtype

- HealthKit
- HKElectrocardiogramType

Class

# HKElectrocardiogramType

A type that identifies samples containing electrocardiogram data.

class HKElectrocardiogramType

## Overview

The `HKElectrocardiogramType` class is a concrete subclass of the `HKObjectType` class. To create an electrocardiogram type instance, use the object type’s `electrocardiogramType()` convenience method.

Use the electrocardiogram type to:

- Request permission to read electrocardiogram samples

- Query for electrocardiogram samples

## Relationships

### Inherits From

- `HKSampleType`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Object type subclasses

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`class HKQuantityType`

A type that identifies samples that store numerical values.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCorrelationType`

A type that identifies samples that group multiple subsamples.

`class HKActivitySummaryType`

A type that identifies activity summary objects.

`class HKAudiogramSampleType`

A type that identifies samples that contain audiogram data.

`class HKSeriesType`

A type that indicates the data stored in a series sample.

`class HKClinicalType`

A type that identifies samples that contain clinical record data.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`class HKObjectType`

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

`class HKSampleType`

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkseriestype

- HealthKit
- HKSeriesType

Class

# HKSeriesType

A type that indicates the data stored in a series sample.

class HKSeriesType

## Topics

### Accessing Series Types

Returns a series type object for workout routes.

Returns a series type object for heartbeat data.

## Relationships

### Inherits From

- `HKSampleType`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Related Documentation

`class HKWorkoutRoute`

A sample that contains a workout’s route data.

`class HKWorkoutRouteBuilder`

A builder object that incrementally constructs a workout route.

`class HKWorkoutRouteQuery`

A query to access the location data stored in a workout route.

### Object type subclasses

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`class HKQuantityType`

A type that identifies samples that store numerical values.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCorrelationType`

A type that identifies samples that group multiple subsamples.

`class HKActivitySummaryType`

A type that identifies activity summary objects.

`class HKAudiogramSampleType`

A type that identifies samples that contain audiogram data.

`class HKElectrocardiogramType`

A type that identifies samples containing electrocardiogram data.

`class HKClinicalType`

A type that identifies samples that contain clinical record data.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`class HKObjectType`

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

`class HKSampleType`

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkclinicaltype

- HealthKit
- HKClinicalType

Class

# HKClinicalType

A type that identifies samples that contain clinical record data.

class HKClinicalType

## Topics

### Creating Clinical Types

`convenience init(HKClinicalTypeIdentifier)`

Creates a clinical type using the provided identifier.

## Relationships

### Inherits From

- `HKSampleType`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Related Documentation

`class HKClinicalRecord`

A sample that stores a clinical record.

`static let allergyRecord: HKClinicalTypeIdentifier`

A type identifier for records of allergic or intolerant reactions.

`static let conditionRecord: HKClinicalTypeIdentifier`

A type identifier for records of a condition, problem, diagnosis, or other event.

`static let immunizationRecord: HKClinicalTypeIdentifier`

A type identifier for records of the current or historical administration of vaccines.

`static let labResultRecord: HKClinicalTypeIdentifier`

A type identifier for records of lab results.

`static let medicationRecord: HKClinicalTypeIdentifier`

A type identifier for records of medication.

`static let procedureRecord: HKClinicalTypeIdentifier`

A type identifier for records of procedures.

`static let vitalSignRecord: HKClinicalTypeIdentifier`

A type identifier for records of vital signs.

### Object type subclasses

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`class HKQuantityType`

A type that identifies samples that store numerical values.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCorrelationType`

A type that identifies samples that group multiple subsamples.

`class HKActivitySummaryType`

A type that identifies activity summary objects.

`class HKAudiogramSampleType`

A type that identifies samples that contain audiogram data.

`class HKElectrocardiogramType`

A type that identifies samples containing electrocardiogram data.

`class HKSeriesType`

A type that indicates the data stored in a series sample.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`class HKObjectType`

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

`class HKSampleType`

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkworkouttype

- HealthKit
- HKWorkoutType

Class

# HKWorkoutType

A type that identifies samples that store information about a workout.

class HKWorkoutType

## Overview

The `HKWorkoutType` class is a concrete subclass of the `HKObjectType` class. To create a workout type instances, use the `workoutType()` convenience method.

All workouts use the same workout type instance.

## Relationships

### Inherits From

- `HKSampleType`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Object type subclasses

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`class HKQuantityType`

A type that identifies samples that store numerical values.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCorrelationType`

A type that identifies samples that group multiple subsamples.

`class HKActivitySummaryType`

A type that identifies activity summary objects.

`class HKAudiogramSampleType`

A type that identifies samples that contain audiogram data.

`class HKElectrocardiogramType`

A type that identifies samples containing electrocardiogram data.

`class HKSeriesType`

A type that indicates the data stored in a series sample.

`class HKClinicalType`

A type that identifies samples that contain clinical record data.

`class HKObjectType`

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

`class HKSampleType`

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hksampletype

- HealthKit
- HKSampleType

Class

# HKSampleType

An abstract superclass for all classes that identify a specific type of sample when working with the HealthKit store.

class HKSampleType

## Mentioned in

Saving data to HealthKit

## Overview

The `HKSampleType` class is an abstract subclass of the `HKObjectType` class, used to represent data samples. Never instantiate an `HKSampleType` object directly. Instead, work with one of its concrete subclasses: `HKCategoryType`, `HKCorrelationType`, `HKQuantityType`, or `HKWorkoutType` classes.

## Topics

### Checking the Duration Restriction

`var isMinimumDurationRestricted: Bool`

A Boolean value that indicates whether samples of this type have a minimum time interval between the start and end dates.

`var minimumAllowedDuration: TimeInterval`

The minimum duration if the sample type has a restricted duration.

`var isMaximumDurationRestricted: Bool`

A Boolean value that indicates whether samples of this type have a maximum time interval between the start and end dates.

`var maximumAllowedDuration: TimeInterval`

The maximum duration if the sample type has a restricted duration.

### Checking on Recalibrating Estimates

`var allowsRecalibrationForEstimates: Bool`

A Boolean value that indicates whether HealthKit supports recalibrating the prediction algorithm used to produce estimates for this sample type.

## Relationships

### Inherits From

- `HKObjectType`

### Inherited By

- `HKAudiogramSampleType`
- `HKCategoryType`
- `HKClinicalType`
- `HKCorrelationType`
- `HKDocumentType`
- `HKElectrocardiogramType`
- `HKMedicationDoseEventType`
- `HKPrescriptionType`
- `HKQuantityType`
- `HKScoredAssessmentType`
- `HKSeriesType`
- `HKStateOfMindType`
- `HKWorkoutType`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Object type subclasses

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`class HKQuantityType`

A type that identifies samples that store numerical values.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCorrelationType`

A type that identifies samples that group multiple subsamples.

`class HKActivitySummaryType`

A type that identifies activity summary objects.

`class HKAudiogramSampleType`

A type that identifies samples that contain audiogram data.

`class HKElectrocardiogramType`

A type that identifies samples containing electrocardiogram data.

`class HKSeriesType`

A type that indicates the data stored in a series sample.

`class HKClinicalType`

A type that identifies samples that contain clinical record data.

`class HKWorkoutType`

A type that identifies samples that store information about a workout.

`class HKObjectType`

An abstract superclass with subclasses that identify a specific type of data for the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkcharacteristictypeidentifier/activitymovemode

- HealthKit
- HKCharacteristicTypeIdentifier
- activityMoveMode

Type Property

# activityMoveMode

A characteristic identifier for the user’s activity mode.

static let activityMoveMode: HKCharacteristicTypeIdentifier

## See Also

### Characteristic identifiers

`static let biologicalSex: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s sex.

`static let bloodType: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s blood type.

`static let dateOfBirth: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s date of birth.

`static let fitzpatrickSkinType: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s skin type.

`static let wheelchairUse: HKCharacteristicTypeIdentifier`

A characteristic identifier for the user’s use of a wheelchair.

---

# https://developer.apple.com/documentation/healthkit/hkcharacteristictypeidentifier/biologicalsex

- HealthKit
- HKCharacteristicTypeIdentifier
- biologicalSex

Type Property

# biologicalSex

A characteristic type identifier for the user’s sex.

static let biologicalSex: HKCharacteristicTypeIdentifier

## Discussion

This type uses values from the `HKBiologicalSex` enum.

## See Also

### Related Documentation

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`struct HKCharacteristicTypeIdentifier`

The identifiers that create characteristic type objects.

`enum HKBiologicalSex`

Constants indicating the user’s sex.

`class HKBiologicalSexObject`

This class acts as a wrapper for the `HKBiologicalSex` enumeration.

### Characteristic identifiers

`static let activityMoveMode: HKCharacteristicTypeIdentifier`

A characteristic identifier for the user’s activity mode.

`static let bloodType: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s blood type.

`static let dateOfBirth: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s date of birth.

`static let fitzpatrickSkinType: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s skin type.

`static let wheelchairUse: HKCharacteristicTypeIdentifier`

A characteristic identifier for the user’s use of a wheelchair.

---

# https://developer.apple.com/documentation/healthkit/hkcharacteristictypeidentifier/bloodtype

- HealthKit
- HKCharacteristicTypeIdentifier
- bloodType

Type Property

# bloodType

A characteristic type identifier for the user’s blood type.

static let bloodType: HKCharacteristicTypeIdentifier

## Discussion

This type uses values from the `HKBloodType` enum.

## See Also

### Related Documentation

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`struct HKCharacteristicTypeIdentifier`

The identifiers that create characteristic type objects.

`enum HKBloodType`

Constants indicating the user’s blood type.

`class HKBloodTypeObject`

This class acts as a wrapper for the `HKBloodType` enumeration.

### Characteristic identifiers

`static let activityMoveMode: HKCharacteristicTypeIdentifier`

A characteristic identifier for the user’s activity mode.

`static let biologicalSex: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s sex.

`static let dateOfBirth: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s date of birth.

`static let fitzpatrickSkinType: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s skin type.

`static let wheelchairUse: HKCharacteristicTypeIdentifier`

A characteristic identifier for the user’s use of a wheelchair.

---

# https://developer.apple.com/documentation/healthkit/hkcharacteristictypeidentifier/dateofbirth

- HealthKit
- HKCharacteristicTypeIdentifier
- dateOfBirth

Type Property

# dateOfBirth

A characteristic type identifier for the user’s date of birth.

static let dateOfBirth: HKCharacteristicTypeIdentifier

## See Also

### Related Documentation

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`struct HKCharacteristicTypeIdentifier`

The identifiers that create characteristic type objects.

### Characteristic identifiers

`static let activityMoveMode: HKCharacteristicTypeIdentifier`

A characteristic identifier for the user’s activity mode.

`static let biologicalSex: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s sex.

`static let bloodType: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s blood type.

`static let fitzpatrickSkinType: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s skin type.

`static let wheelchairUse: HKCharacteristicTypeIdentifier`

A characteristic identifier for the user’s use of a wheelchair.

---

# https://developer.apple.com/documentation/healthkit/hkcharacteristictypeidentifier/fitzpatrickskintype

- HealthKit
- HKCharacteristicTypeIdentifier
- fitzpatrickSkinType

Type Property

# fitzpatrickSkinType

A characteristic type identifier for the user’s skin type.

static let fitzpatrickSkinType: HKCharacteristicTypeIdentifier

## Discussion

This type uses values from the `HKFitzpatrickSkinType` enum.

## See Also

### Related Documentation

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`struct HKCharacteristicTypeIdentifier`

The identifiers that create characteristic type objects.

`enum HKFitzpatrickSkinType`

Categories representing the user’s skin type based on the Fitzpatrick scale.

`class HKFitzpatrickSkinTypeObject`

This class acts as a wrapper for the `HKFitzpatrickSkinType` enumeration.

### Characteristic identifiers

`static let activityMoveMode: HKCharacteristicTypeIdentifier`

A characteristic identifier for the user’s activity mode.

`static let biologicalSex: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s sex.

`static let bloodType: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s blood type.

`static let dateOfBirth: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s date of birth.

`static let wheelchairUse: HKCharacteristicTypeIdentifier`

A characteristic identifier for the user’s use of a wheelchair.

---

# https://developer.apple.com/documentation/healthkit/hkcharacteristictypeidentifier/wheelchairuse

- HealthKit
- HKCharacteristicTypeIdentifier
- wheelchairUse

Type Property

# wheelchairUse

A characteristic identifier for the user’s use of a wheelchair.

static let wheelchairUse: HKCharacteristicTypeIdentifier

## See Also

### Related Documentation

`class HKCharacteristicType`

A type that represents data that doesn’t typically change over time.

`struct HKCharacteristicTypeIdentifier`

The identifiers that create characteristic type objects.

### Characteristic identifiers

`static let activityMoveMode: HKCharacteristicTypeIdentifier`

A characteristic identifier for the user’s activity mode.

`static let biologicalSex: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s sex.

`static let bloodType: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s blood type.

`static let dateOfBirth: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s date of birth.

`static let fitzpatrickSkinType: HKCharacteristicTypeIdentifier`

A characteristic type identifier for the user’s skin type.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/stepcount

- HealthKit
- HKQuantityTypeIdentifier
- stepCount

Type Property

# stepCount

A quantity sample type that measures the number of steps the user has taken.

static let stepCount: HKQuantityTypeIdentifier

## Discussion

These samples use count units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`). The system automatically records samples on iPhone and Apple Watch. Sample data may be condensed and/or coalesced by HealthKit. For more information, see Accessing condensed workout samples.

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/distancewalkingrunning

- HealthKit
- HKQuantityTypeIdentifier
- distanceWalkingRunning

Type Property

# distanceWalkingRunning

A quantity sample type that measures the distance the user has moved by walking or running.

static let distanceWalkingRunning: HKQuantityTypeIdentifier

## Mentioned in

Accessing condensed workout samples

Dividing a HealthKit workout into activities

Running workout sessions

## Discussion

These samples use length units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`). The system automatically records distance samples on iPhone and Apple Watch. Sample data may be condensed and/or coalesced by HealthKit. For more information, see Accessing condensed workout samples.

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/runningspeed

- HealthKit
- HKQuantityTypeIdentifier
- runningSpeed

Type Property

# runningSpeed

A quantity sample type that measures the runner’s speed.

static let runningSpeed: HKQuantityTypeIdentifier

## Discussion

These samples use distance per time units (described in `HKUnit`) and measure discrete values (described in `HKQuantityAggregationStyle`). During outdoor running workouts, the system automatically records running speed samples on Apple Watch. Sample data may be condensed and/or coalesced by HealthKit. For more information, see Accessing condensed workout samples.

## See Also

### Related Documentation

`static let appleWalkingSteadiness: HKQuantityTypeIdentifier`

A quantity sample type that measures the steadiness of the user’s gait.

`static let appleWalkingSteadinessEvent: HKCategoryTypeIdentifier`

A category sample type that records an incident where the user showed a reduced score for their gait’s steadiness.

`static let sixMinuteWalkTestDistance: HKQuantityTypeIdentifier`

A quantity sample type that stores the distance a user can walk during a six-minute walk test.

`static let walkingSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s average speed when walking steadily over flat ground.

`static let walkingStepLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the average length of the user’s step when walking steadily over flat ground.

`static let walkingAsymmetryPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the percentage of steps in which one foot moves at a different speed than the other when walking on flat ground.

`static let walkingDoubleSupportPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the percentage of time when both of the user’s feet touch the ground while walking steadily over flat ground.

`static let stairAscentSpeed: HKQuantityTypeIdentifier`

A quantity sample type measuring the user’s speed while climbing a flight of stairs.

`static let stairDescentSpeed: HKQuantityTypeIdentifier`

A quantity sample type measuring the user’s speed while descending a flight of stairs.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/runningstridelength

- HealthKit
- HKQuantityTypeIdentifier
- runningStrideLength

Type Property

# runningStrideLength

A quantity sample type that measures the distance covered by a single step while running.

static let runningStrideLength: HKQuantityTypeIdentifier

## Mentioned in

Dividing a HealthKit workout into activities

## Discussion

These samples use length units (described in `HKUnit`) and measure discrete values (described in `HKQuantityAggregationStyle`). During outdoor running workouts, the system automatically records running stride samples on Apple Watch SE and Series 6 and later. Sample data may be condensed and/or coalesced by HealthKit. For more information, see Accessing condensed workout samples.

## See Also

### Related Documentation

`static let appleWalkingSteadiness: HKQuantityTypeIdentifier`

A quantity sample type that measures the steadiness of the user’s gait.

`static let appleWalkingSteadinessEvent: HKCategoryTypeIdentifier`

A category sample type that records an incident where the user showed a reduced score for their gait’s steadiness.

`static let sixMinuteWalkTestDistance: HKQuantityTypeIdentifier`

A quantity sample type that stores the distance a user can walk during a six-minute walk test.

`static let walkingSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s average speed when walking steadily over flat ground.

`static let walkingStepLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the average length of the user’s step when walking steadily over flat ground.

`static let walkingAsymmetryPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the percentage of steps in which one foot moves at a different speed than the other when walking on flat ground.

`static let walkingDoubleSupportPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the percentage of time when both of the user’s feet touch the ground while walking steadily over flat ground.

`static let stairAscentSpeed: HKQuantityTypeIdentifier`

A quantity sample type measuring the user’s speed while climbing a flight of stairs.

`static let stairDescentSpeed: HKQuantityTypeIdentifier`

A quantity sample type measuring the user’s speed while descending a flight of stairs.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/runningpower

- HealthKit
- HKQuantityTypeIdentifier
- runningPower

Type Property

# runningPower

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

static let runningPower: HKQuantityTypeIdentifier

## Discussion

These samples use power units (described in `HKUnit`) and measure discrete values (described in `HKQuantityAggregationStyle`). During outdoor running workouts, the system automatically records running power samples on Apple Watch SE and Series 6 and later. Sample data may be condensed and/or coalesced by HealthKit. For more information, see Accessing condensed workout samples.

## See Also

### Related Documentation

`static let appleWalkingSteadiness: HKQuantityTypeIdentifier`

A quantity sample type that measures the steadiness of the user’s gait.

`static let appleWalkingSteadinessEvent: HKCategoryTypeIdentifier`

A category sample type that records an incident where the user showed a reduced score for their gait’s steadiness.

`static let sixMinuteWalkTestDistance: HKQuantityTypeIdentifier`

A quantity sample type that stores the distance a user can walk during a six-minute walk test.

`static let walkingSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s average speed when walking steadily over flat ground.

`static let walkingStepLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the average length of the user’s step when walking steadily over flat ground.

`static let walkingAsymmetryPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the percentage of steps in which one foot moves at a different speed than the other when walking on flat ground.

`static let walkingDoubleSupportPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the percentage of time when both of the user’s feet touch the ground while walking steadily over flat ground.

`static let stairAscentSpeed: HKQuantityTypeIdentifier`

A quantity sample type measuring the user’s speed while climbing a flight of stairs.

`static let stairDescentSpeed: HKQuantityTypeIdentifier`

A quantity sample type measuring the user’s speed while descending a flight of stairs.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/runninggroundcontacttime

- HealthKit
- HKQuantityTypeIdentifier
- runningGroundContactTime

Type Property

# runningGroundContactTime

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

static let runningGroundContactTime: HKQuantityTypeIdentifier

## Discussion

These samples use time units (described in `HKUnit`) and measure discrete values (described in `HKQuantityAggregationStyle`). During outdoor running workouts, the system automatically records ground contact time on Apple Watch SE and Series 6 and later. Sample data may be condensed and/or coalesced by HealthKit. For more information, see Accessing condensed workout samples.

## See Also

### Related Documentation

`static let appleWalkingSteadiness: HKQuantityTypeIdentifier`

A quantity sample type that measures the steadiness of the user’s gait.

`static let appleWalkingSteadinessEvent: HKCategoryTypeIdentifier`

A category sample type that records an incident where the user showed a reduced score for their gait’s steadiness.

`static let sixMinuteWalkTestDistance: HKQuantityTypeIdentifier`

A quantity sample type that stores the distance a user can walk during a six-minute walk test.

`static let walkingSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s average speed when walking steadily over flat ground.

`static let walkingStepLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the average length of the user’s step when walking steadily over flat ground.

`static let walkingAsymmetryPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the percentage of steps in which one foot moves at a different speed than the other when walking on flat ground.

`static let walkingDoubleSupportPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the percentage of time when both of the user’s feet touch the ground while walking steadily over flat ground.

`static let stairAscentSpeed: HKQuantityTypeIdentifier`

A quantity sample type measuring the user’s speed while climbing a flight of stairs.

`static let stairDescentSpeed: HKQuantityTypeIdentifier`

A quantity sample type measuring the user’s speed while descending a flight of stairs.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/runningverticaloscillation

- HealthKit
- HKQuantityTypeIdentifier
- runningVerticalOscillation

Type Property

# runningVerticalOscillation

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

static let runningVerticalOscillation: HKQuantityTypeIdentifier

## Discussion

These samples use length units (described in `HKUnit`) and measure discrete values (described in `HKQuantityAggregationStyle`). During outdoor running workouts, the system automatically records vertical oscillation on Apple Watch SE and Series 6 and later. Sample data may be condensed and/or coalesced by HealthKit. For more information, see Accessing condensed workout samples.

## See Also

### Related Documentation

`static let appleWalkingSteadiness: HKQuantityTypeIdentifier`

A quantity sample type that measures the steadiness of the user’s gait.

`static let appleWalkingSteadinessEvent: HKCategoryTypeIdentifier`

A category sample type that records an incident where the user showed a reduced score for their gait’s steadiness.

`static let sixMinuteWalkTestDistance: HKQuantityTypeIdentifier`

A quantity sample type that stores the distance a user can walk during a six-minute walk test.

`static let walkingSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s average speed when walking steadily over flat ground.

`static let walkingStepLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the average length of the user’s step when walking steadily over flat ground.

`static let walkingAsymmetryPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the percentage of steps in which one foot moves at a different speed than the other when walking on flat ground.

`static let walkingDoubleSupportPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the percentage of time when both of the user’s feet touch the ground while walking steadily over flat ground.

`static let stairAscentSpeed: HKQuantityTypeIdentifier`

A quantity sample type measuring the user’s speed while climbing a flight of stairs.

`static let stairDescentSpeed: HKQuantityTypeIdentifier`

A quantity sample type measuring the user’s speed while descending a flight of stairs.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/distancecycling

- HealthKit
- HKQuantityTypeIdentifier
- distanceCycling

Type Property

# distanceCycling

A quantity sample type that measures the distance the user has moved by cycling.

static let distanceCycling: HKQuantityTypeIdentifier

## Mentioned in

Accessing condensed workout samples

## Discussion

These samples use length units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`). During outdoor cycling workouts, the system automatically records distance samples on Apple Watch. During indoor cycling workouts, the system automatically records distance samples on Apple Watch when connected to a peripheral that provides cycling speed. Sample data may be condensed and/or coalesced by HealthKit. For more information, see Accessing condensed workout samples.

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/pushcount

- HealthKit
- HKQuantityTypeIdentifier
- pushCount

Type Property

# pushCount

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

static let pushCount: HKQuantityTypeIdentifier

## Discussion

These samples use count units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`). The system automatically records samples on Apple Watch when in wheelchair mode.

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/distancewheelchair

- HealthKit
- HKQuantityTypeIdentifier
- distanceWheelchair

Type Property

# distanceWheelchair

A quantity sample type that measures the distance the user has moved using a wheelchair.

static let distanceWheelchair: HKQuantityTypeIdentifier

## Discussion

These samples use length units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`). The system automatically records samples on Apple Watch when in wheelchair mode. Sample data may be condensed and/or coalesced by HealthKit. For more information, see Accessing condensed workout samples.

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/swimmingstrokecount

- HealthKit
- HKQuantityTypeIdentifier
- swimmingStrokeCount

Type Property

# swimmingStrokeCount

A quantity sample type that measures the number of strokes performed while swimming.

static let swimmingStrokeCount: HKQuantityTypeIdentifier

## Mentioned in

Dividing a HealthKit workout into activities

## Discussion

These samples use count units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`).

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/distanceswimming

- HealthKit
- HKQuantityTypeIdentifier
- distanceSwimming

Type Property

# distanceSwimming

A quantity sample type that measures the distance the user has moved while swimming.

static let distanceSwimming: HKQuantityTypeIdentifier

## Mentioned in

Dividing a HealthKit workout into activities

## Discussion

These samples use length units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`).

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/distancedownhillsnowsports

- HealthKit
- HKQuantityTypeIdentifier
- distanceDownhillSnowSports

Type Property

# distanceDownhillSnowSports

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

static let distanceDownhillSnowSports: HKQuantityTypeIdentifier

## Mentioned in

Receiving Downhill Skiing and Snowboarding Data

## Discussion

These samples use length units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`). During downhill skiing workouts, the system automatically records distance samples on Apple Watch.

## See Also

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/basalenergyburned

- HealthKit
- HKQuantityTypeIdentifier
- basalEnergyBurned

Type Property

# basalEnergyBurned

A quantity sample type that measures the resting energy burned by the user.

static let basalEnergyBurned: HKQuantityTypeIdentifier

## Mentioned in

Accessing condensed workout samples

Running workout sessions

## Discussion

Resting energy is the energy that the user’s body burns to maintain its normal, resting state. The body uses this energy to perform basic functions like breathing, circulating blood, and managing the growth and maintenance of cells. These samples use energy units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`). Sample data may be condensed and/or coalesced by HealthKit. For more information, see Accessing condensed workout samples.

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/activeenergyburned

- HealthKit
- HKQuantityTypeIdentifier
- activeEnergyBurned

Type Property

# activeEnergyBurned

A quantity sample type that measures the amount of active energy the user has burned.

static let activeEnergyBurned: HKQuantityTypeIdentifier

## Mentioned in

Accessing condensed workout samples

Dividing a HealthKit workout into activities

Running workout sessions

## Discussion

Active energy is the energy that the user has burned due to physical activity and exercise. These samples should not include the resting energy burned during the sample’s duration. Use the health store’s `splitTotalEnergy(_:start:end:resultsHandler:)` method to split a workout’s total energy burned into the active and resting portions, and then save each portion in its own sample. The system automatically records active energy samples on Apple Watch.

Active energy samples use energy units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`). Sample data may be condensed and/or coalesced by HealthKit. For more information, see Accessing condensed workout samples.

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let flightsClimbed: HKQuantityTypeIdentifier`

A quantity sample type that measures the number flights of stairs that the user has climbed.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/flightsclimbed

- HealthKit
- HKQuantityTypeIdentifier
- flightsClimbed

Type Property

# flightsClimbed

A quantity sample type that measures the number flights of stairs that the user has climbed.

static let flightsClimbed: HKQuantityTypeIdentifier

## Discussion

These samples use count units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`). Flights climbed can be automatically collected by an iPhone, Apple Watch, or Apple Watch connected to a GymKit machine.

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/nikefuel

- HealthKit
- HKQuantityTypeIdentifier
- nikeFuel

Type Property

# nikeFuel

A quantity sample type that measures the number of NikeFuel points the user has earned.

static let nikeFuel: HKQuantityTypeIdentifier

## Discussion

These samples use count units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`).

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/appleexercisetime

- HealthKit
- HKQuantityTypeIdentifier
- appleExerciseTime

Type Property

# appleExerciseTime

A quantity sample type that measures the amount of time the user spent exercising.

static let appleExerciseTime: HKQuantityTypeIdentifier

## Discussion

This quantity type measures every full minute of movement that equals or exceeds the intensity of a brisk walk.

Apple watch automatically records exercise time. By default, the watch uses the accelerometer to estimate the intensity of the user’s movement. However, during workout sessions, the watch uses additional sensors, like the heart rate sensor and GPS, to generate estimates.

`HKWorkoutSession` sessions also contribute to the exercise time. For more information, see Fill the Activity rings.

These samples use time units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`).

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/applemovetime

- HealthKit
- HKQuantityTypeIdentifier
- appleMoveTime

Type Property

# appleMoveTime

A quantity sample type that measures the amount of time the user has spent performing activities that involve full-body movements during the specified day.

static let appleMoveTime: HKQuantityTypeIdentifier

## Discussion

`appleMoveTime` measures every full minute where the watch detects the user actively moving. Apple Watch uses the accelerometer and gyroscopes to detect activities that involve full-body movements, like walking, running, or playing in the playground.

For younger users, HealthKit’s activity summary can track move time instead of active energy burned:

- HealthKit automatically tracks move time for any users under 13 years old.

- Users 13 to 18 years old can choose whether to track move time or active calorie burn.

- All users over 18 years old track active calorie burn.

These samples use time units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`).

## See Also

### Related Documentation

`var activityMoveMode: HKActivityMoveMode`

The move mode that they system used for this activity summary.

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

---

# https://developer.apple.com/documentation/healthkit/hkcategorytypeidentifier/applestandhour

- HealthKit
- HKCategoryTypeIdentifier
- appleStandHour

Type Property

# appleStandHour

A category sample type that counts the number of hours in the day during which the user has stood and moved for at least one minute per hour.

static let appleStandHour: HKCategoryTypeIdentifier

## Discussion

This quantity type counts the number of hours during which the user stood and moved for at least one minute per hour.

If `wheelchairUse()` returns `HKWheelchairUse.yes`, Apple Watch calculates the number of hours during which the user rolled for at least one minute instead. Also, the Activity rings display Roll hours instead of Stand hours.

These samples use values from the `HKCategoryValueAppleStandHour` enumeration. They represent the data tracked by the Stand ring on Apple Watch.

## See Also

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/applestandtime

- HealthKit
- HKQuantityTypeIdentifier
- appleStandTime

Type Property

# appleStandTime

A quantity sample type that measures the amount of time the user has spent standing.

static let appleStandTime: HKQuantityTypeIdentifier

## Discussion

These samples use time units (described in `HKUnit`) and measure cumulative values (described in `HKQuantityAggregationStyle`).

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/vo2max

- HealthKit
- HKQuantityTypeIdentifier
- vo2Max

Type Property

# vo2Max

A quantity sample that measures the maximal oxygen consumption during exercise.

static let vo2Max: HKQuantityTypeIdentifier

## Discussion

VO2max—the maximum amount of oxygen your body can consume during exercise— is a strong predictor of overall health. Clinical tests measure VO2max by having the patient exercise on a treadmill or bike, with an intensity that increases every few minutes until exhaustion.

On Apple Watch Series 3 or later, the system automatically saves `vo2Max` samples to HealthKit. The watch estimates the user’s VO2max based on data gathered while the user is walking or running outdoors. For more information, see Understand Estimated Test Results.

You can also create and save your own `vo2Max` samples—for example, when creating an app that records the results of tests performed in a clinic. When creating `vo2Max` samples, use the `HKMetadataKeyVO2MaxTestType` metadata key to specify the type of test used to generate the sample.

`vo2Max` samples use volume/mass/time units (described in `HKUnit`), measured in ml/kg /min. They measure discrete values (described in `HKQuantityAggregationStyle`).

### Understand Estimated Test Results

Apple Watch Series 3 and later estimates the user’s VO2max by measuring the user’s heart rate response to exercise. The system can generate VO2max samples after an outdoor walk, outdoor run, or hiking workout. During the outdoor activity, the user must cover relatively flat ground (a grade of less than 5% incline or decline) with adequate GPS, heart rate signal quality, and sufficient exertion. The user must maintain a heart rate approximately greater than or equal to 130% of their resting heart rate. The system can estimate VO2max ranges from 14-60 ml/kg/min

The user must wear their Apple Watch for at least one day before the system can generate the first `vo2Max` sample. Additionally, the system doesn’t generate a `vo2Max` sample on the user’s first workout.

Apple Watch estimates _VO2max_ based on sub-maximal predictions rather than _peakVO2_. Users don’t need to achieve peak heart rate to receive an estimate; however, the system does need to estimate their peak heart rate. Users who take medications that may reduce their peak heart rate can toggle a medication switch in the Health app to enable more accurate VO2max estimates.

## Topics

### Metadata Keys

`let HKMetadataKeyVO2MaxTestType: String`

The method used to calculate the user’s VO2 max rate.

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

---

# https://developer.apple.com/documentation/healthkit/hkcategorytypeidentifier/lowcardiofitnessevent

- HealthKit
- HKCategoryTypeIdentifier
- lowCardioFitnessEvent

Type Property

# lowCardioFitnessEvent

An event that indicates the user’s VO2 max values consistently fall below a particular aerobic fitness threshold.

static let lowCardioFitnessEvent: HKCategoryTypeIdentifier

## Discussion

In iOS 14.3 and later, users with a paired Apple Watch running watchOS 7.2 or later can enable a Health app experience that classifies their cardio fitness levels as either “Low”, “Below Average”, “Above Average”, or “High”, based on individual parameters and characteristics.

Apple Watch can notify the user when their cardio fitness level falls into the Low category. If the user enables these notifications, they receive a notification when their VO2 max levels consistently fall below the low threshold for a period of time. The system sends low-cardio fitness notifications approximately once every four months.

The system also creates a `lowCardioFitnessEvent` sample to record the event. The sample contains values from the `HKCategoryValueLowCardioFitnessEvent` enumeration.

Samples of this type have two associated metadata keys:

`HKMetadataKeyVO2MaxValue`

This key stores the value of the VO2 max sample that triggered the event.

`HKMetadataKeyLowCardioFitnessEventThreshold`

This key stores the threshold value used to calculate the Low cardio classification. This value varies based on certain parameters and physical characteristics, such as the user’s age.

Low-cardio fitness event samples are read-only. Use this identifier to request permission to read these samples; however, you can’t request authorization to share them, and you can’t save new low-cardio fitness event samples to the HealthKit store.

## See Also

### Activity

`static let stepCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of steps the user has taken.

`static let distanceWalkingRunning: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by walking or running.

`static let runningSpeed: HKQuantityTypeIdentifier`

A quantity sample type that measures the runner’s speed.

`static let runningStrideLength: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance covered by a single step while running.

`static let runningPower: HKQuantityTypeIdentifier`

A quantity sample type that measures the rate of work required for the runner to maintain their speed.

`static let runningGroundContactTime: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of time the runner’s foot is in contact with the ground while running.

`static let runningVerticalOscillation: HKQuantityTypeIdentifier`

A quantity sample type measuring pelvis vertical range of motion during a single running stride.

`static let distanceCycling: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved by cycling.

`static let pushCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of pushes that the user has performed while using a wheelchair.

`static let distanceWheelchair: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved using a wheelchair.

`static let swimmingStrokeCount: HKQuantityTypeIdentifier`

A quantity sample type that measures the number of strokes performed while swimming.

`static let distanceSwimming: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has moved while swimming.

`static let distanceDownhillSnowSports: HKQuantityTypeIdentifier`

A quantity sample type that measures the distance the user has traveled while skiing or snowboarding.

`static let basalEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the resting energy burned by the user.

`static let activeEnergyBurned: HKQuantityTypeIdentifier`

A quantity sample type that measures the amount of active energy the user has burned.

---

# https://developer.apple.com/documentation/healthkit/hkattachment

- HealthKit
- HKAttachment

Class

# HKAttachment

A file that is attached to a sample in the HealthKit store.

class HKAttachment

## Overview

To access the attachment’s data, get a data reader from the attachment store for each attachment.

let attachmentStore = HKAttachmentStore(healthStore: store)

let attachments: [HKAttachment]
do {
attachments = try await attachmentStore.attachments(for: prescription)
} catch {
// Handle the error here.
fatalError("*** An error occurred while accessing the attachments for a prescription: \(error.localizedDescription) ***")
}

// Use the attachments here.
print("*** \(attachments.count) attachments found ***")

for attachment in attachments {

// Get a data reader for the attachment.
let dataReader = attachmentStore.dataReader(for: attachment)

// Read the data here.
}

You can then asynchronously access the whole data object.

let data: Data
do {
data = try await dataReader.data
} catch {
// Handle the error here.
fatalError("*** An error occurred while accessing the attachment's data. \(error.localizedDescription) ***")
}

Alternatively, you can access the file’s contents as an asynchronous sequence of bytes.

// Asynchronously access the attachment's bytes.
var data = Data()
do {
for try await byte in dataReader.bytes {
// Use the bytes here.
data.append(byte)
}
} catch {
// Handle the error here.
fatalError("*** An error occurred while reading the attachment's data: \(error.localizedDescription) ***")
}

## Topics

### Accessing attachment data

`var name: String`

The name of the attached file.

`var identifier: UUID`

The universally unique identifier for the attached file.

`var contentType: UTType`

The type of data stored in the attached file.

`var size: Int`

The attachment’s size (in bytes).

`var creationDate: Date`

The attachment’s creation date.

[`var metadata: [String : Any]?`](https://developer.apple.com/documentation/healthkit/hkattachment/metadata)

Additional data associated with the attachment in the HealthKit store.

`struct AsyncBytes`

An asynchronous sequence that returns the attached file as a series of bytes.

## Relationships

### Inherits From

- `NSObject`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSCoding`
- `NSCopying`
- `NSObjectProtocol`
- `NSSecureCoding`
- `Sendable`
- `SendableMetatype`

## See Also

### Related Documentation

`class HKVisionPrescription`

A sample that stores a vision prescription.

`class HKGlassesPrescription`

A sample that stores a prescription for glasses.

`class HKContactsPrescription`

A sample that store a prescription for contacts.

### Attachments

`class HKAttachmentStore`

The access point for attachments associated with samples in the HealthKit store.

`class HKAttachmentDataReader`

A reader that provides access to an attachment’s data.

---

# https://developer.apple.com/documentation/healthkit/hkattachmentstore

- HealthKit
- HKAttachmentStore

Class

# HKAttachmentStore

The access point for attachments associated with samples in the HealthKit store.

class HKAttachmentStore

## Overview

Use an `HKAttachmentStore` object to manage attachments for samples that your app has saved to the HealthKit store.

## Topics

### Creating an attachment store

`init(healthStore: HKHealthStore)`

Creates an attachment store for the provided HealthKit store.

### Adding attachments

Asynchronously adds an attachment to the specified object.

Adds an attachment to the specified object.

### Accessing attachments

Returns all the attachments for the specified object.

Returns a data reader for the attachment.

Returns an attachment’s data.

Asynchronously returns the attachment’s data.

### Removing attachments

Removes the specified attachment.

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

### Attachments

`class HKAttachment`

A file that is attached to a sample in the HealthKit store.

`class HKAttachmentDataReader`

A reader that provides access to an attachment’s data.

---

# https://developer.apple.com/documentation/healthkit/hkattachmentdatareader

- HealthKit
- HKAttachmentDataReader

Class

# HKAttachmentDataReader

A reader that provides access to an attachment’s data.

visionOS

class HKAttachmentDataReader

## Overview

To access the attachment’s data, get a data reader from the attachment store.

let attachmentStore = HKAttachmentStore(healthStore: store)

// Get a data reader for the attachment.
let dataReader = attachmentStore.dataReader(for: myAttachment)

You can then asynchronously access the whole data object.

let data: Data
do {
data = try await dataReader.data
} catch {
// Handle the error here.
fatalError("*** An error occurred while accessing the attachment's data. \(error.localizedDescription) ***")
}

Alternatively, you can access the file’s contents as an asynchronous sequence of bytes.

// Asynchronously access the attachment's bytes.
var data = Data()
do {
for try await byte in dataReader.bytes {
// Use the bytes here.
data.append(byte)
}
} catch {
// Handle the error here.
fatalError("*** An error occurred while reading the attachment's data: \(error.localizedDescription) ***")
}

## Topics

### Reading attachment data

`var data: Data`

The abstract’s data.

`var bytes: HKAttachment.AsyncBytes`

An asynchronous sequence that provides the attachment’s data.

`var progress: Progress`

An object you can use to track the progress while reading an attachment’s data.

### Accessing the attachment object

`var attachment: HKAttachment`

An attachment object that represents the file from which the reader is reading.

## See Also

### Attachments

`class HKAttachment`

A file that is attached to a sample in the HealthKit store.

`class HKAttachmentStore`

The access point for attachments associated with samples in the HealthKit store.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/height

- HealthKit
- HKQuantityTypeIdentifier
- height

Type Property

# height

A quantity sample type that measures the user’s height.

static let height: HKQuantityTypeIdentifier

## Mentioned in

Saving data to HealthKit

## Discussion

These samples use length units (described in `HKUnit`) and measure discrete values (described in `HKQuantityAggregationStyle`).

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Body measurements

`static let bodyMass: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s weight.

`static let bodyMassIndex: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body mass index.

`static let leanBodyMass: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s lean body mass.

`static let bodyFatPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body fat percentage.

`static let waistCircumference: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s waist circumference.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/bodymass

- HealthKit
- HKQuantityTypeIdentifier
- bodyMass

Type Property

# bodyMass

A quantity sample type that measures the user’s weight.

static let bodyMass: HKQuantityTypeIdentifier

## Mentioned in

Saving data to HealthKit

## Discussion

These samples use mass units (described in `HKUnit`) and measure discrete values (described in `HKQuantityAggregationStyle`).

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Body measurements

`static let height: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s height.

`static let bodyMassIndex: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body mass index.

`static let leanBodyMass: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s lean body mass.

`static let bodyFatPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body fat percentage.

`static let waistCircumference: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s waist circumference.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/bodymassindex

- HealthKit
- HKQuantityTypeIdentifier
- bodyMassIndex

Type Property

# bodyMassIndex

A quantity sample type that measures the user’s body mass index.

static let bodyMassIndex: HKQuantityTypeIdentifier

## Discussion

These samples use count units (described in `HKUnit`) and measure discrete values (described in `HKQuantityAggregationStyle`).

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Body measurements

`static let height: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s height.

`static let bodyMass: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s weight.

`static let leanBodyMass: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s lean body mass.

`static let bodyFatPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body fat percentage.

`static let waistCircumference: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s waist circumference.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/leanbodymass

- HealthKit
- HKQuantityTypeIdentifier
- leanBodyMass

Type Property

# leanBodyMass

A quantity sample type that measures the user’s lean body mass.

static let leanBodyMass: HKQuantityTypeIdentifier

## Discussion

These samples use mass units (described in `HKUnit`) and measure discrete values (described in `HKQuantityAggregationStyle`).

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Body measurements

`static let height: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s height.

`static let bodyMass: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s weight.

`static let bodyMassIndex: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body mass index.

`static let bodyFatPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body fat percentage.

`static let waistCircumference: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s waist circumference.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/bodyfatpercentage

- HealthKit
- HKQuantityTypeIdentifier
- bodyFatPercentage

Type Property

# bodyFatPercentage

A quantity sample type that measures the user’s body fat percentage.

static let bodyFatPercentage: HKQuantityTypeIdentifier

## Discussion

These samples use percent units (described in `HKUnit`) and measure discrete values (described in `HKQuantityAggregationStyle`).

## See Also

### Related Documentation

`struct HKQuantityTypeIdentifier`

The identifiers that create quantity type objects.

`class HKQuantitySample`

A sample that represents a quantity, including the value and the units.

`class HKQuantity`

An object that stores a value for a given unit.

### Body measurements

`static let height: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s height.

`static let bodyMass: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s weight.

`static let bodyMassIndex: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body mass index.

`static let leanBodyMass: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s lean body mass.

`static let waistCircumference: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s waist circumference.

---

# https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/waistcircumference

- HealthKit
- HKQuantityTypeIdentifier
- waistCircumference

Type Property

# waistCircumference

A quantity sample type that measures the user’s waist circumference.

static let waistCircumference: HKQuantityTypeIdentifier

## Discussion

These samples use length units (described in `HKUnit`) and measure discrete values (described in `HKQuantityAggregationStyle`).

## See Also

### Body measurements

`static let height: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s height.

`static let bodyMass: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s weight.

`static let bodyMassIndex: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body mass index.

`static let leanBodyMass: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s lean body mass.

`static let bodyFatPercentage: HKQuantityTypeIdentifier`

A quantity sample type that measures the user’s body fat percentage.

---

# https://developer.apple.com/documentation/healthkit/hkcategorytypeidentifier/menstrualflow

- HealthKit
- HKCategoryTypeIdentifier
- menstrualFlow

Type Property

# menstrualFlow

A category sample type that records menstrual cycles.

static let menstrualFlow: HKCategoryTypeIdentifier

## Discussion

These samples use values from the `HKCategoryValueMenstrualFlow` enum. Additionally, these samples must include `HKMetadataKeyMenstrualCycleStart` metadata.

When recording data about the user’s menstrual cycle, you can either use a single sample for the entire period, or multiple samples to record changes over the cycle. When using single samples, pass the start of the menstrual period to the `startDate` parameter. Pass the end of the period to the `endDate` parameter, and set the `HKMetadataKeyMenstrualCycleStart` value to `true`.

When using multiple samples to record a single period, the `startDate` and `endDate` parameters should mark the beginning and ending of each individual sample. Set the `HKMetadataKeyMenstrualCycleStart` value for the first sample in the period to `true`. Use `false` for any additional samples. Different samples can use different `menstrualFlow` values to record the changes in flow over time.

## Topics

### Metadata Keys

`let HKMetadataKeyMenstrualCycleStart: String`

A key that indicates whether the sample represents the start of a menstrual cycle. This metadata key is required for `menstrualFlow` category samples.

## See Also

### Related Documentation

`enum HKCategoryValue`

Categories that are undefined.

`struct HKCategoryTypeIdentifier`

Identifiers for creating category types.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCategorySample`

A sample with values from a short list of possible values.

### Reproductive health

`static let intermenstrualBleeding: HKCategoryTypeIdentifier`

A category sample type that records spotting outside the normal menstruation period.

`static let infrequentMenstrualCycles: HKCategoryTypeIdentifier`

A category sample that indicates an infrequent menstrual cycle.

`static let irregularMenstrualCycles: HKCategoryTypeIdentifier`

A category sample that indicates an irregular menstrual cycle.

`static let persistentIntermenstrualBleeding: HKCategoryTypeIdentifier`

A category sample that indicates persistent intermenstrual bleeding.

`static let prolongedMenstrualPeriods: HKCategoryTypeIdentifier`

A category sample that indicates a prolonged menstrual cycle.

`static let basalBodyTemperature: HKQuantityTypeIdentifier`

A quantity sample type that records the user’s basal body temperature.

`static let cervicalMucusQuality: HKCategoryTypeIdentifier`

A category sample type that records the quality of the user’s cervical mucus.

`static let ovulationTestResult: HKCategoryTypeIdentifier`

A category sample type that records the result of an ovulation home test.

`static let progesteroneTestResult: HKCategoryTypeIdentifier`

A category type that represents the results from a home progesterone test.

`static let sexualActivity: HKCategoryTypeIdentifier`

A category sample type that records sexual activity.

`static let contraceptive: HKCategoryTypeIdentifier`

A category sample type that records the use of contraceptives.

`static let pregnancy: HKCategoryTypeIdentifier`

A category type that records pregnancy.

`static let pregnancyTestResult: HKCategoryTypeIdentifier`

A category type that represents the results from a home pregnancy test.

`static let lactation: HKCategoryTypeIdentifier`

A category type that records lactation.

---

# https://developer.apple.com/documentation/healthkit/hkcategorytypeidentifier/intermenstrualbleeding

- HealthKit
- HKCategoryTypeIdentifier
- intermenstrualBleeding

Type Property

# intermenstrualBleeding

A category sample type that records spotting outside the normal menstruation period.

static let intermenstrualBleeding: HKCategoryTypeIdentifier

## Discussion

Use a `HKCategoryValue.notApplicable` value with these samples.

## See Also

### Related Documentation

`enum HKCategoryValue`

Categories that are undefined.

`struct HKCategoryTypeIdentifier`

Identifiers for creating category types.

`class HKCategoryType`

A type that identifies samples that contain a value from a small set of possible values.

`class HKCategorySample`

A sample with values from a short list of possible values.

### Reproductive health

`static let menstrualFlow: HKCategoryTypeIdentifier`

A category sample type that records menstrual cycles.

`static let infrequentMenstrualCycles: HKCategoryTypeIdentifier`

A category sample that indicates an infrequent menstrual cycle.

`static let irregularMenstrualCycles: HKCategoryTypeIdentifier`

A category sample that indicates an irregular menstrual cycle.

`static let persistentIntermenstrualBleeding: HKCategoryTypeIdentifier`

A category sample that indicates persistent intermenstrual bleeding.

`static let prolongedMenstrualPeriods: HKCategoryTypeIdentifier`

A category sample that indicates a prolonged menstrual cycle.

`static let basalBodyTemperature: HKQuantityTypeIdentifier`

A quantity sample type that records the user’s basal body temperature.

`static let cervicalMucusQuality: HKCategoryTypeIdentifier`

A category sample type that records the quality of the user’s cervical mucus.

`static let ovulationTestResult: HKCategoryTypeIdentifier`

A category sample type that records the result of an ovulation home test.

`static let progesteroneTestResult: HKCategoryTypeIdentifier`

A category type that represents the results from a home progesterone test.

`static let sexualActivity: HKCategoryTypeIdentifier`

A category sample type that records sexual activity.

`static let contraceptive: HKCategoryTypeIdentifier`

A category sample type that records the use of contraceptives.

`static let pregnancy: HKCategoryTypeIdentifier`

A category type that records pregnancy.

`static let pregnancyTestResult: HKCategoryTypeIdentifier`

A category type that represents the results from a home pregnancy test.

`static let lactation: HKCategoryTypeIdentifier`

A category type that records lactation.

---

# https://developer.apple.com/documentation/healthkit/hkcategorytypeidentifier/infrequentmenstrualcycles

- HealthKit
- HKCategoryTypeIdentifier
- infrequentMenstrualCycles

Type Property

# infrequentMenstrualCycles

A category sample that indicates an infrequent menstrual cycle.

static let infrequentMenstrualCycles: HKCategoryTypeIdentifier

## Discussion

HealthKit generates Cycle Deviation notifications based on the cycle data a person enters. HealthKit processes this data on their iOS device. If it detects a potential deviation, it sends a notification asking them to verify their logged cycle history. If the person confirms that their cycle history is accurate, HealthKit saves a corresponding sample of the detected Cycle Deviation to the HealthKit store.

Cycle Deviation notifications include:

Persistent spotting

Persistent spotting, also known as irregular intermenstrual bleeding, is defined as spotting that occurs in at least two of your cycles in the last six months. HealthKit records verified instances using `persistentIntermenstrualBleeding` samples.

Prolonged periods

Prolonged periods are defined as menstrual bleeding that lasts for ten or more days, and this has happened at least two times in the last six months. HealthKit records verified instances using `prolongedMenstrualPeriods` samples.

Irregular cycles

An irregular cycle is defined as at least a seventeen-day difference between a person’s shortest and longest cycles over the last six months. HealthKit records verified instances using `irregularMenstrualCycles` samples.

Infrequent periods

An infrequent period is defined as having a period one or two times in the last six months. HealthKit records verified instances using `infrequentMenstrualCycles` samples.

Use a `HKCategoryValue.notApplicable` value with these samples.

## See Also

### Reproductive health

`static let menstrualFlow: HKCategoryTypeIdentifier`

A category sample type that records menstrual cycles.

`static let intermenstrualBleeding: HKCategoryTypeIdentifier`

A category sample type that records spotting outside the normal menstruation period.

`static let irregularMenstrualCycles: HKCategoryTypeIdentifier`

A category sample that indicates an irregular menstrual cycle.

`static let persistentIntermenstrualBleeding: HKCategoryTypeIdentifier`

A category sample that indicates persistent intermenstrual bleeding.

`static let prolongedMenstrualPeriods: HKCategoryTypeIdentifier`

A category sample that indicates a prolonged menstrual cycle.

`static let basalBodyTemperature: HKQuantityTypeIdentifier`

A quantity sample type that records the user’s basal body temperature.

`static let cervicalMucusQuality: HKCategoryTypeIdentifier`

A category sample type that records the quality of the user’s cervical mucus.

`static let ovulationTestResult: HKCategoryTypeIdentifier`

A category sample type that records the result of an ovulation home test.

`static let progesteroneTestResult: HKCategoryTypeIdentifier`

A category type that represents the results from a home progesterone test.

`static let sexualActivity: HKCategoryTypeIdentifier`

A category sample type that records sexual activity.

`static let contraceptive: HKCategoryTypeIdentifier`

A category sample type that records the use of contraceptives.

`static let pregnancy: HKCategoryTypeIdentifier`

A category type that records pregnancy.

`static let pregnancyTestResult: HKCategoryTypeIdentifier`

A category type that represents the results from a home pregnancy test.

`static let lactation: HKCategoryTypeIdentifier`

A category type that records lactation.

---

# https://developer.apple.com/documentation/healthkit/hkcategorytypeidentifier/irregularmenstrualcycles

- HealthKit
- HKCategoryTypeIdentifier
- irregularMenstrualCycles

Type Property

# irregularMenstrualCycles

A category sample that indicates an irregular menstrual cycle.

static let irregularMenstrualCycles: HKCategoryTypeIdentifier

## Discussion

HealthKit generates Cycle Deviation notifications based on the cycle data a person enters. HealthKit processes this data on their iOS device. If it detects a potential deviation, it sends a notification asking them to verify their logged cycle history. If the person confirms that their cycle history is accurate, HealthKit saves a corresponding sample of the detected Cycle Deviation to the HealthKit store.

Cycle Deviation notifications include:

Persistent spotting

Persistent spotting, also known as irregular intermenstrual bleeding, is defined as spotting that occurs in at least two of your cycles in the last six months. HealthKit records verified instances using `persistentIntermenstrualBleeding` samples.

Prolonged periods

Prolonged periods are defined as menstrual bleeding that lasts for ten or more days, and this has happened at least two times in the last six months. HealthKit records verified instances using `prolongedMenstrualPeriods` samples.

Irregular cycles

An irregular cycle is defined as at least a seventeen-day difference between a person’s shortest and longest cycles over the last six months. HealthKit records verified instances using `irregularMenstrualCycles` samples.

Infrequent periods

An infrequent period is defined as having a period one or two times in the last six months. HealthKit records verified instances using `infrequentMenstrualCycles` samples.

Use a `HKCategoryValue.notApplicable` value with these samples.

## See Also

### Reproductive health

`static let menstrualFlow: HKCategoryTypeIdentifier`

A category sample type that records menstrual cycles.

`static let intermenstrualBleeding: HKCategoryTypeIdentifier`

A category sample type that records spotting outside the normal menstruation period.

`static let infrequentMenstrualCycles: HKCategoryTypeIdentifier`

A category sample that indicates an infrequent menstrual cycle.

`static let persistentIntermenstrualBleeding: HKCategoryTypeIdentifier`

A category sample that indicates persistent intermenstrual bleeding.

`static let prolongedMenstrualPeriods: HKCategoryTypeIdentifier`

A category sample that indicates a prolonged menstrual cycle.

`static let basalBodyTemperature: HKQuantityTypeIdentifier`

A quantity sample type that records the user’s basal body temperature.

`static let cervicalMucusQuality: HKCategoryTypeIdentifier`

A category sample type that records the quality of the user’s cervical mucus.

`static let ovulationTestResult: HKCategoryTypeIdentifier`

A category sample type that records the result of an ovulation home test.

`static let progesteroneTestResult: HKCategoryTypeIdentifier`

A category type that represents the results from a home progesterone test.

`static let sexualActivity: HKCategoryTypeIdentifier`

A category sample type that records sexual activity.

`static let contraceptive: HKCategoryTypeIdentifier`

A category sample type that records the use of contraceptives.

`static let pregnancy: HKCategoryTypeIdentifier`

A category type that records pregnancy.

`static let pregnancyTestResult: HKCategoryTypeIdentifier`

A category type that represents the results from a home pregnancy test.

`static let lactation: HKCategoryTypeIdentifier`

A category type that records lactation.

---

