import SwiftUI

struct TopicGridView: View {
    let grade: GradeLevel
    let subject: Subject
    @EnvironmentObject private var progressStore: ProgressStore

    private var topics: [Topic] { TopicRegistry.topics(for: grade, subject: subject) }

    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 16)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(topics) { topic in
                    NavigationLink(value: topic) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: topic.icon)
                                    .font(.title2)
                                    .foregroundStyle(TopicAccent(topic: topic).color)
                                Spacer()
                                AccuracyRingView(accuracy: progressStore.accuracy(for: topic.id))
                            }
                            Text(topic.name)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.primary)
                            Text(topic.teks)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .topicCardStyle(color: TopicAccent(topic: topic).color)
                    }
                    .appTappableStyle()
                }
            }
            .padding()
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("\(grade.rawValue) \(subject.rawValue)")
        .navigationDestination(for: Topic.self) { topic in
            SessionSetupView(topic: topic)
        }
    }
}
