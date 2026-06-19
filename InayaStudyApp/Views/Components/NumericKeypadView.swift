import SwiftUI

struct NumericKeypadView: View {
    @Binding var text: String
    var onSubmit: () -> Void

    private let rows = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"], [".", "0", "⌫"]]

    var body: some View {
        VStack(spacing: 10) {
            Text(text.isEmpty ? " " : text)
                .font(.system(size: 32, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(AppTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            ForEach(rows, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { key in
                        Button {
                            Haptics.tap()
                            handle(key)
                        } label: {
                            Text(key)
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, minHeight: 52)
                                .background(AppTheme.card)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .appTappableStyle()
                    }
                }
            }

            Button("Check Answer", action: onSubmit)
                .font(.title3.bold())
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }

    private func handle(_ key: String) {
        switch key {
        case "⌫":
            if !text.isEmpty { text.removeLast() }
        case ".":
            if !text.contains(".") { text += "." }
        default:
            text += key
        }
    }
}
