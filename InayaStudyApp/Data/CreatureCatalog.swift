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
        case .bubblePop:
            return CreatureDefinition(id: "bubble-blowfish", name: "Bubble Blowfish", emoji: "🐡", funFact: "Blowfish puff up with bubbles — pop the right answers!", gameID: gameID)
        case .frogFly:
            return CreatureDefinition(id: "fly-catcher-frog", name: "Fly Catcher Frog", emoji: "🐸", funFact: "Frogs snap up insects — catch the science vocab!", gameID: gameID)
        case .shadowMatch:
            return CreatureDefinition(id: "shadow-owl", name: "Shadow Owl", emoji: "🦉", funFact: "Owls see shapes in the dark — match the silhouette!", gameID: gameID)
        case .underwaterExpedition:
            return CreatureDefinition(id: "reef-ray", name: "Reef Ray", emoji: "🐠", funFact: "Rays glide through coral reefs on underwater adventures!", gameID: gameID)
        case .potionLab:
            return CreatureDefinition(id: "potion-platypus", name: "Potion Platypus", emoji: "🦫", funFact: "Platypuses mix river water — you mix science ingredients!", gameID: gameID)
        case .meteorMath:
            return CreatureDefinition(id: "meteor-mole", name: "Meteor Mole", emoji: "🌠", funFact: "Moles dig fast — blast meteors before they hit Earth!", gameID: gameID)
        case .mysteryIsland:
            return CreatureDefinition(id: "mystery-monkey", name: "Mystery Monkey", emoji: "🐒", funFact: "Monkeys love puzzles — solve clues to crack the case!", gameID: gameID)
        case .timeTraveler:
            return CreatureDefinition(id: "time-turtle", name: "Time Turtle", emoji: "🐢", funFact: "Turtles have been around for ages — travel through time!", gameID: gameID)
        case .terrariumBuilder:
            return CreatureDefinition(id: "terrarium-toad", name: "Terrarium Toad", emoji: "🐸", funFact: "Toads balance ecosystems — build a balanced terrarium!", gameID: gameID)
        case .townBuilder:
            return CreatureDefinition(id: "town-beaver", name: "Town Beaver", emoji: "🦫", funFact: "Beavers build towns by rivers — plan your own!", gameID: gameID)
        }
    }

    static func creatureKey(gameID: AppGameID, grade: Grade) -> String {
        "\(gameID.rawValue)-\(grade.rawValue)"
    }
}
