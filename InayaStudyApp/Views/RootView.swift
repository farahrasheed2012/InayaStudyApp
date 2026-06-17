import SwiftUI

struct RootView: View {
    @EnvironmentObject private var progressStore: ProgressStore
    @State private var selectedSubject: Subject = .math
    @State private var selectedGrade: GradeLevel?
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                homeStack
            }
            .tabItem { Label(AppTab.home.title, systemImage: AppTab.home.icon) }
            .tag(AppTab.home)

            NavigationStack {
                StudentProgressView()
            }
            .tabItem { Label(AppTab.progress.title, systemImage: AppTab.progress.icon) }
            .tag(AppTab.progress)

            NavigationStack {
                SettingsTabView()
            }
            .tabItem { Label(AppTab.settings.title, systemImage: AppTab.settings.icon) }
            .tag(AppTab.settings)
        }
    }

    @ViewBuilder
    private var homeStack: some View {
        if let grade = selectedGrade {
            TopicGridView(grade: grade, subject: selectedSubject)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back") {
                            selectedGrade = nil
                        }
                    }
                }
        } else {
            HomeView(
                selectedSubject: $selectedSubject,
                selectedGrade: $selectedGrade,
                selectedTab: $selectedTab
            )
        }
    }
}

extension GradeLevel: Hashable {}
