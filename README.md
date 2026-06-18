# Inaya Study App

A SwiftUI practice app for **Inaya**, aligned to Texas TEKS standards (Round Rock ISD / Canyon Creek Elementary). Problems are generated **on-device** — no network, no PDFs, no question banks.

## Features

- **2nd & 3rd grade math** and **2nd/3rd grade science** with TEKS labels
- **Dynamic problem generation** via `ProblemGenerating` protocol (math + science engines)
- **SwiftData** progress: session history, per-topic accuracy, streaks
- Visual aids with VoiceOver labels (clocks, coins, number lines, arrays, fractions, bar graphs)
- **Review Misses** screen after quizzes with wrong answers
- **Adaptive difficulty nudge** when recent sessions score ≥ 80%
- Optional **Challenge Mode** timed questions (15/30/45 seconds)
- **iPad/Mac NavigationSplitView** sidebar for topic picking; iPhone keeps tab + map flow
- Parent PIN–gated settings (Keychain)
- Mac Catalyst + iOS
- Sound effects, haptics, Sparky voice encouragement, confetti on 3-star sessions

## Requirements

- Xcode 15+
- iOS 17.0+ / macOS 14.0+ (via Mac Catalyst)
- Swift 5.9+

## Build

```bash
cd /path/to/InayaStudyApp
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
| `InayaStudyApp/Protocols/ProblemGenerating.swift` | Generator protocol + factory |
| `InayaStudyApp/Models/SwiftDataModels.swift` | SwiftData persistence models |
| `InayaStudyApp/Services/ProblemGenerator.swift` | Runtime math problem generation |
| `InayaStudyApp/Services/ScienceProblemGenerator.swift` | Runtime science problem generation |
| `InayaStudyApp/Services/ProgressStore.swift` | SwiftData-backed progress service |
| `InayaStudyApp/Views/Quiz/ReviewMissesView.swift` | Post-quiz miss review |
| `InayaStudyApp/Views/StudySplitRootView.swift` | iPad/Mac split navigation |
| `InayaStudyAppTests/` | Generator unit tests |

## For Inaya

Pick Math or Science, choose a topic, study with Sparky, play a mini-game, then practice for stars. Challenge Mode adds a timer if you want an extra challenge!
