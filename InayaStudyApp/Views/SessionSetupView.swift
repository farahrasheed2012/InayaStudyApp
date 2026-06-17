import SwiftUI

struct SessionSetupView: View {
    let topic: Topic
    @State private var difficulty: Difficulty = SettingsStore.shared.defaultDifficulty
    @State private var questionCount = SettingsStore.shared.defaultQuestionCount
    @State private var startQuiz = false

    private let counts = [5, 10, 20]

    var body: some View {
        Form {
            Section("Difficulty") {
                Picker("Difficulty", selection: $difficulty) {
                    ForEach(Difficulty.allCases) { d in
                        Text(d.friendlyLabel).tag(d)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("How many questions?") {
                Picker("Count", selection: $questionCount) {
                    ForEach(counts, id: \.self) { n in
                        Text("\(n)").tag(n)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section {
                Button {
                    startQuiz = true
                } label: {
                    Text("Start Practice")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle(topic.name)
        .navigationDestination(isPresented: $startQuiz) {
            QuizView(topic: topic, difficulty: difficulty, questionCount: questionCount)
        }
    }
}
