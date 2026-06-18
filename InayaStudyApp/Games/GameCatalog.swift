import Foundation

enum AppGameID: String, CaseIterable, Identifiable, Hashable {
    case numberNinja
    case coinCollector
    case fractionFeast
    case timesBingo
    case numberLineJump
    case patternPuzzler
    case sortIt
    case foodWebBuilder
    case weatherWatcher
    case habitatMatch
    case animalRescue
    case quizShow
    case dailyChallenge
    case bossBattle
    case mathDuel
    case bubblePop
    case frogFly
    case shadowMatch
    case underwaterExpedition
    case potionLab
    case meteorMath
    case mysteryIsland
    case timeTraveler
    case terrariumBuilder
    case townBuilder

    var id: String { rawValue }

    var title: String {
        switch self {
        case .numberNinja: return "Number Ninja"
        case .coinCollector: return "Coin Collector"
        case .fractionFeast: return "Fraction Feast"
        case .timesBingo: return "Times Table Bingo"
        case .numberLineJump: return "Number Line Jump"
        case .patternPuzzler: return "Pattern Puzzler"
        case .sortIt: return "Sort It"
        case .foodWebBuilder: return "Food Web Builder"
        case .weatherWatcher: return "Weather Watcher"
        case .habitatMatch: return "Habitat Match"
        case .animalRescue: return "Animal Rescue"
        case .quizShow: return "Quiz Show"
        case .dailyChallenge: return "Daily Challenge"
        case .bossBattle: return "Boss Battle"
        case .mathDuel: return "Math Duel"
        case .bubblePop: return "Bubble Pop"
        case .frogFly: return "Frog Fly"
        case .shadowMatch: return "Shadow Match"
        case .underwaterExpedition: return "Underwater Expedition"
        case .potionLab: return "Potion Lab"
        case .meteorMath: return "Meteor Math"
        case .mysteryIsland: return "Mystery Island"
        case .timeTraveler: return "Time Traveler"
        case .terrariumBuilder: return "Terrarium Builder"
        case .townBuilder: return "Town Builder"
        }
    }

    var icon: String {
        switch self {
        case .numberNinja: return "figure.martial.arts"
        case .coinCollector: return "dollarsign.circle.fill"
        case .fractionFeast: return "circle.lefthalf.filled"
        case .timesBingo: return "square.grid.3x3.fill"
        case .numberLineJump: return "figure.jump"
        case .patternPuzzler: return "square.grid.3x3.bottomleft.filled"
        case .sortIt: return "tray.2.fill"
        case .foodWebBuilder: return "leaf.arrow.triangle.circlepath"
        case .weatherWatcher: return "cloud.sun.fill"
        case .habitatMatch: return "tree.fill"
        case .animalRescue: return "pawprint.fill"
        case .quizShow: return "gamecontroller.fill"
        case .dailyChallenge: return "flame.fill"
        case .bossBattle: return "shield.lefthalf.filled"
        case .mathDuel: return "person.2.fill"
        case .bubblePop: return "bubble.left.and.bubble.right.fill"
        case .frogFly: return "leaf.fill"
        case .shadowMatch: return "moon.fill"
        case .underwaterExpedition: return "water.waves"
        case .potionLab: return "flask.fill"
        case .meteorMath: return "sparkles"
        case .mysteryIsland: return "map.fill"
        case .timeTraveler: return "clock.fill"
        case .terrariumBuilder: return "leaf.circle.fill"
        case .townBuilder: return "building.2.fill"
        }
    }

    var scope: GameSubjectScope {
        switch self {
        case .numberNinja, .coinCollector, .fractionFeast, .timesBingo, .numberLineJump, .patternPuzzler, .mathDuel,
             .bubblePop, .meteorMath, .timeTraveler, .townBuilder:
            return .math
        case .sortIt, .foodWebBuilder, .weatherWatcher, .habitatMatch, .animalRescue,
             .frogFly, .shadowMatch, .potionLab, .terrariumBuilder:
            return .science
        case .quizShow, .dailyChallenge, .bossBattle, .underwaterExpedition, .mysteryIsland:
            return .both
        }
    }

    var grades: [Grade] {
        switch self {
        case .dailyChallenge, .quizShow, .bossBattle, .mathDuel:
            return Grade.allCases
        default:
            return Grade.allCases
        }
    }

    var badgeLabel: String {
        switch self {
        case .numberNinja: return "Number Ninja"
        case .coinCollector: return "Coin Master"
        case .fractionFeast: return "Fraction Chef"
        case .timesBingo: return "Bingo Champ"
        case .numberLineJump: return "Frog Jumper"
        case .patternPuzzler: return "Pattern Pro"
        case .sortIt: return "Sorting Star"
        case .foodWebBuilder: return "Web Weaver"
        case .weatherWatcher: return "Weather Pro"
        case .habitatMatch: return "Habitat Hero"
        case .animalRescue: return "Rescue Ranger"
        case .quizShow: return "Quiz Star"
        case .dailyChallenge: return "Streak Keeper"
        case .bossBattle: return "Boss Slayer"
        case .mathDuel: return "Duel Champion"
        case .bubblePop: return "Bubble Master"
        case .frogFly: return "Fly Catcher"
        case .shadowMatch: return "Shadow Sleuth"
        case .underwaterExpedition: return "Deep Diver"
        case .potionLab: return "Potion Brewer"
        case .meteorMath: return "Meteor Blaster"
        case .mysteryIsland: return "Island Detective"
        case .timeTraveler: return "Time Explorer"
        case .terrariumBuilder: return "Eco Architect"
        case .townBuilder: return "Town Planner"
        }
    }

    var totalRounds: Int {
        switch self {
        case .numberNinja: return 20
        case .coinCollector: return 10
        case .fractionFeast: return 8
        case .timesBingo: return 3
        case .numberLineJump: return 10
        case .patternPuzzler: return 10
        case .sortIt: return 15
        case .foodWebBuilder: return 3
        case .weatherWatcher: return 10
        case .habitatMatch: return 8
        case .animalRescue: return 6
        case .quizShow: return 12
        case .dailyChallenge: return 1
        case .bossBattle: return 5
        case .mathDuel: return 10
        case .bubblePop: return 12
        case .frogFly: return 10
        case .shadowMatch: return 8
        case .underwaterExpedition: return 9
        case .potionLab: return 8
        case .meteorMath: return 12
        case .mysteryIsland: return 5
        case .timeTraveler: return 9
        case .terrariumBuilder: return 8
        case .townBuilder: return 8
        }
    }

    func isAvailable(for grade: Grade) -> Bool {
        grades.contains(grade)
    }
}
