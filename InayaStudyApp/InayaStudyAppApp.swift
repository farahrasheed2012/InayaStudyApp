import SwiftData
import SwiftUI

@main
struct InayaStudyAppApp: App {
    let container: ModelContainer

    @StateObject private var settings = SettingsStore.shared
    @StateObject private var progressStore: ProgressStore
    @StateObject private var rewardsStore = RewardsStore()
    @StateObject private var profileStore = UserProfileStore.shared

    init() {
        let builtContainer: ModelContainer
        do {
            let schema = Schema(SwiftDataSchema.models)
            let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
            builtContainer = try ModelContainer(for: schema, configurations: configuration)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        container = builtContainer
        _progressStore = StateObject(wrappedValue: ProgressStore(modelContext: builtContainer.mainContext))
    }

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
            .modelContainer(container)
            .onAppear {
                SoundEffects.prepare()
            }
            #if targetEnvironment(macCatalyst)
            .frame(minWidth: 560, minHeight: 700)
            #endif
        }
    }
}
