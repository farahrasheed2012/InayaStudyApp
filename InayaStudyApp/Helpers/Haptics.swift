import UIKit

@MainActor
enum Haptics {
    static func tap() {
        guard SettingsStore.shared.hapticsEnabled else { return }
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }

    static func success() {
        guard SettingsStore.shared.hapticsEnabled else { return }
        #if os(iOS)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }

    static func error() {
        guard SettingsStore.shared.hapticsEnabled else { return }
        #if os(iOS)
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        #endif
    }

    static func starEarned() {
        guard SettingsStore.shared.hapticsEnabled else { return }
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        #endif
    }

    static func badgeUnlocked() {
        guard SettingsStore.shared.hapticsEnabled else { return }
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        #endif
    }

    static func unlock() {
        guard SettingsStore.shared.hapticsEnabled else { return }
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        #endif
    }
}
