import SwiftUI

struct RootView: View {
    @EnvironmentObject private var progressStore: ProgressStore
    @EnvironmentObject private var profileStore: UserProfileStore
    @State private var selectedTab: AppTab = .adventure

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                AdventureMapView(onOpenCatchUp: { selectedTab = .catchUp })
            }
            .tabItem { Label(AppTab.adventure.title, systemImage: AppTab.adventure.icon) }
            .tag(AppTab.adventure)

            NavigationStack {
                POTCatchUpMapView()
            }
            .tabItem { Label(AppTab.catchUp.title, systemImage: AppTab.catchUp.icon) }
            .tag(AppTab.catchUp)

            NavigationStack {
                GamesHubView()
            }
            .tabItem { Label(AppTab.games.title, systemImage: AppTab.games.icon) }
            .tag(AppTab.games)

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
    case adventure, catchUp, games, badges, settings
    var id: String { rawValue }
    var title: String {
        switch self {
        case .adventure: return "Adventure"
        case .catchUp: return "Catch-Up"
        case .games: return "Games"
        case .badges: return "Badges"
        case .settings: return "Settings"
        }
    }
    var icon: String {
        switch self {
        case .adventure: return "map.fill"
        case .catchUp: return "calendar.badge.clock"
        case .games: return "gamecontroller.fill"
        case .badges: return "rosette"
        case .settings: return "gearshape.fill"
        }
    }
}

extension GradeLevel: Hashable {}
