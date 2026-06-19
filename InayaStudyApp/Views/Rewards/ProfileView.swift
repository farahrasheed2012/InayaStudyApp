import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var progressStore: ProgressStore
    @EnvironmentObject private var rewardsStore: RewardsStore

    @State private var subject: Subject = .math
    @State private var grade: GradeLevel = .second
    @State private var selectedBadge: BadgeRecord?

    private var topics: [Topic] {
        TopicRegistry.topics(for: grade, subject: subject)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                let streak = progressStore.streak()
                HStack(spacing: 16) {
                    statCard(title: "Problems Solved", value: "\(progressStore.totalProblemsSolved())")
                    statCard(title: "Day Streak", value: "\(streak.current)")
                    statCard(title: "Badges", value: "\(rewardsStore.badges.count)")
                }

                Picker("Subject", selection: $subject) {
                    ForEach(Subject.allCases) { s in
                        Text(s.rawValue).tag(s)
                    }
                }
                .pickerStyle(.segmented)

                if subject == .math {
                    Picker("Grade", selection: $grade) {
                        ForEach(TopicRegistry.grades(for: .math)) { g in
                            Text(g.rawValue).tag(g)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Text("Badge Collection")
                    .font(AppTypography.sectionTitle)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 16)], spacing: 16) {
                    ForEach(topics) { topic in
                        badgeCell(for: topic)
                    }
                }
            }
            .padding()
            .contentColumn()
        }
        .appScreenBackground()
        .preferredColorScheme(.light)
        .navigationTitle("Badges")
        .sheet(item: $selectedBadge) { badge in
            if let topic = TopicRegistry.topic(id: badge.topicId) {
                VStack(spacing: 16) {
                    HexBadgeView(topic: topic)
                    Text(topic.name)
                        .font(.title2.bold())
                    Text("Earned \(badge.earnedDate.formatted(date: .abbreviated, time: .omitted))")
                        .foregroundStyle(.secondary)
                    Text("\(Int(badge.accuracy * 100))% accuracy · \(badge.stars) stars")
                    Button("Done") { selectedBadge = nil }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                }
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .appScreenBackground()
                .preferredColorScheme(.light)
                .presentationDetents([.medium])
            }
        }
    }

    private func badgeCell(for topic: Topic) -> some View {
        let earned = rewardsStore.badge(for: topic.id)
        return Button {
            if let record = earned { selectedBadge = record }
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    HexBadgeView(topic: topic, compact: true)
                        .opacity(earned == nil ? 0.35 : 1)
                    if earned == nil {
                        Image(systemName: "lock.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
                Text(topic.name)
                    .font(AppTypography.caption)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundStyle(earned == nil ? .secondary : .primary)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 130)
            .appSurfaceCard(cornerRadius: 18)
        }
        .appTappableStyle()
        .disabled(earned == nil)
    }

    private func statCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(AppTypography.cardTitle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .appSurfaceCard(cornerRadius: 14)
    }
}
