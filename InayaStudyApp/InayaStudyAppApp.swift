import SwiftData
import SwiftUI

@main
struct InayaStudyAppApp: App {
    let container: ModelContainer

    @StateObject private var settings = SettingsStore.shared
    @StateObject private var progressStore: ProgressStore
    @StateObject private var gameStore: GameSessionStore
    @StateObject private var builderStore: BuilderStore
    @StateObject private var rewardsStore = RewardsStore()
    @StateObject private var profileStore = UserProfileStore.shared

    init() {
        let builtContainer: ModelContainer
        if let container = try? SwiftDataStoreFactory.makeContainer() {
            builtContainer = container
        } else if let fallback = try? ModelContainer(
            for: Schema(SwiftDataSchema.models),
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        ) {
            assertionFailure("SwiftData persistent store unavailable; using in-memory fallback.")
            builtContainer = fallback
        } else {
            fatalError("SwiftData models could not be loaded.")
        }
        container = builtContainer
        let context = builtContainer.mainContext
        _progressStore = StateObject(wrappedValue: ProgressStore(modelContext: context))
        _gameStore = StateObject(wrappedValue: GameSessionStore(modelContext: context))
        _builderStore = StateObject(wrappedValue: BuilderStore(modelContext: context))
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
            .environmentObject(gameStore)
            .environmentObject(builderStore)
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
