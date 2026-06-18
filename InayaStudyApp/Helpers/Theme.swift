import SwiftUI

enum AppTheme {
    static let appName = "Inaya Study App"
    static let background = Color("AppBackground")
    static let card = Color("CardBackground")
    static let success = Color.green
    static let danger = Color.red
    static let star = Color.yellow

    static func color(hex: String) -> Color {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (91, 141, 239)
        }
        return Color(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}

/// Kid-friendly rounded typography — sized for comfortable reading.
enum AppTypography {
    static let hero = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let question = Font.system(.title, design: .rounded).weight(.bold)
    static let sectionTitle = Font.system(.title2, design: .rounded).weight(.bold)
    static let cardTitle = Font.system(.title3, design: .rounded).weight(.bold)
    static let answer = Font.system(.title2, design: .rounded).weight(.semibold)
    static let studyBody = Font.system(.title3, design: .rounded).weight(.medium)
    static let quizMeta = Font.system(.title3, design: .rounded).weight(.semibold)
    static let pickerOption = Font.system(.title3, design: .rounded).weight(.semibold)
    static let body = Font.system(.body, design: .rounded)
    static let bodyEmphasis = Font.system(.body, design: .rounded).weight(.semibold)
    static let label = Font.system(.headline, design: .rounded).weight(.semibold)
    static let caption = Font.system(.subheadline, design: .rounded)
    static let badge = Font.system(.headline, design: .rounded).weight(.bold)
    static let chip = Font.system(.title3, design: .rounded).weight(.semibold)
}

struct TopicAccent {
    let topic: Topic

    var color: Color { AppTheme.color(hex: topic.color) }
}

private struct ContentColumnModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) private var sizeClass

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, sizeClass == .regular ? 32 : 20)
            .frame(maxWidth: .infinity)
    }
}

private struct FullWidthContentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .top)
    }
}

extension View {
    func topicCardStyle(color: Color) -> some View {
        padding()
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
        .background(color.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.35), lineWidth: 1)
        )
    }

    /// Fills available width with comfortable side padding.
    func contentColumn() -> some View {
        modifier(ContentColumnModifier())
    }

    /// Study / guide screens — edge-to-edge content, no narrow column.
    func fullWidthContent() -> some View {
        modifier(FullWidthContentModifier())
    }

    func questionText() -> some View {
        font(AppTypography.question)
            .multilineTextAlignment(.center)
            .lineSpacing(8)
            .minimumScaleFactor(0.85)
            .fixedSize(horizontal: false, vertical: true)
    }

    func studyText() -> some View {
        font(AppTypography.studyBody)
            .lineSpacing(8)
            .fixedSize(horizontal: false, vertical: true)
    }

    func largeReadable() -> some View {
        font(AppTypography.studyBody)
            .lineSpacing(6)
            .minimumScaleFactor(0.9)
    }

    func quizFeedback() -> some View {
        font(AppTypography.studyBody)
            .multilineTextAlignment(.center)
            .lineSpacing(8)
            .fixedSize(horizontal: false, vertical: true)
    }

    /// Full-screen backdrop that must not steal taps from buttons and controls above it.
    func appScreenBackground() -> some View {
        background {
            AppTheme.background
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
    }

    /// Game screens fill the device and keep the themed background edge-to-edge.
    func gameScreenCanvas(alignment: Alignment = .top) -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .appScreenBackground()
    }
}
