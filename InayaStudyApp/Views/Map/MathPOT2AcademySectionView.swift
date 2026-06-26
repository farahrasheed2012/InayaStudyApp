import SwiftUI

/// Dedicated Math POT Level 2 block on the Adventure map — all topics unlocked for catch-up.
struct MathPOT2AcademySectionView: View {
    var onOpenCatchUp: (() -> Void)?

    @EnvironmentObject private var progressStore: ProgressStore
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private let topics = TopicRegistry.mathPOT2Topics

    private var masteredCount: Int {
        topics.filter { progressStore.accuracy(for: $0.id) >= MapProgressHelper.unlockAccuracy }.count
    }

    private var columns: [GridItem] {
        let minWidth: CGFloat = horizontalSizeClass == .regular ? 220 : 160
        return [GridItem(.adaptive(minimum: minWidth), spacing: 12)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerCard

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(topics) { topic in
                    topicTile(topic)
                }
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.orange.opacity(0.18), Color.yellow.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.orange.opacity(0.45), lineWidth: 2)
        )
        .shadow(color: Color.orange.opacity(0.12), radius: 12, y: 6)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Text("🎓")
                    .font(.system(size: 40))
                VStack(alignment: .leading, spacing: 4) {
                    Text("Math POT 2 Academy")
                        .font(AppTypography.sectionTitle)
                    Text("28 topics · T032–T059 · grades 2–3")
                        .font(AppTypography.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            Text("Everything Inaya needs before joining Math POT 2 class. Every topic is open — no locks.")
                .font(AppTypography.body)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Label("\(masteredCount)/\(topics.count) ready", systemImage: "checkmark.seal.fill")
                    .font(AppTypography.caption.weight(.semibold))
                    .foregroundStyle(masteredCount == topics.count ? .green : .orange)

                Spacer()

                if let onOpenCatchUp {
                    Button {
                        onOpenCatchUp()
                        Haptics.tap()
                    } label: {
                        Label("7-Day Plan", systemImage: "calendar.badge.clock")
                            .font(AppTypography.caption.weight(.semibold))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
            }

            ProgressView(value: Double(masteredCount), total: Double(max(topics.count, 1)))
                .tint(.orange)
        }
    }

    private func topicTile(_ topic: Topic) -> some View {
        let accent = TopicAccent(topic: topic).color
        let accuracy = progressStore.accuracy(for: topic.id)
        let stars = MapProgressHelper.bestStars(for: topic.id, progressStore: progressStore)

        return NavigationLink {
            TopicActivityHubView(topic: topic)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: topic.icon)
                        .font(.title3)
                        .foregroundStyle(accent)
                        .frame(width: 36, height: 36)
                        .background(accent.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Spacer()
                    HStack(spacing: 2) {
                        ForEach(0..<3, id: \.self) { i in
                            Image(systemName: i < stars ? "star.fill" : "star")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                        }
                    }
                }

                Text(topic.name)
                    .font(AppTypography.label)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    POT2TopicBadge(topic: topic)
                    Spacer()
                    if accuracy > 0 {
                        Text("\(Int(accuracy * 100))%")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(accuracy >= MapProgressHelper.unlockAccuracy ? .green : .orange)
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(accent.opacity(0.25), lineWidth: 1)
            )
        }
        .appTappableStyle()
    }
}
