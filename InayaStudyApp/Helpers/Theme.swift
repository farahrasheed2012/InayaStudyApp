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

struct TopicAccent {
    let topic: Topic

    var color: Color { AppTheme.color(hex: topic.color) }
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

    func largeReadable() -> some View {
        font(.title3)
            .minimumScaleFactor(0.8)
            .dynamicTypeSize(...DynamicTypeSize.accessibility3)
    }
}
