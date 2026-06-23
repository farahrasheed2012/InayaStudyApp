import SwiftUI

extension View {
    @ViewBuilder
    func quizKeyboardShortcuts(viewModel: QuizViewModel, onHint: @escaping () -> Void) -> some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            modifier(QuizKeyboardShortcutsModifier(viewModel: viewModel, onHint: onHint))
        } else {
            self
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
private struct QuizKeyboardShortcutsModifier: ViewModifier {
    @ObservedObject var viewModel: QuizViewModel
    var onHint: () -> Void
    @FocusState private var capturesKeyboard: Bool

    func body(content: Content) -> some View {
        content
            .background {
                Color.clear
                    .frame(width: 1, height: 1)
                    .accessibilityHidden(true)
                    .focusable()
                    .focused($capturesKeyboard)
            }
            .onAppear { refocusIfNeeded() }
            .onChange(of: viewModel.currentIndex) { refocusIfNeeded() }
            .onChange(of: viewModel.showingFeedback) { refocusIfNeeded() }
            .onKeyPress(.return) {
                handleReturn()
                return .handled
            }
            .onKeyPress(.space) {
                if viewModel.showingFeedback {
                    viewModel.continueEarly()
                    return .handled
                }
                return .ignored
            }
            .onKeyPress(characters: CharacterSet(charactersIn: "1234abcdABCD")) { press in
                handleChoiceKey(press)
            }
            .onKeyPress(.delete) {
                handleDelete()
                return .handled
            }
            .onKeyPress(keys: [.deleteForward]) { _ in
                handleDelete()
                return .handled
            }
            .onKeyPress(characters: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ".-"))) { press in
                handleDigitKey(press)
            }
            .onKeyPress("h") {
                onHint()
                return .handled
            }
            .onKeyPress("H") {
                onHint()
                return .handled
            }
    }

    private func refocusIfNeeded() {
        guard viewModel.currentProblem?.answerType != .numberEntry else {
            capturesKeyboard = false
            return
        }
        DispatchQueue.main.async {
            capturesKeyboard = true
        }
    }

    private func handleReturn() {
        if viewModel.showingFeedback {
            viewModel.continueEarly()
        } else if viewModel.currentProblem?.answerType == .numberEntry {
            viewModel.submitCurrentInput()
        }
    }

    private func handleDelete() {
        guard !viewModel.showingFeedback,
              viewModel.currentProblem?.answerType == .numberEntry,
              !viewModel.userInput.isEmpty else { return }
        viewModel.userInput.removeLast()
    }

    private func handleDigitKey(_ press: KeyPress) -> KeyPress.Result {
        guard !viewModel.showingFeedback,
              viewModel.currentProblem?.answerType == .numberEntry,
              let char = press.characters.first else { return .ignored }

        switch char {
        case "0"..."9":
            viewModel.userInput.append(char)
            return .handled
        case ".":
            if !viewModel.userInput.contains(".") {
                viewModel.userInput.append(".")
            }
            return .handled
        case "-":
            if viewModel.userInput.isEmpty {
                viewModel.userInput = "-"
            }
            return .handled
        default:
            return .ignored
        }
    }

    private func handleChoiceKey(_ press: KeyPress) -> KeyPress.Result {
        guard !viewModel.showingFeedback,
              let problem = viewModel.currentProblem,
              problem.answerType != .numberEntry else { return .ignored }

        let choices = problem.choices ?? problem.tapOptions ?? []
        guard !choices.isEmpty, let char = press.characters.first else { return .ignored }

        let index: Int?
        switch char {
        case "1": index = 0
        case "2": index = 1
        case "3": index = 2
        case "4": index = 3
        case "a", "A": index = 0
        case "b", "B": index = 1
        case "c", "C": index = 2
        case "d", "D": index = 3
        default: index = nil
        }

        guard let index, index < choices.count else { return .ignored }
        viewModel.submitAnswer(choices[index])
        return .handled
    }
}
