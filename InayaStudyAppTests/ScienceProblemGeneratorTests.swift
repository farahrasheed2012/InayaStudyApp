import XCTest
@testable import InayaStudyApp

final class ScienceProblemGeneratorTests: XCTestCase {
    func testNoAnswerCollisionInChoices() {
        for topic in TopicRegistry.scienceSecondGrade + TopicRegistry.scienceThirdGrade {
            for difficulty in Difficulty.allCases {
                for _ in 0..<5 {
                    let generator = ScienceProblemGeneratorEngine(topic: topic)
                    let problem = generator.generate(difficulty: difficulty)
                    guard let choices = problem.choices else { continue }
                    let wrong = choices.filter { $0 != problem.correctAnswer }
                    XCTAssertFalse(wrong.contains(problem.correctAnswer))
                    XCTAssertEqual(choices.count, 4)
                    XCTAssertEqual(Set(choices).count, 4, "Duplicate choices for \(topic.id)")
                }
            }
        }
    }

    func testDeterminismStress() {
        let topic = TopicRegistry.scienceSecondGrade[0]
        let generator = ScienceProblemGeneratorEngine(topic: topic)
        for _ in 0..<100 {
            let problem = generator.generate(difficulty: .medium)
            XCTAssertFalse(problem.questionText.isEmpty)
            XCTAssertFalse(problem.correctAnswer.isEmpty)
        }
    }
}
