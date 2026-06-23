import SwiftUI

/// One-week Math POT 2 catch-up path — all stops unlocked.
struct POTCatchUpMapView: View {
    @EnvironmentObject private var progressStore: ProgressStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerCard

                ForEach(POTCatchUpCatalog.dayPlans) { plan in
                    daySection(plan)
                }
            }
            .contentColumn()
            .padding(.bottom, 32)
        }
        .appScreenBackground(skyTop: "FFB347", skyBottom: "FFF8E1", hillColor: "E17055")
        .navigationTitle("Math POT Catch-Up")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        let mastered = masteredTopicCount
        let total = POTCatchUpCatalog.uniqueTopicIds.count

        return VStack(alignment: .leading, spacing: 8) {
            Label("Math POT 2 · July catch-up week", systemImage: "calendar.badge.clock")
                .font(AppTypography.sectionTitle)
            Text("Practice every topic Inaya missed from Jan–June before joining Math POT 2. Do one day at a time — about 20–30 minutes per topic.")
                .font(AppTypography.body)
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                Label("All 28 POT 2 codes (T032–T059)", systemImage: "checkmark.seal.fill")
                    .font(AppTypography.caption)
                    .foregroundStyle(.orange)
                if total > 0 {
                    Text("\(mastered)/\(total) topics at 60%+")
                        .font(AppTypography.caption)
                        .foregroundStyle(mastered == total ? .green : .secondary)
                }
            }
            Text("POT 1 basics (clocks to 5 min, money, shapes, etc.) are on the Adventure map — not repeated here.")
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .appSurfaceCard()
    }

    private var masteredTopicCount: Int {
        POTCatchUpCatalog.uniqueTopicIds.filter { progressStore.accuracy(for: $0) >= 0.6 }.count
    }

    private func daySection(_ plan: POTCatchUpCatalog.DayPlan) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Day \(plan.day)")
                .font(AppTypography.cardTitle)
            Text(plan.title)
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)

            ForEach(uniqueTopics(for: plan)) { entry in
                topicRow(entry.topic, potCodes: entry.potCodes)
            }
        }
    }

    private struct TopicEntry: Identifiable {
        let topic: Topic
        let potCodes: [String]
        var id: String { topic.id }
    }

    private func uniqueTopics(for plan: POTCatchUpCatalog.DayPlan) -> [TopicEntry] {
        var seen = Set<String>()
        return plan.items.compactMap { item -> TopicEntry? in
            guard seen.insert(item.topicId).inserted,
                  let topic = TopicRegistry.topic(id: item.topicId) else { return nil }
            let codes = POTCatchUpCatalog.potCodes(forTopicId: item.topicId)
                .filter { plan.items.map(\.potCode).contains($0) }
            return TopicEntry(topic: topic, potCodes: codes)
        }
    }

    private func topicRow(_ topic: Topic, potCodes: [String]) -> some View {
        let accent = TopicAccent(topic: topic).color
        let stars = MapProgressHelper.bestStars(for: topic.id, progressStore: progressStore)
        let accuracy = progressStore.accuracy(for: topic.id)

        return NavigationLink {
            TopicActivityHubView(topic: topic)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: topic.icon)
                    .font(.title2)
                    .foregroundStyle(accent)
                    .frame(width: 44, height: 44)
                    .background(accent.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    Text(topic.name)
                        .font(AppTypography.label)
                        .foregroundStyle(.primary)
                    if !potCodes.isEmpty {
                        Text(potCodes.map { $0 == "MIX" ? "All topics" : $0 }.joined(separator: " · "))
                            .font(AppTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                    if accuracy > 0 {
                        Text("\(Int(accuracy * 100))% best accuracy")
                            .font(AppTypography.caption)
                            .foregroundStyle(accuracy >= 0.6 ? .green : .orange)
                    }
                }

                Spacer()

                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: i < stars ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                    }
                }
            }
            .padding()
            .appSurfaceCard()
        }
        .appTappableStyle()
    }
}
