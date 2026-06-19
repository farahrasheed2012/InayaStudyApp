import SwiftUI

struct AdventureNumpadView: View {
    @Binding var text: String
    var accent: Color
    var onSubmit: () -> Void

  @ScaledMetric(relativeTo: .largeTitle) private var displaySize: CGFloat = 52
  @ScaledMetric(relativeTo: .title2) private var keyMinHeight: CGFloat = 68

    private let rows = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"], [".", "0", "⌫"]]

    var body: some View {
        VStack(spacing: 12) {
            Text(text.isEmpty ? "?" : text)
                .font(.system(size: displaySize, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(accent.opacity(0.4), lineWidth: 2)
                )

            ForEach(rows, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { key in
                        numpadKey(key)
                    }
                }
            }

            Button(action: onSubmit) {
                Text("Submit")
                    .font(AppTypography.sectionTitle)
                    .frame(maxWidth: .infinity, minHeight: keyMinHeight)
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .appTappableStyle()
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }

    private func numpadKey(_ key: String) -> some View {
        Button {
            Haptics.tap()
            SoundEffects.playTap()
            handle(key)
        } label: {
            Text(key)
                .font(AppTypography.sectionTitle)
                .frame(maxWidth: .infinity, minHeight: keyMinHeight)
                .background(AppTheme.card)
                .clipShape(Circle())
                .overlay(Circle().stroke(accent.opacity(0.25), lineWidth: 2))
        }
        .appTappableStyle()
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
