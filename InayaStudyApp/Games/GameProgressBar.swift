import SwiftUI

/// Horizontal progress bar without a layout-expanding `GeometryReader` in the parent stack.
struct GameProgressBar: View {
    let progress: Double
    let accent: Color

    var body: some View {
        Capsule()
            .fill(Color.secondary.opacity(0.15))
            .overlay(alignment: .leading) {
                Capsule()
                    .fill(accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .scaleEffect(x: max(0, min(1, progress)), anchor: .leading)
            }
            .frame(height: 14)
            .accessibilityLabel("Progress")
    }
}

/// Ensures pushed game screens receive touches (avoids ScrollView navigation glitches).
struct GamePlayRoot<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .gameScreenCanvas()
    }
}

enum GameChoiceGridLayout {
    case standard
    /// Taller answer buttons that expand into leftover vertical space.
    case fill
}
