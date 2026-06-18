import SwiftUI

struct StarChartView: View {
    @EnvironmentObject private var progressStore: ProgressStore

    @State private var subject: Subject = .math
    @State private var grade: GradeLevel = .second

    private var topics: [Topic] {
        TopicRegistry.topics(for: grade, subject: subject)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                summaryCard

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
                } else {
                    Picker("Grade", selection: $grade) {
                        ForEach(TopicRegistry.grades(for: .science)) { g in
                            Text(g.rawValue).tag(g)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Text("Each topic is a star. Practice to light them up!")
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: 12)], spacing: 14) {
                    ForEach(topics) { topic in
                        starCell(topic)
                    }
                }
            }
            .contentColumn()
            .padding(.vertical, 16)
        }
        .gameScreenCanvas()
        .navigationTitle("Star Chart")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private var summaryCard: some View {
        let s = StarChartHelper.summary(progressStore: progressStore, grade: grade, subject: subject)
        return HStack(spacing: 16) {
            legendItem(level: .gold, count: s.gold)
            legendItem(level: .full, count: s.full)
            legendItem(level: .half, count: s.half)
            legendItem(level: .hollow, count: s.hollow)
        }
        .padding(14)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func legendItem(level: StarChartLevel, count: Int) -> some View {
        VStack(spacing: 4) {
            Image(systemName: level.systemImage)
                .foregroundStyle(level == .gold ? AppTheme.star : (level == .hollow ? .secondary : .yellow))
            Text("\(count)")
                .font(AppTypography.label)
        }
        .frame(maxWidth: .infinity)
    }

    private func starCell(_ topic: Topic) -> some View {
        let level = StarChartHelper.level(for: topic, progressStore: progressStore)
        let accent = AppTheme.color(hex: topic.color)
        return VStack(spacing: 8) {
            Image(systemName: level.systemImage)
                .font(.title2)
                .foregroundStyle(level == .gold ? AppTheme.star : (level == .hollow ? .secondary.opacity(0.4) : .yellow))
            Text(topic.name)
                .font(AppTypography.caption)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .foregroundStyle(level == .hollow ? .secondary : .primary)
        }
        .padding(10)
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(accent.opacity(level == .hollow ? 0.06 : 0.14))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(accent.opacity(level == .hollow ? 0.2 : 0.45), lineWidth: 1.5)
        )
        .accessibilityLabel("\(topic.name), \(level.label)")
    }
}
