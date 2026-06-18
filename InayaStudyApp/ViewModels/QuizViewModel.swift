import Foundation
import SwiftUI

struct AnsweredProblem: Identifiable {
    let id: UUID
    let problem: Problem
    let userAnswer: String
    let isCorrect: Bool
}

@MainActor
final class QuizViewModel: ObservableObject {
    let topic: Topic
    let difficulty: Difficulty
    let questionCount: Int

    @Published private(set) var problems: [Problem] = []
    @Published private(set) var currentIndex = 0
    @Published var userInput = ""
    @Published private(set) var answered: [AnsweredProblem] = []
    @Published private(set) var showingFeedback = false
    @Published private(set) var lastWasCorrect = false
    @Published private(set) var encouragement = ""
    @Published private(set) var selectedAnswer: String?
    @Published var isComplete = false

    private var advanceTask: Task<Void, Never>?

    var currentProblem: Problem? {
        guard currentIndex < problems.count else { return nil }
        return problems[currentIndex]
    }

    var progress: Double {
        guard !problems.isEmpty else { return 0 }
        return Double(currentIndex) / Double(problems.count)
    }

    var score: Int { answered.filter(\.isCorrect).count }

    var accuracy: Double {
        guard !answered.isEmpty else { return 0 }
        return Double(score) / Double(answered.count)
    }

    var stars: Int { Encouragement.stars(for: accuracy) }

    init(topic: Topic, difficulty: Difficulty, questionCount: Int) {
        self.topic = topic
        self.difficulty = difficulty
        self.questionCount = questionCount
        start()
    }

    func start() {
        problems = (0..<questionCount).map { _ in ProblemGenerator.generate(topic: topic, difficulty: difficulty) }
        currentIndex = 0
        answered = []
        showingFeedback = false
        isComplete = false
        userInput = ""
    }

    func submitAnswer(_ answer: String) {
        guard !showingFeedback, let problem = currentProblem else { return }
        let trimmed = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        selectedAnswer = trimmed
        Haptics.tap()
        let correct = ProblemGenerator.isAnswerValid(problem, userAnswer: trimmed)
        lastWasCorrect = correct
        encouragement = correct
            ? Encouragement.random(for: topic.subject)
            : TopicStudyGuide.explanation(for: problem, topic: topic)
        answered.append(AnsweredProblem(id: problem.id, problem: problem, userAnswer: trimmed, isCorrect: correct))
        showingFeedback = true

        if correct {
            SoundEffects.playCorrect()
            Haptics.success()
        } else {
            SoundEffects.playIncorrect()
            Haptics.error()
        }

        advanceTask?.cancel()
        let pause: UInt64 = correct ? 1_500_000_000 : 2_500_000_000
        advanceTask = Task {
            try? await Task.sleep(nanoseconds: pause)
            guard !Task.isCancelled else { return }
            await MainActor.run { self.advance() }
        }
    }

    func submitCurrentInput() {
        submitAnswer(userInput)
    }

    func continueEarly() {
        advanceTask?.cancel()
        advance()
    }

    private func advance() {
        showingFeedback = false
        selectedAnswer = nil
        userInput = ""
        encouragement = ""
        if currentIndex + 1 >= problems.count {
            isComplete = true
        } else {
            currentIndex += 1
        }
    }

    func finish(progressStore: ProgressStore) {
        progressStore.recordSession(
            topic: topic,
            difficulty: difficulty,
            total: answered.count,
            correct: score
        )
    }
}
