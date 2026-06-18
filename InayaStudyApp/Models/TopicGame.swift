import Foundation
import SwiftUI

enum TopicGameKind: String, CaseIterable, Identifiable, Hashable {
    case sparkyMatch
    case coinCounter
    case numberHop
    case lifeCycleLineup

    var id: String { rawValue }

    var title: String {
        switch self {
        case .sparkyMatch: return "Sparky Match"
        case .coinCounter: return "Coin Counter"
        case .numberHop: return "Number Hop"
        case .lifeCycleLineup: return "Life Cycle Lineup"
        }
    }

    var subtitle: String {
        switch self {
        case .sparkyMatch: return "Quick rounds — tap the right answer"
        case .coinCounter: return "Add up the coins Sparky shows you"
        case .numberHop: return "Hop along the number line"
        case .lifeCycleLineup: return "Put the stages in order"
        }
    }

    var icon: String {
        switch self {
        case .sparkyMatch: return "bolt.circle.fill"
        case .coinCounter: return "dollarsign.circle.fill"
        case .numberHop: return "figure.walk.circle.fill"
        case .lifeCycleLineup: return "arrow.triangle.2.circlepath.circle.fill"
        }
    }
}

enum TopicGameRegistry {
    static func games(for topic: Topic) -> [TopicGameKind] {
        var games: [TopicGameKind] = []

        switch topic.id {
        case "money-coins":
            games.append(.coinCounter)
        case "skip-counting", "number-line-1200":
            games.append(.numberHop)
        case "sci-life-cycles", "sci3-life-cycles":
            games.append(.lifeCycleLineup)
        default:
            break
        }

        games.append(.sparkyMatch)
        return games
    }
}

enum TopicGameViews {
    @ViewBuilder
    static func root(for game: TopicGameKind, topic: Topic) -> some View {
        switch game {
        case .sparkyMatch:
            SparkyMatchGameView(topic: topic)
        case .coinCounter:
            CoinCounterGameView(topic: topic)
        case .numberHop:
            NumberHopGameView(topic: topic)
        case .lifeCycleLineup:
            LifeCycleLineupGameView(topic: topic)
        }
    }
}

enum TopicGameProblemFactory {
    static func sparkyMatchProblem(topic: Topic) -> Problem {
        for _ in 0..<20 {
            let problem = ProblemGenerator.generate(topic: topic, difficulty: .easy)
            switch problem.answerType {
            case .numberEntry:
                return problem
            case .multipleChoice, .tapSelection:
                if !(problem.choices ?? problem.tapOptions ?? []).isEmpty {
                    return problem
                }
            }
        }
        return ProblemGenerator.generate(topic: topic, difficulty: .easy)
    }
}
