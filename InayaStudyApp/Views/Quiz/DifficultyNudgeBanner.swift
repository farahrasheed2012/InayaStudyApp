import SwiftUI

struct DifficultyNudgeBanner: View {
    let currentDifficulty: Difficulty
    let nextDifficulty: Difficulty
    let onAccept: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("You're crushing \(currentDifficulty.friendlyLabel)!")
                .font(AppTypography.cardTitle)
            Text("Ready to try \(nextDifficulty.friendlyLabel)?")
                .font(AppTypography.studyBody)
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                Button("Let's go", action: onAccept)
                    .buttonStyle(.borderedProminent)
                Button("Not yet", action: onDismiss)
                    .buttonStyle(.bordered)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
        .padding(.horizontal)
    }
}

enum DifficultyNudgeEvaluator {
    @MainActor
    static func nextDifficulty(after difficulty: Difficulty) -> Difficulty? {
        switch difficulty {
        case .easy: return .medium
        case .medium: return .hard
        case .hard: return nil
        }
    }

    @MainActor
    static func shouldNudge(
        progressStore: ProgressStore,
        subject: Subject,
        difficulty: Difficulty
    ) -> Bool {
        guard let next = nextDifficulty(after: difficulty) else { return false }
        let key = "\(subject.rawValue)_\(difficulty.rawValue)_to_\(next.rawValue)"
        guard !progressStore.hasShownDifficultyNudge(key: key) else { return false }

        let sessions = progressStore.recentSessions(subject: subject, difficulty: difficulty, limit: 3)
        guard sessions.count == 3 else { return false }

        let accuracies = sessions.map { session -> Double in
            guard session.totalQuestions > 0 else { return 0 }
            return Double(session.score) / Double(session.totalQuestions)
        }
        return accuracies.allSatisfy { $0 >= 0.8 }
    }

    static func nudgeKey(subject: Subject, from difficulty: Difficulty, to next: Difficulty) -> String {
        "\(subject.rawValue)_\(difficulty.rawValue)_to_\(next.rawValue)"
    }
}
