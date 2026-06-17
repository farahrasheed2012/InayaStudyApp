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
                    .font(.title2.bold())

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 16)], spacing: 16) {
                    ForEach(topics) { topic in
                        badgeCell(for: topic)
                    }
                }
            }
            .padding()
            .frame(maxWidth: 430)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.background.ignoresSafeArea())
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
                        .padding(.top)
                }
                .padding()
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
                    HexBadgeView(topic: topic)
                        .opacity(earned == nil ? 0.25 : 1)
                    if earned == nil {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(.secondary)
                    }
                }
                Text(topic.name)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundStyle(earned == nil ? .secondary : .primary)
            }
        }
        .buttonStyle(.plain)
        .disabled(earned == nil)
    }

    private func statCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
