import SwiftUI

@main
struct InayaStudyAppApp: App {
    @StateObject private var settings = SettingsStore.shared
    @StateObject private var progressStore = ProgressStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(progressStore)
                .environmentObject(settings)
        }
    }
}
