import SwiftUI

struct QuizView: View {
    let topic: Topic
    let difficulty: Difficulty
    let questionCount: Int

    @EnvironmentObject private var progressStore: ProgressStore
    @StateObject private var viewModel: QuizViewModel
    @State private var showResults = false
    @State private var bounce = false
    @Environment(\.dismiss) private var dismiss

    init(topic: Topic, difficulty: Difficulty, questionCount: Int) {
        self.topic = topic
        self.difficulty = difficulty
        self.questionCount = questionCount
        _viewModel = StateObject(wrappedValue: QuizViewModel(topic: topic, difficulty: difficulty, questionCount: questionCount))
    }

    var body: some View {
        VStack(spacing: 16) {
            ProgressView(value: viewModel.progress)
                .tint(TopicAccent(topic: topic).color)
                .padding(.horizontal)

            if let problem = viewModel.currentProblem {
                ScrollView {
                    VStack(spacing: 20) {
                        if let visual = problem.visual {
                            ProblemVisualView(visual: visual)
                        }

                        Text(problem.questionText)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .largeReadable()

                        if viewModel.showingFeedback {
                            feedbackView(for: problem)
                        } else {
                            answerArea(for: problem)
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Question \(min(viewModel.currentIndex + 1, questionCount)) of \(questionCount)")
        .navigationBarBackButtonHidden(viewModel.currentIndex > 0 || viewModel.showingFeedback)
        .onChange(of: viewModel.isComplete) { complete in
            if complete {
                viewModel.finish(progressStore: progressStore)
                showResults = true
            }
        }
        .navigationDestination(isPresented: $showResults) {
            ResultsView(viewModel: viewModel, topic: topic)
        }
        #if targetEnvironment(macCatalyst)
        .quizKeyboardShortcuts(viewModel: viewModel)
        #endif
    }

    @ViewBuilder
    private func answerArea(for problem: Problem) -> some View {
        switch problem.answerType {
        case .multipleChoice:
            VStack(spacing: 12) {
                ForEach(Array((problem.choices ?? []).enumerated()), id: \.offset) { index, choice in
                    let label = ["A", "B", "C", "D"][min(index, 3)]
                    Button {
                        viewModel.submitAnswer(choice)
                    } label: {
                        HStack {
                            Text(label).bold()
                            Text(choice)
                            Spacer()
                        }
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)

        case .numberEntry:
            NumericKeypadView(text: $viewModel.userInput) {
                viewModel.submitCurrentInput()
            }
            .padding(.horizontal)

        case .tapSelection:
            let options = problem.tapOptions ?? problem.choices ?? []
            HStack(spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        viewModel.submitAnswer(option)
                    }
                    .font(.title2.bold())
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(TopicAccent(topic: topic).color.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func feedbackView(for problem: Problem) -> some View {
        VStack(spacing: 16) {
            Image(systemName: viewModel.lastWasCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(viewModel.lastWasCorrect ? AppTheme.success : AppTheme.danger)
                .scaleEffect(bounce ? 1.15 : 1)
                .onAppear {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { bounce = true }
                }

            Text(viewModel.encouragement)
                .font(.title3.bold())
                .multilineTextAlignment(.center)

            if !viewModel.lastWasCorrect {
                Text("Correct answer: \(problem.correctAnswer)")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            Button("Continue") { viewModel.continueEarly() }
                .font(.headline)
                .padding(.top, 8)
        }
        .padding()
    }
}
