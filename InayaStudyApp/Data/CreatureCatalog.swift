import Foundation

struct CreatureDefinition: Identifiable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let funFact: String
    let gameID: AppGameID
}

enum CreatureCatalog {
    static let all: [CreatureDefinition] = AppGameID.allCases.compactMap { creature(for: $0) }

    static func creature(for gameID: AppGameID) -> CreatureDefinition? {
        switch gameID {
        case .numberNinja:
            return CreatureDefinition(id: "ninja-newt", name: "Ninja Newt", emoji: "🦎", funFact: "Newts can regrow their tails — just like you regrow math skills with practice!", gameID: gameID)
        case .coinCollector:
            return CreatureDefinition(id: "coin-koala", name: "Coin Koala", emoji: "🐨", funFact: "Koalas sleep up to 20 hours a day — saving energy like saving coins!", gameID: gameID)
        case .fractionFeast:
            return CreatureDefinition(id: "fraction-fox", name: "Fraction Fox", emoji: "🦊", funFact: "Foxes split their meals into fair shares — just like fractions!", gameID: gameID)
        case .timesBingo:
            return CreatureDefinition(id: "bingo-bee", name: "Bingo Bee", emoji: "🐝", funFact: "Bees visit flowers in patterns — buzz through times tables!", gameID: gameID)
        case .numberLineJump:
            return CreatureDefinition(id: "jumping-frog", name: "Jumping Frog", emoji: "🐸", funFact: "Frogs leap in big hops along the number line!", gameID: gameID)
        case .sortIt:
            return CreatureDefinition(id: "sorting-squirrel", name: "Sorting Squirrel", emoji: "🐿️", funFact: "Squirrels sort nuts into piles — living and nonliving, solid and liquid!", gameID: gameID)
        case .foodWebBuilder:
            return CreatureDefinition(id: "web-weaver", name: "Web Weaver", emoji: "🕷️", funFact: "Spiders weave webs; you weave food chains!", gameID: gameID)
        case .weatherWatcher:
            return CreatureDefinition(id: "weather-owl", name: "Weather Owl", emoji: "🦉", funFact: "Owls watch the sky at night — you watch the weather!", gameID: gameID)
        case .quizShow:
            return CreatureDefinition(id: "quiz-quail", name: "Quiz Quail", emoji: "🐦", funFact: "Quails are quick thinkers — just like quiz champs!", gameID: gameID)
        case .dailyChallenge:
            return CreatureDefinition(id: "streak-starfish", name: "Streak Starfish", emoji: "⭐", funFact: "Starfish can grow new arms — keep your streak growing!", gameID: gameID)
        case .bossBattle:
            return CreatureDefinition(id: "boss-dragon", name: "Boss Dragon", emoji: "🐉", funFact: "You defeated the boss — legendary!", gameID: gameID)
        case .patternPuzzler:
            return CreatureDefinition(id: "pattern-penguin", name: "Pattern Penguin", emoji: "🐧", funFact: "Penguins march in patterns across the ice!", gameID: gameID)
        case .habitatMatch:
            return CreatureDefinition(id: "habitat-hawk", name: "Habitat Hawk", emoji: "🦅", funFact: "Hawks know every habitat from sky to forest!", gameID: gameID)
        case .animalRescue:
            return CreatureDefinition(id: "rescue-rabbit", name: "Rescue Rabbit", emoji: "🐰", funFact: "Rabbits find their way home through meadows!", gameID: gameID)
        case .mathDuel:
            return CreatureDefinition(id: "duel-dragon", name: "Duel Dragon", emoji: "🐲", funFact: "Two players, one problem — may the fastest win!", gameID: gameID)
        }
    }

    static func creatureKey(gameID: AppGameID, grade: Grade) -> String {
        "\(gameID.rawValue)-\(grade.rawValue)"
    }
}
