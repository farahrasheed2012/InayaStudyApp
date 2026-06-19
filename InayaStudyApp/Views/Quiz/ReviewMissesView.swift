import SwiftUI

struct ReviewMissesView: View {
    let topic: Topic
    let missed: [AnsweredProblem]
    let onFinished: () -> Void

    @State private var reviewIndex = 0

    private var accent: Color { TopicAccent(topic: topic).color }

    var body: some View {
        VStack(spacing: 0) {
            if reviewIndex < missed.count {
                let item = missed[reviewIndex]
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Review Misses")
                            .font(AppTypography.hero)
                        Text("Question \(reviewIndex + 1) of \(missed.count)")
                            .font(AppTypography.caption)
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 16) {
                            Text(item.problem.questionText)
                                .questionText()

                            if let visual = item.problem.visual {
                                ProblemVisualView(visual: visual)
                            }

                            if !item.userAnswer.isEmpty {
                                Label("You chose: \(item.userAnswer)", systemImage: "xmark.circle.fill")
                                    .font(AppTypography.bodyEmphasis)
                                    .foregroundStyle(AppTheme.danger)
                            } else {
                                Label("Time ran out", systemImage: "clock.badge.exclamationmark")
                                    .font(AppTypography.bodyEmphasis)
                                    .foregroundStyle(AppTheme.danger)
                            }

                            Label("Correct answer: \(item.problem.correctAnswer)", systemImage: "checkmark.circle.fill")
                                .font(AppTypography.bodyEmphasis)
                                .foregroundStyle(AppTheme.success)

                            Text(TopicStudyGuide.explanation(for: item.problem, topic: topic))
                                .font(AppTypography.studyBody)
                                .foregroundStyle(.secondary)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                        Button {
                            withAnimation {
                                reviewIndex += 1
                                if reviewIndex >= missed.count {
                                    onFinished()
                                }
                            }
                        } label: {
                            Text("Got it!")
                                .font(AppTypography.sectionTitle)
                                .frame(maxWidth: .infinity, minHeight: 56)
                                .background(accent)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .appTappableStyle()
                    }
                    .padding(20)
                }
            }
        }
        .fullWidthContent()
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Review")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            if missed.isEmpty {
                onFinished()
            }
        }
    }
}
