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
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        #endif
    }
}
