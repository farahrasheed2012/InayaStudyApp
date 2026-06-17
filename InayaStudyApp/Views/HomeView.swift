import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var progressStore: ProgressStore
    @Binding var selectedSubject: Subject
    @Binding var selectedGrade: GradeLevel?
    @Binding var selectedTab: AppTab

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Hi, Inaya! 👋")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .padding(.top, 8)

                Text(subtitleText)
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Picker("Subject", selection: $selectedSubject) {
                    ForEach(Subject.allCases) { subject in
                        Text(subject.rawValue).tag(subject)
                    }
                }
                .pickerStyle(.segmented)

                if selectedSubject == .science {
                    scienceCard
                }

                VStack(spacing: 16) {
                    ForEach(availableGrades, id: \.self) { grade in
                        gradeCard(grade, subtitle: gradeSubtitle(grade))
                    }
                }

                if !recentTopics.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Keep Going!")
                            .font(.title2.bold())
                        ForEach(recentTopics) { topic in
                            HStack {
                                Image(systemName: topic.icon)
                                    .foregroundStyle(TopicAccent(topic: topic).color)
                                Text(topic.name)
                                    .font(.body)
                                Spacer()
                                streakDots(for: topic.id)
                            }
                            .padding()
                            .background(AppTheme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
            .padding()
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("MathPath")
        .onChange(of: selectedSubject) { _ in
            selectedGrade = nil
        }
    }

    private var subtitleText: String {
        selectedSubject == .math
            ? "Let's practice math together."
            : "Let's explore science together."
    }

    private var availableGrades: [GradeLevel] {
        TopicRegistry.grades(for: selectedSubject)
    }

    private var recentTopics: [Topic] {
        progressStore.recentTopicIDs()
            .compactMap { TopicRegistry.topic(id: $0) }
            .filter { $0.subject == selectedSubject }
            .prefix(3)
            .map { $0 }
    }

    private var scienceCard: some View {
        Button {
            selectedSubject = .science
            selectedGrade = .second
        } label: {
            HStack {
                Image(systemName: "atom")
                    .font(.largeTitle)
                    .foregroundStyle(Color.orange)
                VStack(alignment: .leading, spacing: 4) {
                    Text("2nd Grade Science")
                        .font(.title2.bold())
                    Text("Matter, plants, animals & more")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .topicCardStyle(color: .orange)
        }
        .buttonStyle(.plain)
    }

    private func gradeSubtitle(_ grade: GradeLevel) -> String {
        switch (selectedSubject, grade) {
        case (.math, .second): return "Place value, coins, time & more"
        case (.math, .third): return "Multiplication, fractions, STAAR prep"
        case (.science, .second): return "Matter, energy, life cycles & habitats"
        default: return ""
        }
    }

    private func gradeCard(_ grade: GradeLevel, subtitle: String) -> some View {
        Button {
            selectedGrade = grade
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(grade.rawValue) \(selectedSubject.rawValue)")
                    .font(.title.bold())
                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .topicCardStyle(color: cardColor(for: grade))
        }
        .buttonStyle(.plain)
    }

    private func cardColor(for grade: GradeLevel) -> Color {
        switch (selectedSubject, grade) {
        case (.math, .second): return .blue
        case (.math, .third): return .purple
        case (.science, _): return .orange
        default: return .accentColor
        }
    }

    private func streakDots(for topicId: String) -> some View {
        let acc = progressStore.accuracy(for: topicId)
        let filled = min(3, Int(acc * 3) + 1)
        return HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(i < filled ? Color.green : Color.secondary.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

enum AppTab: String, CaseIterable, Identifiable {
    case home, progress, settings
    var id: String { rawValue }
    var title: String {
        switch self {
        case .home: return "Home"
        case .progress: return "Progress"
        case .settings: return "Settings"
        }
    }
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .progress: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

extension Subject: Hashable {}
