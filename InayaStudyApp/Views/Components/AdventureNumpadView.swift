import SwiftUI

struct AdventureNumpadView: View {
    @Binding var text: String
    var accent: Color
    var onSubmit: () -> Void

    private let rows = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"], [".", "0", "⌫"]]

    var body: some View {
        VStack(spacing: 12) {
            Text(text.isEmpty ? "?" : text)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
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
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
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
                .font(.title2.bold())
                .frame(maxWidth: .infinity, minHeight: 54)
                .background(AppTheme.card)
                .clipShape(Circle())
                .overlay(Circle().stroke(accent.opacity(0.25), lineWidth: 2))
        }
        .buttonStyle(.plain)
        #if targetEnvironment(macCatalyst)
        .scaleEffect(1)
        #endif
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
