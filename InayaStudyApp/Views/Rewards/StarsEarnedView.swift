import SwiftUI

struct StarsEarnedView: View {
    @ObservedObject var viewModel: QuizViewModel
    let topic: Topic
    let studentName: String
    var onContinue: () -> Void

    @State private var revealedStars = 0
    @State private var displayedScore = 0
    @State private var showButton = false
    @State private var showReview = false
    @State private var sparkyMood: SparkyMood = .idle

    private var earnedStars: Int { viewModel.stars }
    private var missed: [AnsweredProblem] { viewModel.answered.filter { !$0.isCorrect } }

    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                RadialGradient(
                    colors: [Color.yellow.opacity(0.35), Color.white.opacity(0.05), .clear],
                    center: .center,
                    startRadius: 20,
                    endRadius: 320
                )
                .frame(height: 280)
                .allowsHitTesting(false)

                VStack(spacing: 24) {
                    Text(Encouragement.resultsMessage(stars: earnedStars, subject: topic.subject, name: studentName))
                        .font(AppTypography.sectionTitle)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    CharacterView(mood: sparkyMood, size: 88)

                    HStack(spacing: 16) {
                        ForEach(0..<3, id: \.self) { index in
                            starView(index: index)
                        }
                    }
                    .padding(.vertical, 8)

                    Text("\(displayedScore) / \(viewModel.answered.count) correct")
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .monospacedDigit()

                    Text("\(Int(viewModel.accuracy * 100))% accuracy")
                        .font(AppTypography.bodyEmphasis)
                        .foregroundStyle(.secondary)

                    if !missed.isEmpty {
                    Toggle("Review what to practice", isOn: $showReview)
                        .font(AppTypography.studyBody)
                        .padding(.horizontal)

                        if showReview {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Questions to review")
                                    .font(AppTypography.cardTitle)
                                    .padding(.horizontal)

                                ForEach(missed) { item in
                                    reviewCard(item)
                                }
                            }
                            .transition(.opacity)
                        }
                    }

                    if showButton {
                        Button(action: onContinue) {
                            Text("Continue")
                                .font(AppTypography.cardTitle)
                                .frame(maxWidth: .infinity, minHeight: 56)
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 32)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .fullWidthContent()
        .background(AppTheme.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onAppear { runSequence() }
    }

    private func reviewCard(_ item: AnsweredProblem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.problem.questionText)
                .font(AppTypography.studyBody)
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .top) {
                Text("Your answer: \(item.userAnswer)")
                    .font(AppTypography.quizMeta)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Correct: \(item.problem.correctAnswer)")
                    .font(AppTypography.quizMeta)
                    .foregroundStyle(AppTheme.success)
            }

            Text(TopicStudyGuide.explanation(for: item.problem, topic: topic))
                .quizFeedback()
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
    }

    @ViewBuilder
    private func starView(index: Int) -> some View {
        let earned = index < earnedStars
        let revealed = index < revealedStars
        Image(systemName: earned ? "star.fill" : "star")
            .font(.system(size: 44))
            .foregroundStyle(earned ? Color.yellow : Color.secondary.opacity(0.35))
            .shadow(color: earned && revealed ? .yellow.opacity(0.8) : .clear, radius: 10)
            .scaleEffect(revealed ? 1 : 0.2)
            .offset(y: revealed ? 0 : -120)
            .opacity(revealed ? 1 : 0)
    }

    private func runSequence() {
        sparkyMood = earnedStars >= 3 ? .celebrating : (earnedStars == 2 ? .excited : .encouraging)

        for i in 0..<earnedStars {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.55 + 0.3) {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.55)) {
                    revealedStars = i + 1
                }
                SoundEffects.playStarEarned()
                Haptics.starEarned()
            }
        }

        let target = viewModel.score
        let steps = max(target, 1)
        for step in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8 + Double(step) * 0.08) {
                displayedScore = min(step, target)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.spring()) { showButton = true }
            SpeechManager.shared.speakResults(stars: earnedStars, name: studentName, subject: topic.subject)
        }
    }
}
