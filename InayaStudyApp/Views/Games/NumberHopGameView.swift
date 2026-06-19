import SwiftUI

private struct HopChallenge: Identifiable {
    let id = UUID()
    let start: Int
    let step: Int
    let hops: Int

    var answer: Int { start + step * hops }

    var prompt: String {
        "Start at \(start). Hop by \(step)s, \(hops) times. Where do you land?"
    }

    func choices() -> [String] {
        let correct = answer
        var wrong = Set<Int>()
        while wrong.count < 3 {
            let offset = [-step, step, -step * 2, step * 2, -1, 1].randomElement()!
            let candidate = correct + offset
            if candidate >= 0, candidate != correct {
                wrong.insert(candidate)
            }
        }
        return (wrong.map(String.init) + [String(correct)]).shuffled()
    }

    static func random() -> (HopChallenge, [String]) {
        let step = [2, 5, 10].randomElement()!
        let hops = Int.random(in: 2...4)
        let start = Int.random(in: 0...(step * 4))
        let challenge = HopChallenge(start: start, step: step, hops: hops)
        return (challenge, challenge.choices())
    }
}

struct NumberHopGameView: View {
    let topic: Topic

    @EnvironmentObject private var profileStore: UserProfileStore

    private let totalRounds = 5

    @State private var round = 1
    @State private var score = 0
    @State private var challenge: HopChallenge
    @State private var choices: [String]
    @State private var showingFeedback = false
    @State private var lastWasCorrect = false
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Pick where you land!"
    @State private var showComplete = false
    @State private var hopPulse = 0

    private var accent: Color { TopicAccent(topic: topic).color }

    init(topic: Topic) {
        self.topic = topic
        let initial = HopChallenge.random()
        _challenge = State(initialValue: initial.0)
        _choices = State(initialValue: initial.1)
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
                    title: "Number Hop",
                    topic: topic,
                    round: round,
                    totalRounds: totalRounds,
                    score: score,
                    sparkyMood: sparkyMood,
                    sparkySpeech: sparkySpeech
                ) {
                    VStack(spacing: 16) {
                        VStack(spacing: 16) {
                            Text(challenge.prompt)
                                .font(AppTypography.question)
                                .multilineTextAlignment(.center)

                            NumberLineView(
                                min: max(0, challenge.start - challenge.step),
                                max: challenge.answer + challenge.step * 2,
                                marked: [challenge.start]
                            )
                            .frame(height: 90)

                            HStack(spacing: 8) {
                                ForEach(0..<challenge.hops, id: \.self) { hop in
                                    Image(systemName: "figure.walk")
                                        .font(.title2)
                                        .foregroundStyle(hop < hopPulse ? accent : .secondary.opacity(0.3))
                                        .scaleEffect(hop < hopPulse ? 1.15 : 1)
                                }
                            }
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                        if showingFeedback {
                            feedbackCard(challenge)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                                ForEach(Array(choices.enumerated()), id: \.offset) { index, choice in
                                    Button {
                                        submit(choice, challenge: challenge)
                                    } label: {
                                        Text(choice)
                                            .font(AppTypography.answer)
                                            .frame(maxWidth: .infinity, minHeight: 64)
                                            .background(AppTheme.card)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(accent.opacity(0.35), lineWidth: 2)
                                            )
                                    }
                                    .appTappableStyle()
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Number Hop")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .onAppear { animateHops(challenge) }
            }
        }
    }

    private func animateHops(_ challenge: HopChallenge) {
        hopPulse = 0
        for hop in 0..<challenge.hops {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(hop + 1) * 0.45) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    hopPulse = hop + 1
                }
                SoundEffects.playTap()
            }
        }
    }

    private func feedbackCard(_ challenge: HopChallenge) -> some View {
        VStack(spacing: 8) {
            Label(lastWasCorrect ? "Great hop!" : "Hop again!", systemImage: lastWasCorrect ? "figure.walk.circle.fill" : "arrow.counterclockwise")
                .font(AppTypography.cardTitle)
                .foregroundStyle(lastWasCorrect ? AppTheme.success : accent)
            if !lastWasCorrect {
                Text("You land on \(challenge.answer)")
                    .font(AppTypography.bodyEmphasis)
            }
            Button("Next hop") { advance() }
                .font(AppTypography.sectionTitle)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .appTappableStyle()
                .padding(.top, 8)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(lastWasCorrect ? AppTheme.success.opacity(0.12) : accent.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func submit(_ answer: String, challenge: HopChallenge) {
        guard !showingFeedback else { return }
        lastWasCorrect = answer == String(challenge.answer)
        if lastWasCorrect {
            score += 1
            sparkyMood = .excited
            sparkySpeech = "You hopped it!"
            SoundEffects.playCorrect()
            SpeechManager.shared.speakPraise(name: profileStore.studentName, subject: .math)
        } else {
            sparkyMood = .encouraging
            sparkySpeech = "Count each hop by \(challenge.step)."
            SoundEffects.playIncorrect()
        }
        Haptics.tap()
        withAnimation { showingFeedback = true }
    }

    private func advance() {
        if round >= totalRounds {
            showComplete = true
            return
        }
        round += 1
        showingFeedback = false
        sparkySpeech = "Pick where you land!"
        sparkyMood = .thinking
        loadRound()
    }

    private func loadRound() {
        let next = HopChallenge.random()
        challenge = next.0
        choices = next.1
    }

    private func restart() {
        round = 1
        score = 0
        showingFeedback = false
        showComplete = false
        sparkyMood = .thinking
        sparkySpeech = "Pick where you land!"
        loadRound()
    }
}
