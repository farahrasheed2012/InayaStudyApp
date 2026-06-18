import SwiftUI

private struct LifeCyclePuzzle: Identifiable {
    let id = UUID()
    let kind: String
    let stages: [String]

    var prompt: String {
        "Tap the stages in order for a \(kind)."
    }

    static func random() -> (LifeCyclePuzzle, [String]) {
        let puzzles = [
            LifeCyclePuzzle(kind: "butterfly", stages: ["egg", "caterpillar", "chrysalis", "butterfly"]),
            LifeCyclePuzzle(kind: "frog", stages: ["egg", "tadpole", "frog"]),
            LifeCyclePuzzle(kind: "plant", stages: ["seed", "seedling", "plant", "flower"]),
        ]
        let puzzle = puzzles.randomElement()!
        return (puzzle, puzzle.stages.shuffled())
    }
}

struct LifeCycleLineupGameView: View {
    let topic: Topic

    @EnvironmentObject private var profileStore: UserProfileStore

    private let totalRounds = 4

    @State private var round = 1
    @State private var score = 0
    @State private var puzzle: LifeCyclePuzzle
    @State private var shuffledStages: [String]
    @State private var pickedOrder: [String] = []
    @State private var showingFeedback = false
    @State private var lastWasCorrect = false
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Tap stage 1, then 2…"
    @State private var showComplete = false
    @State private var wrongTap = false

    private var accent: Color { TopicAccent(topic: topic).color }

    init(topic: Topic) {
        self.topic = topic
        let initial = LifeCyclePuzzle.random()
        _puzzle = State(initialValue: initial.0)
        _shuffledStages = State(initialValue: initial.1)
    }

    var body: some View {
        Group {
            if showComplete {
                GameCompleteView(
                    topic: topic,
                    score: score,
                    totalRounds: totalRounds,
                    studentName: profileStore.studentName,
                    onPlayAgain: restart
                )
            } else {
                GameShellView(
                    title: "Life Cycle Lineup",
                    topic: topic,
                    round: round,
                    totalRounds: totalRounds,
                    score: score,
                    sparkyMood: sparkyMood,
                    sparkySpeech: sparkySpeech
                ) {
                    VStack(spacing: 16) {
                        VStack(spacing: 12) {
                            Text(puzzle.prompt)
                                .font(AppTypography.question)
                                .multilineTextAlignment(.center)

                            lineupSlots(puzzle: puzzle)

                            Text("Your picks:")
                                .font(AppTypography.caption)
                                .foregroundStyle(.secondary)
                            pickedRow
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .offset(x: wrongTap ? -8 : 0)
                        .animation(.default.repeatCount(3, autoreverses: true), value: wrongTap)

                        if showingFeedback {
                            feedbackCard(puzzle)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(shuffledStages, id: \.self) { stage in
                                    stageButton(stage)
                                }
                            }
                            Button("Reset picks") {
                                pickedOrder = []
                                sparkySpeech = "Start from stage 1."
                            }
                            .font(AppTypography.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                .navigationTitle("Life Cycle Lineup")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
            }
        }
    }

    private func lineupSlots(puzzle: LifeCyclePuzzle) -> some View {
        HStack(spacing: 8) {
            ForEach(0..<puzzle.stages.count, id: \.self) { index in
                VStack(spacing: 4) {
                    Circle()
                        .fill(pickedOrder.count > index ? accent.opacity(0.25) : Color.secondary.opacity(0.12))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text("\(index + 1)")
                                .font(.caption.bold())
                        )
                    Text(pickedOrder.indices.contains(index) ? pickedOrder[index] : "—")
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .frame(width: 72)
                        .lineLimit(2)
                }
            }
        }
    }

    private var pickedRow: some View {
        HStack {
            ForEach(pickedOrder, id: \.self) { stage in
                Text(stage)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(accent.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
    }

    private func stageButton(_ stage: String) -> some View {
        let alreadyPicked = pickedOrder.contains(stage)
        return Button {
            tapStage(stage)
        } label: {
            Text(stage)
                .font(AppTypography.pickerOption)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 56)
                .padding(6)
                .background(alreadyPicked ? Color.secondary.opacity(0.15) : AppTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(accent.opacity(alreadyPicked ? 0.1 : 0.35), lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
        .disabled(alreadyPicked || showingFeedback)
    }

    private func tapStage(_ stage: String) {
        let expected = puzzle.stages[pickedOrder.count]
        if stage == expected {
            pickedOrder.append(stage)
            SoundEffects.playTap()
            Haptics.tap()
            if pickedOrder.count == puzzle.stages.count {
                finishRound(correct: true, puzzle: puzzle)
            } else {
                sparkySpeech = "Now tap stage \(pickedOrder.count + 1)."
            }
        } else {
            wrongTap.toggle()
            pickedOrder = []
            sparkyMood = .encouraging
            sparkySpeech = "Oops — start with \(puzzle.stages[0])."
            SoundEffects.playIncorrect()
            Haptics.tap()
        }
    }

    private func feedbackCard(_ puzzle: LifeCyclePuzzle) -> some View {
        VStack(spacing: 8) {
            Label(lastWasCorrect ? "Perfect order!" : "Try the lineup again", systemImage: lastWasCorrect ? "checkmark.seal.fill" : "arrow.triangle.2.circlepath")
                .font(AppTypography.cardTitle)
                .foregroundStyle(lastWasCorrect ? AppTheme.success : accent)
            LifeCycleView(kind: puzzle.kind, stages: puzzle.stages)
            Button("Next life cycle") { advance() }
                .font(AppTypography.sectionTitle)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .buttonStyle(.plain)
                .padding(.top, 8)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(lastWasCorrect ? AppTheme.success.opacity(0.12) : accent.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func finishRound(correct: Bool, puzzle: LifeCyclePuzzle) {
        lastWasCorrect = correct
        if correct {
            score += 1
            sparkyMood = .celebrating
            sparkySpeech = "Science star!"
            SoundEffects.playCorrect()
            SpeechManager.shared.speakPraise(name: profileStore.studentName, subject: .science)
        }
        withAnimation { showingFeedback = true }
    }

    private func advance() {
        if round >= totalRounds {
            showComplete = true
            return
        }
        round += 1
        pickedOrder = []
        showingFeedback = false
        sparkySpeech = "Tap stage 1, then 2…"
        sparkyMood = .thinking
        loadRound()
    }

    private func loadRound() {
        let next = LifeCyclePuzzle.random()
        puzzle = next.0
        shuffledStages = next.1
        pickedOrder = []
    }

    private func restart() {
        round = 1
        score = 0
        pickedOrder = []
        showingFeedback = false
        showComplete = false
        sparkyMood = .thinking
        sparkySpeech = "Tap stage 1, then 2…"
        loadRound()
    }
}
