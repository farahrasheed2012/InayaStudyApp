import SwiftUI

/// Spec alias — app uses `GradeLevel` everywhere else.
typealias Grade = GradeLevel

struct GameResult {
    let score: Int
    let totalRounds: Int
    let durationSeconds: Int
    let earnedBadge: GameBadgeAward?
    let earnedCreature: CreatureAward?
}

/// Creature unlocked on a perfect game round.
struct CreatureAward: Equatable {
    let id: String
    let name: String
    let emoji: String
    let funFact: String
}

/// Lightweight badge payload returned on completion (persisted separately).
struct GameBadgeAward: Equatable {
    let id: String
    let gameID: String
    let label: String
    let symbolName: String
}

protocol GameScene: View {
    var grade: Grade { get }
    var subject: Subject { get }
    var onComplete: (GameResult) -> Void { get }
}

enum GameSubjectScope: String, CaseIterable {
    case math
    case science
    case both

    var label: String {
        switch self {
        case .math: return "Math"
        case .science: return "Science"
        case .both: return "Both"
        }
    }
}
