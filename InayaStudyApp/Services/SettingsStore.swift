import Foundation
import SwiftUI

@MainActor
final class SettingsStore: ObservableObject {
    static let shared = SettingsStore()

    @AppStorage("soundEffectsEnabled") var soundEffectsEnabled = true
    @AppStorage("voiceGuidanceEnabled") var voiceGuidanceEnabled = true
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("challengeModeEnabled") var challengeModeEnabled = false
    @AppStorage("challengeTimerSeconds") var challengeTimerSeconds = 30
    @AppStorage("defaultDifficulty") private var defaultDifficultyRaw = Difficulty.medium.rawValue
    @AppStorage("defaultQuestionCount") var defaultQuestionCount = 10

    var defaultDifficulty: Difficulty {
        get { Difficulty(rawValue: defaultDifficultyRaw) ?? .medium }
        set { defaultDifficultyRaw = newValue.rawValue }
    }
}
