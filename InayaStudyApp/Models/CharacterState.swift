import Foundation

enum SparkyMood: String, CaseIterable {
    case idle
    case excited
    case thinking
    case celebrating
    case encouraging
    case sleeping

    var speechBubble: String? {
        switch self {
        case .encouraging: return "Try again!"
        case .thinking: return nil
        case .sleeping: return "Zzz..."
        default: return nil
        }
    }
}

struct CharacterState: Equatable {
    var mood: SparkyMood
    var speechText: String?

    static let idle = CharacterState(mood: .idle)
}
