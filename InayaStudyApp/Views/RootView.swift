import SwiftUI

struct RootView: View {
    @EnvironmentObject private var progressStore: ProgressStore
    @EnvironmentObject private var profileStore: UserProfileStore
    @State private var selectedTab: AppTab = .adventure

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                AdventureMapView()
            }
            .tabItem { Label(AppTab.adventure.title, systemImage: AppTab.adventure.icon) }
            .tag(AppTab.adventure)

            NavigationStack {
                ProfileView()
            }
            .tabItem { Label(AppTab.badges.title, systemImage: AppTab.badges.icon) }
            .tag(AppTab.badges)

            NavigationStack {
                SettingsTabView()
            }
            .tabItem { Label(AppTab.settings.title, systemImage: AppTab.settings.icon) }
            .tag(AppTab.settings)
        }
    }
}

enum AppTab: String, CaseIterable, Identifiable {
    case adventure, badges, settings
    var id: String { rawValue }
    var title: String {
        switch self {
        case .adventure: return "Adventure"
        case .badges: return "Badges"
        case .settings: return "Settings"
        }
    }
    var icon: String {
        switch self {
        case .adventure: return "map.fill"
        case .badges: return "rosette"
        case .settings: return "gearshape.fill"
        }
    }
}

extension GradeLevel: Hashable {}
