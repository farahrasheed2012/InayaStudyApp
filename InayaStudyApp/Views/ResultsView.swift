import SwiftUI

struct ResultsView: View {
    @ObservedObject var viewModel: QuizViewModel
    let topic: Topic
    @State private var showReview = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                if viewModel.stars == 3 {
                    ConfettiView()
                        .frame(height: 200)
                }

                VStack(spacing: 20) {
                    Text(Encouragement.resultsMessage(stars: viewModel.stars, subject: topic.subject))
                        .font(.title.bold())
                        .multilineTextAlignment(.center)

                    StarRowView(count: viewModel.stars)

                    Text("\(viewModel.score) of \(viewModel.answered.count) correct")
                        .font(.title2)

                    Text("\(Int(viewModel.accuracy * 100))% accuracy")
                        .font(.body)
                        .foregroundStyle(.secondary)

                    Toggle("Review questions", isOn: $showReview)
                        .padding(.horizontal)

                    if showReview {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.answered) { item in
                                HStack(alignment: .top) {
                                    Image(systemName: item.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundStyle(item.isCorrect ? .green : .red)
                                    VStack(alignment: .leading) {
                                        Text(item.problem.questionText)
                                            .font(.subheadline)
                                        Text("Your answer: \(item.userAnswer)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding(8)
                                .background(AppTheme.card)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.horizontal)
                    }

                    VStack(spacing: 12) {
                        NavigationLink {
                            SessionSetupView(topic: topic)
                        } label: {
                            Text("Play Again")
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(TopicAccent(topic: topic).color)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }

                        Button("Try a Different Topic") {
                            popToTopics()
                        }
                        .font(.headline)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Results")
        .navigationBarBackButtonHidden(true)
    }

    private func popToTopics() {
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { dismiss() }
    }
}
