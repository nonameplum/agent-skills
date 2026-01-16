# HealthKit Documentation Skills Guide

## Overview

This folder contains comprehensive HealthKit documentation downloaded from Apple's Developer Documentation website and converted into markdown format. This guide explains how to effectively use this documentation for LLM/Agent consumption.

## Documentation Structure

### File Organization

```
swift-health-kit/
├── SKILLS.md              # This file - usage guide
└── Articles/
    └── healthkit.md       # Main HealthKit documentation (11,210 lines)
```

### Document Format

The `healthkit.md` file contains:

- **Source Information**: Metadata header indicating download date, source URL, and processing details
- **Section Separators**: Sections are separated by `---` markers
- **URL Headers**: Each major section starts with a URL header like:
  ```markdown
  # https://developer.apple.com/documentation/healthkit/[topic-path]
  ```
- **Content Structure**: Each section contains:
  - Breadcrumb navigation
  - Article/Collection/Type Property labels
  - Main heading
  - Overview/Description
  - Detailed content (code examples, discussions, etc.)
  - "See Also" cross-references

## How to Use This Documentation

### 1. Searching for Information

#### By Topic
- **Essentials**: Setup, authorization, privacy, updates
- **Health Data**: Saving/reading data, queries, samples
- **Workout Data**: Workouts, sessions, activity summaries
- **Errors**: Error handling and error codes

#### By Class/Type
Search for specific HealthKit classes or types:
- `HKHealthStore` - Main access point
- `HKQuantitySample` - Numeric health data
- `HKCategorySample` - Categorical health data
- `HKWorkout` - Workout data
- `HKObjectType` - Type definitions

#### By Use Case
- **Setting up HealthKit**: Look for "Setting up HealthKit" section
- **Authorization**: Search for "Authorizing access to health data"
- **Saving data**: Search for "Saving data to HealthKit"
- **Reading data**: Search for "Reading data from HealthKit"

### 2. Navigation Patterns

#### Section Headers
Each major topic starts with a URL header that serves as both:
- A unique identifier for the section
- A link to the original Apple documentation

Example:
```markdown
# https://developer.apple.com/documentation/healthkit/setting-up-healthkit
```

#### Cross-References
The documentation includes "See Also" sections that reference related topics. These appear at the end of major sections.

### 3. Code Examples

The documentation includes Swift code examples showing:
- How to check HealthKit availability
- How to request authorization
- How to create and save samples
- How to query data
- How to handle errors

Look for code blocks marked with Swift syntax highlighting.

### 4. Link Verification

#### External Links
All links in the documentation point to Apple's Developer Documentation:
- Format: `https://developer.apple.com/documentation/healthkit/[path]`
- These are external URLs that require internet access to verify
- The links are preserved from the original documentation

#### Internal References
- No internal markdown anchor links (`[text](#anchor)`) are used
- Cross-references use section headers or "See Also" text
- To navigate internally, search for the section header URL

### 5. Best Practices for LLM/Agent Usage

#### When Answering Questions:
1. **Search First**: Use semantic search to find relevant sections
2. **Read Context**: Read the full section, not just snippets
3. **Check Examples**: Look for code examples that match the use case
4. **Verify Types**: Ensure you're using the correct HealthKit types
5. **Consider Privacy**: Always mention privacy and authorization requirements

#### Common Patterns to Recognize:

**Setup Pattern**:
```swift
// 1. Check availability
guard HKHealthStore.isHealthDataAvailable() else { return }

// 2. Create store
let healthStore = HKHealthStore()

// 3. Request authorization
healthStore.requestAuthorization(...)
```

**Saving Data Pattern**:
```swift
// 1. Create sample
let sample = HKQuantitySample(...)

// 2. Save to store
healthStore.save(sample) { success, error in ... }
```

**Querying Data Pattern**:
```swift
// 1. Create query
let query = HKAnchoredObjectQuery(...)

// 2. Set update handler
query.updateHandler = { ... }

// 3. Execute query
healthStore.execute(query)
```

## Key Topics Covered

### Essentials
- About the HealthKit framework
- Setting up HealthKit
- Authorizing access to health data
- Protecting user privacy
- HealthKit updates
- HealthKitUI

### Health Data
- Saving data to HealthKit
- Reading data from HealthKit
- HKHealthStore class
- Creating a Mobility Health App
- Data types and samples
- Visualizing HealthKit State of Mind in visionOS
- Logging symptoms associated with medications

### Workout Data
- Workout management
- Workout sessions
- Activity summaries

### Errors
- HKError struct
- Error domain and codes
- Error handling patterns

## Link Verification Status

### Verified Link Patterns
✅ All section headers use format: `# https://developer.apple.com/documentation/healthkit/[path]`
✅ External links use format: `[text](https://developer.apple.com/documentation/healthkit/[path])`
✅ Links are preserved from original Apple documentation
✅ All links follow consistent URL structure

### Link Verification Results

**Section Headers (9 major sections found)**:
- `https://developer.apple.com/documentation/healthkit` (main framework)
- `https://developer.apple.com/documentation/healthkit/about-the-healthkit-framework`
- `https://developer.apple.com/documentation/healthkit/setting-up-healthkit`
- `https://developer.apple.com/documentation/healthkit/authorizing-access-to-health-data`
- `https://developer.apple.com/documentation/healthkit/protecting-user-privacy`
- `https://developer.apple.com/documentation/healthkit/saving-data-to-healthkit`
- `https://developer.apple.com/documentation/healthkit/reading-data-from-healthkit`
- `https://developer.apple.com/documentation/healthkit/hkhealthstore`
- `https://developer.apple.com/documentation/healthkit/creating-a-mobility-health-app`

**Markdown Links**: 
- 1 markdown link found: `[var metadata: [String : Any]?](https://developer.apple.com/documentation/healthkit/hkattachment/metadata)`
- All links point to valid Apple Developer Documentation URLs

### Link Verification Notes
- **External Links**: All links point to Apple's Developer Documentation website
- **Format Consistency**: All links follow Apple's documentation URL structure (`https://developer.apple.com/documentation/healthkit/[path]`)
- **No Broken Anchors**: No internal anchor links detected (no `#anchor` references)
- **Verification Method**: Links can be verified by checking the URL format matches Apple's documentation structure
- **Accessibility**: Links require internet access to verify actual accessibility on Apple's website

## Tips for Effective Usage

1. **Start with Overview**: Read the "Overview" section of any topic first
2. **Check Prerequisites**: Look for setup/configuration requirements
3. **Review Examples**: Code examples show real-world usage patterns
4. **Follow See Also**: Use cross-references to find related information
5. **Understand Types**: Pay attention to type hierarchies (HKObject → HKSample → HKQuantitySample)
6. **Consider Threading**: HealthKit is thread-safe; understand concurrency implications
7. **Privacy First**: Always consider privacy and authorization requirements

## Document Metadata

- **Source**: Apple Developer Documentation
- **Download Date**: January 16, 2026
- **Total Pages**: 188 pages processed
- **Content**: Full documentation (not code-only)
- **Deduplication**: Yes
- **Availability Strings**: Filtered

## Related Resources

For the most up-to-date information, always refer to:
- [Apple HealthKit Documentation](https://developer.apple.com/documentation/healthkit)
- [HealthKit Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/healthkit)
- [HealthKit Release Notes](https://developer.apple.com/documentation/healthkit/healthkit_updates)

---

**Note**: This documentation is a snapshot of Apple's HealthKit documentation. For the latest updates, breaking changes, and new APIs, always check Apple's official documentation website.

