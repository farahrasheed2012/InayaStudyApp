import SwiftUI

@main
struct InayaStudyAppApp: App {
    @StateObject private var settings = SettingsStore.shared
    @StateObject private var progressStore = ProgressStore()
    @StateObject private var rewardsStore = RewardsStore()
    @StateObject private var profileStore = UserProfileStore.shared

    var body: some Scene {
        WindowGroup {
            Group {
                if profileStore.hasCompletedOnboarding {
                    RootView()
                } else {
                    OnboardingView(profileStore: profileStore) {
                        // onboarding sets flag internally
                    }
                }
            }
            .environmentObject(progressStore)
            .environmentObject(settings)
            .environmentObject(rewardsStore)
            .environmentObject(profileStore)
            .onAppear {
                SoundEffects.prepare()
            }
            #if targetEnvironment(macCatalyst)
            .frame(minWidth: 560, minHeight: 700)
            #endif
        }
    }
}
