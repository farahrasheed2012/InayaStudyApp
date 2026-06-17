import XCTest
@testable import InayaStudyApp

final class ProblemGeneratorTests: XCTestCase {

    func testAllSecondGradeMathTopicsGenerateValidProblems() {
        for topic in TopicRegistry.mathSecondGrade {
            for difficulty in Difficulty.allCases {
                for _ in 0..<5 {
                    assertValidProblem(ProblemGenerator.generate(topic: topic, difficulty: difficulty), topic: topic)
                }
            }
        }
    }

    func testAllThirdGradeMathTopicsGenerateValidProblems() {
        for topic in TopicRegistry.mathThirdGrade {
            for difficulty in Difficulty.allCases {
                for _ in 0..<5 {
                    assertValidProblem(ProblemGenerator.generate(topic: topic, difficulty: difficulty), topic: topic)
                }
            }
        }
    }

    func testAllScienceTopicsGenerateValidProblems() {
        for topic in TopicRegistry.scienceSecondGrade {
            for difficulty in Difficulty.allCases {
                for _ in 0..<5 {
                    let problem = ProblemGenerator.generate(topic: topic, difficulty: difficulty)
                    assertValidScienceProblem(problem, topic: topic)
                }
            }
        }
    }

    func testCorrectAnswerAlwaysValid() {
        for topic in TopicRegistry.all {
            let problem = ProblemGenerator.generate(topic: topic, difficulty: .medium)
            XCTAssertTrue(
                ProblemGenerator.isAnswerValid(problem, userAnswer: problem.correctAnswer),
                "Correct answer should validate for \(topic.id): \(problem.correctAnswer)"
            )
        }
    }

    func testMultipleChoiceContainsCorrectAnswer() {
        for topic in TopicRegistry.all {
            for _ in 0..<10 {
                let problem = ProblemGenerator.generate(topic: topic, difficulty: .easy)
                guard problem.answerType == .multipleChoice, let choices = problem.choices else { continue }
                XCTAssertTrue(
                    choices.contains(problem.correctAnswer),
                    "MC choices must include correct answer for \(topic.id)"
                )
                XCTAssertGreaterThanOrEqual(choices.count, 2)
            }
        }
    }

    func testScienceMultipleChoiceHasFourOptions() {
        for topic in TopicRegistry.scienceSecondGrade {
            for difficulty in Difficulty.allCases {
                for _ in 0..<10 {
                    let problem = ProblemGenerator.generate(topic: topic, difficulty: difficulty)
                    XCTAssertEqual(problem.answerType, .multipleChoice, topic.id)
                    XCTAssertEqual(problem.choices?.count, 4, topic.id)
                    XCTAssertTrue(problem.choices?.contains(problem.correctAnswer) == true, topic.id)
                }
            }
        }
    }

    func testMultiplicationAnswerMath() {
        let topic = TopicRegistry.topic(id: "multiplication")!
        for _ in 0..<20 {
            let p = ProblemGenerator.generate(topic: topic, difficulty: .medium)
            XCTAssertFalse(p.correctAnswer.isEmpty)
            XCTAssertTrue(ProblemGenerator.isAnswerValid(p, userAnswer: p.correctAnswer))
        }
    }

    func testDivisionProducesWholeNumberQuotient() {
        let topic = TopicRegistry.topic(id: "division")!
        for _ in 0..<20 {
            let p = ProblemGenerator.generate(topic: topic, difficulty: .hard)
            guard let quotient = Int(p.correctAnswer) else {
                XCTFail("Division answer should be integer")
                continue
            }
            XCTAssert((0...12).contains(quotient))
        }
    }

    private func assertValidProblem(_ problem: Problem, topic: Topic) {
        XCTAssertFalse(problem.questionText.isEmpty, topic.id)
        XCTAssertFalse(problem.correctAnswer.isEmpty, topic.id)
        if topic.id != "staar-mixed" {
            XCTAssertEqual(problem.teksId, topic.teks, topic.id)
        }

        switch problem.answerType {
        case .multipleChoice:
            XCTAssertNotNil(problem.choices)
            XCTAssertTrue(problem.choices?.contains(problem.correctAnswer) == true, topic.id)
        case .tapSelection:
            let options = problem.tapOptions ?? problem.choices ?? []
            XCTAssertTrue(options.contains(problem.correctAnswer), topic.id)
        case .numberEntry:
            break
        }

        XCTAssertTrue(
            ProblemGenerator.isAnswerValid(problem, userAnswer: problem.correctAnswer),
            "Self-validation failed for \(topic.id): \(problem.correctAnswer)"
        )
    }

    private func assertValidScienceProblem(_ problem: Problem, topic: Topic) {
        assertValidProblem(problem, topic: topic)
        XCTAssertEqual(problem.answerType, .multipleChoice, topic.id)
        XCTAssertEqual(problem.choices?.count, 4, topic.id)
        XCTAssertNotNil(problem.funFact, topic.id)
    }
}
