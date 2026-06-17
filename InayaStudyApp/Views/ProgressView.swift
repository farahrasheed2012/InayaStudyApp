import SwiftUI

struct StudentProgressView: View {
    @EnvironmentObject private var progressStore: ProgressStore
    @State private var subject: Subject = .math
    @State private var grade: GradeLevel = .second

    private var availableGrades: [GradeLevel] {
        TopicRegistry.grades(for: subject)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                let streak = progressStore.streak()
                HStack(spacing: 16) {
                    statCard(title: "Problems Solved", value: "\(progressStore.totalProblemsSolved())")
                    statCard(title: "Day Streak", value: "\(streak.current)")
                }

                Picker("Subject", selection: $subject) {
                    ForEach(Subject.allCases) { s in
                        Text(s.rawValue).tag(s)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: subject) { newSubject in
                    if !TopicRegistry.grades(for: newSubject).contains(grade) {
                        grade = .second
                    }
                }

                Picker("Grade", selection: $grade) {
                    ForEach(availableGrades) { g in
                        Text(g.rawValue).tag(g)
                    }
                }
                .pickerStyle(.segmented)

                let topics = TopicRegistry.topics(for: grade, subject: subject)
                let pair = progressStore.strongestAndWeakest(in: topics)

                if let strongest = pair.strongest {
                    callout(title: "Strongest topic", topic: strongest, color: subject == .science ? .orange : .green)
                }
                if let weakest = pair.weakest, weakest.id != pair.strongest?.id {
                    callout(title: "Keep practicing", topic: weakest, color: .orange)
                }

                Text("Topic Accuracy")
                    .font(.title2.bold())

                ForEach(topics) { topic in
                    let acc = progressStore.accuracy(for: topic.id)
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(topic.name)
                                .font(.headline)
                            Spacer()
                            Text(acc > 0 ? "\(Int(acc * 100))%" : "—")
                                .foregroundStyle(.secondary)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.secondary.opacity(0.15))
                                Capsule()
                                    .fill(TopicAccent(topic: topic).color)
                                    .frame(width: geo.size.width * acc)
                            }
                        }
                        .frame(height: 10)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Progress")
    }

    private func statCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func callout(title: String, topic: Topic, color: Color) -> some View {
        HStack {
            Image(systemName: topic.icon)
                .foregroundStyle(color)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(topic.name)
                    .font(.headline)
            }
            Spacer()
        }
        .padding()
        .background(color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
