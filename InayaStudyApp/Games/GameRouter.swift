import SwiftUI

enum GameRouter {
    @ViewBuilder
    static func view(for game: AppGameID, grade: Grade) -> some View {
        GamePlayRoot {
            switch game {
            case .numberNinja:
                NumberNinjaGame(grade: grade, onComplete: { _ in })
            case .coinCollector:
                CoinCollectorGame(grade: grade, onComplete: { _ in })
            case .fractionFeast:
                FractionFeastGame(grade: grade, onComplete: { _ in })
            case .timesBingo:
                TimesBingoGame(grade: grade, onComplete: { _ in })
            case .numberLineJump:
                NumberLineJumpGame(grade: grade, onComplete: { _ in })
            case .patternPuzzler:
                PatternPuzzlerGame(grade: grade, onComplete: { _ in })
            case .sortIt:
                SortItGame(grade: grade, onComplete: { _ in })
            case .foodWebBuilder:
                FoodWebBuilderGame(grade: grade, onComplete: { _ in })
            case .weatherWatcher:
                WeatherWatcherGame(grade: grade, onComplete: { _ in })
            case .habitatMatch:
                HabitatMatchGame(grade: grade, onComplete: { _ in })
            case .animalRescue:
                AnimalRescueGame(grade: grade, onComplete: { _ in })
            case .quizShow:
                QuizShowGame(grade: grade, onComplete: { _ in })
            case .dailyChallenge:
                DailyChallengeGame(grade: grade, onComplete: { _ in })
            case .bossBattle:
                BossBattleGame(grade: grade, onComplete: { _ in })
            case .mathDuel:
                MathDuelGame(grade: grade, onComplete: { _ in })
            }
        }
    }
}
