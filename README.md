# MathPath (InayaStudyApp)

A SwiftUI math practice app for **Inaya**, aligned to Texas TEKS standards (Round Rock ISD / Canyon Creek Elementary). Problems are generated **on-device** — no network, no PDFs, no question banks.

## Features

- **2nd & 3rd grade** topics with TEKS labels
- **Dynamic problem generation** for every topic and difficulty (Easy / Medium / Hard)
- Visual aids: clocks, coins, number lines, arrays, fraction circles, bar graphs
- **SwiftData** progress tracking, streaks, and per-topic accuracy
- Parent PIN–gated settings (Keychain)
- **Mac Catalyst** + iOS (iPad portrait/landscape)
- Sound effects, haptics, confetti on 3-star sessions

## Requirements

- Xcode 15+
- iOS 16.0+ / macOS 13.0+ (via Mac Catalyst)
- Swift 5

## Build

```bash
cd /path/to/InayaStudyApp
python3 generate_xcodeproj.py   # if project.pbxproj is missing
open MathPath.xcodeproj
```

In Xcode:

1. Select the **InayaStudyApp** scheme.
2. Choose an iOS Simulator or **My Mac (Mac Catalyst)**.
3. **Product → Run** (⌘R).

### Command line

```bash
# iOS Simulator
xcodebuild -project MathPath.xcodeproj -scheme InayaStudyApp \
  -destination 'platform=iOS Simulator,name=iPhone 16' build

# Mac Catalyst
xcodebuild -project MathPath.xcodeproj -scheme InayaStudyApp \
  -destination 'platform=macOS,variant=Mac Catalyst' build

# Unit tests
xcodebuild -project MathPath.xcodeproj -scheme InayaStudyApp \
  -destination 'platform=iOS Simulator,name=iPhone 16' test
```

## Project structure

| Path | Purpose |
|------|---------|
| `InayaStudyApp/Models/Topic.swift` | Grade, Topic, Problem models |
| `InayaStudyApp/Data/TopicRegistry.swift` | All TEKS topics |
| `InayaStudyApp/Services/ProblemGenerator.swift` | Runtime problem generation |
| `InayaStudyApp/Views/` | Home, topics, quiz, results, progress, settings |
| `InayaStudyApp/Views/Visuals/` | Clock, coins, number line, array, fractions, graphs |
| `MathPathTests/ProblemGeneratorTests.swift` | Generator unit tests |

## For Inaya

Pick a grade, choose a topic, set difficulty and question count, then practice at your own pace — **no timers**. Earn up to 3 stars per session!
