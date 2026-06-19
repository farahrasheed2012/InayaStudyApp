import SwiftUI

struct SessionSetupView: View {
    let topic: Topic
    @Environment(\.dismiss) private var dismiss
    @State private var difficulty: Difficulty = SettingsStore.shared.defaultDifficulty
    @State private var questionCount = SettingsStore.shared.defaultQuestionCount
    @State private var startQuiz = false

    private let counts = [5, 10, 20]
    private var accent: Color { TopicAccent(topic: topic).color }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                NavigationLink {
                    StudyWithSparkyView(topic: topic)
                } label: {
                    HStack(spacing: 16) {
                        Image(systemName: "book.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(accent)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Study with Sparky first")
                                .font(AppTypography.sectionTitle)
                                .foregroundStyle(.primary)
                            Text("Learn the topic before you quiz")
                                .font(AppTypography.studyBody)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(AppTypography.label)
                            .foregroundStyle(.secondary)
                    }
                    .padding(20)
                    .background(AppTheme.card)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(accent.opacity(0.35), lineWidth: 2)
                    )
                }
                .appTappableStyle()

                setupSection(title: "Difficulty") {
                    VStack(spacing: 12) {
                        ForEach(Difficulty.allCases) { level in
                            setupOption(
                                title: level.friendlyLabel,
                                isSelected: difficulty == level,
                                accent: accent
                            ) {
                                difficulty = level
                                Haptics.tap()
                            }
                        }
                    }
                }

                setupSection(title: "How many questions?") {
                    HStack(spacing: 12) {
                        ForEach(counts, id: \.self) { count in
                            setupOption(
                                title: "\(count)",
                                isSelected: questionCount == count,
                                accent: accent,
                                compact: true
                            ) {
                                questionCount = count
                                Haptics.tap()
                            }
                        }
                    }
                }

                Button {
                    startQuiz = true
                } label: {
                    Text("Start Practice")
                        .font(AppTypography.sectionTitle)
                        .frame(maxWidth: .infinity, minHeight: 64)
                        .background(accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .appTappableStyle()
                .padding(.top, 4)
            }
            .padding(20)
        }
        .fullWidthContent()
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle(topic.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationDestination(isPresented: $startQuiz) {
            QuizView(topic: topic, difficulty: difficulty, questionCount: questionCount)
        }
        .onReceive(NotificationCenter.default.publisher(for: .quizSessionCompletePop)) { _ in
            startQuiz = false
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                NotificationCenter.default.post(name: .topicHubPop, object: nil)
            }
        }
    }

    private func setupSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(AppTypography.sectionTitle)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func setupOption(
        title: String,
        isSelected: Bool,
        accent: Color,
        compact: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.pickerOption)
                .multilineTextAlignment(.center)
                .lineLimit(compact ? 1 : 2)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity, minHeight: compact ? 64 : 58)
                .padding(.horizontal, compact ? 8 : 16)
                .padding(.vertical, 12)
                .background(isSelected ? accent.opacity(0.2) : AppTheme.card)
                .foregroundStyle(isSelected ? accent : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? accent : Color.secondary.opacity(0.25), lineWidth: isSelected ? 2.5 : 1)
                )
        }
        .appTappableStyle()
    }
}
