import XCTest
import SwiftData
@testable import InayaStudyApp

final class GameContentTests: XCTestCase {

    // MARK: - Tier 2

    func testBubbleRoundsProduceValidAnswers() {
        for grade in Grade.allCases {
            for _ in 0..<20 {
                let round = GameContent.bubbleRound(grade: grade)
                XCTAssertFalse(round.prompt.isEmpty)
                XCTAssertFalse(round.correctAnswers.isEmpty)
                XCTAssertTrue(round.correctAnswers.isSubset(of: Set(round.bubbles)))
            }
        }
    }

    func testFrogFlyRoundsHaveExactlyOneCorrectInsect() {
        for grade in Grade.allCases {
            for round in 1...10 {
                let fly = GameContent.frogFlyRound(grade: grade, round: round)
                XCTAssertFalse(fly.question.isEmpty)
                XCTAssertEqual(fly.insects.filter(\.isCorrect).count, 1)
            }
        }
    }

    func testShadowMatchRoundsHaveValidCorrectChoice() {
        for grade in Grade.allCases {
            for round in 1...8 {
                let shadow = GameContent.shadowRound(grade: grade, round: round)
                XCTAssertTrue(shadow.choices.contains(shadow.correct))
            }
        }
    }

    func testPotionRoundsAllowSubsetAnswers() {
        for grade in Grade.allCases {
            for round in 1...8 {
                let potion = GameContent.potionRound(grade: grade, round: round)
                XCTAssertFalse(potion.goal.isEmpty)
                XCTAssertTrue(potion.correctSet.isSubset(of: Set(potion.ingredients)))
                XCTAssertGreaterThanOrEqual(potion.minPick, 1)
                XCTAssertGreaterThanOrEqual(potion.maxPick, potion.minPick)
                // Any min-sized subset of correct ingredients should be valid.
                let sample = Array(potion.correctSet.prefix(potion.minPick))
                XCTAssertGreaterThanOrEqual(sample.count, potion.minPick)
            }
        }
    }

    func testUnderwaterQuestionsHaveValidCorrectChoice() {
        for grade in Grade.allCases {
            for zone in GameContent.UnderwaterZone.allCases {
                for round in 1...3 {
                    let q = GameContent.underwaterQuestion(grade: grade, zone: zone, round: round)
                    XCTAssertTrue(q.choices.contains(q.correct))
                }
            }
        }
    }

    // MARK: - Tier 3

    func testMeteorRoundsAreSolvable() {
        for grade in Grade.allCases {
            for round in 1...12 {
                let meteor = GameContent.meteorRound(grade: grade, round: round)
                XCTAssertTrue(
                    Self.meteorRoundHasSolution(meteor),
                    "No valid pair for target \(meteor.target) in \(meteor.meteors)"
                )
            }
        }
    }

    func testMysteryCasesHaveFiveCluesWithValidAnswers() {
        for grade in Grade.allCases {
            for _ in 0..<5 {
                let mystery = GameContent.mysteryCase(grade: grade)
                XCTAssertEqual(mystery.clues.count, 5)
                for clue in mystery.clues {
                    XCTAssertTrue(clue.choices.contains(clue.correct))
                }
            }
        }
    }

    func testTimeTravelerQuestionsHaveValidCorrectChoice() {
        for grade in Grade.allCases {
            for era in GameContent.TimeEra.allCases {
                for round in 1...3 {
                    let q = GameContent.timeTravelerQuestion(grade: grade, era: era, round: round)
                    XCTAssertTrue(q.choices.contains(q.correct))
                }
            }
        }
    }

    func testTownBuilderProblemsHaveValidNumericAnswer() {
        for grade in Grade.allCases {
            for round in 1...8 {
                let p = GameContent.townBuilderProblem(grade: grade, round: round)
                XCTAssertTrue(p.choices.contains(p.correct))
            }
        }
    }

    func testTerrariumQuestionsHaveValidCorrectChoice() {
        for grade in Grade.allCases {
            for round in 1...8 {
                let q = GameContent.terrariumQuestion(grade: grade, round: round)
                XCTAssertTrue(q.choices.contains(q.correct))
            }
        }
    }

    // MARK: - Builder persistence

    @MainActor
    func testBuilderStorePersistsTownMaterials() throws {
        let container = try ModelContainer(
            for: TownBuildState.self, TerrariumBuildState.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let store = BuilderStore(modelContext: container.mainContext)
        store.addTownMaterials(grade: .second, lumber: 2, bricks: 1, glass: 1)
        let state = store.townState(grade: .second)
        XCTAssertEqual(state.lumber, 2)
        XCTAssertEqual(state.bricks, 1)
        XCTAssertEqual(state.glass, 1)
        XCTAssertTrue(store.placeTownBuilding(grade: .second, buildingID: "park"))
        XCTAssertEqual(store.townState(grade: .second).lumber, 1)
    }

    @MainActor
    func testBuilderStoreTerrariumBalance() throws {
        let container = try ModelContainer(
            for: TownBuildState.self, TerrariumBuildState.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let store = BuilderStore(modelContext: container.mainContext)
        store.addTerrariumInventory(grade: .third, plants: 2, animals: 1, terrain: 1)
        XCTAssertTrue(store.placeTerrariumItem(grade: .third, pieceID: "grass"))
        XCTAssertTrue(store.placeTerrariumItem(grade: .third, pieceID: "ladybug"))
        XCTAssertTrue(store.placeTerrariumItem(grade: .third, pieceID: "soil"))
        XCTAssertTrue(store.terrariumIsBalanced(grade: .third))
    }

    // MARK: - Helpers

    private static func meteorRoundHasSolution(_ round: GameContent.MeteorRound) -> Bool {
        let values = round.meteors
        for i in values.indices {
            for j in values.indices where j != i {
                let result: Int
                switch round.operation {
                case .add: result = values[i] + values[j]
                case .multiply: result = values[i] * values[j]
                }
                if result == round.target { return true }
            }
        }
        return false
    }
}
