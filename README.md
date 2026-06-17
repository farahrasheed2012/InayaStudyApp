# Inaya Study App

A SwiftUI practice app for **Inaya**, aligned to Texas TEKS standards (Round Rock ISD / Canyon Creek Elementary). Problems are generated **on-device** — no network, no PDFs, no question banks.

## Features

- **2nd & 3rd grade math** and **2nd grade science** with TEKS labels
- **Dynamic problem generation** for every topic and difficulty (Easy / Medium / Hard)
- Visual aids: clocks, coins, number lines, arrays, fraction circles, bar graphs, science diagrams
- Progress tracking, streaks, and per-topic accuracy
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
open InayaStudyApp.xcodeproj
```

In Xcode:

1. Select the **InayaStudyApp** scheme.
2. Choose an iOS Simulator or **My Mac (Mac Catalyst)**.
3. **Product → Run** (⌘R).

### Command line

```bash
# iOS Simulator
xcodebuild -project InayaStudyApp.xcodeproj -scheme InayaStudyApp \
  -destination 'platform=iOS Simulator,name=iPhone 17' build

# Mac Catalyst
xcodebuild -project InayaStudyApp.xcodeproj -scheme InayaStudyApp \
  -destination 'platform=macOS,variant=Mac Catalyst' build

# Unit tests
xcodebuild -project InayaStudyApp.xcodeproj -scheme InayaStudyApp \
  -destination 'platform=iOS Simulator,name=iPhone 17' test
```

## Project structure

| Path | Purpose |
|------|---------|
| `InayaStudyApp/Models/Topic.swift` | Subject, grade, topic, and problem models |
| `InayaStudyApp/Data/TopicRegistry.swift` | Math and science TEKS topics |
| `InayaStudyApp/Services/ProblemGenerator.swift` | Runtime math problem generation |
| `InayaStudyApp/Services/ScienceProblemGenerator.swift` | Runtime science problem generation |
| `InayaStudyApp/Views/` | Home, topics, quiz, results, progress, settings |
| `InayaStudyApp/Views/Visuals/` | Clock, coins, number line, science visuals |
| `InayaStudyAppTests/ProblemGeneratorTests.swift` | Generator unit tests |

## For Inaya

Pick Math or Science, choose a topic, set difficulty and question count, then practice at your own pace — **no timers**. Earn up to 3 stars per session!
