import SwiftUI

struct MatterStateView: View {
    let highlighted: String

    private let states: [(id: String, label: String, symbol: String, color: Color)] = [
        ("solid", "Solid", "snowflake", .blue),
        ("liquid", "Liquid", "drop.fill", .cyan),
        ("gas", "Gas", "cloud.fill", .gray),
    ]

    var body: some View {
        HStack(spacing: 20) {
            ForEach(states, id: \.id) { state in
                VStack(spacing: 8) {
                    Image(systemName: state.symbol)
                        .font(.largeTitle)
                        .foregroundStyle(state.id == highlighted ? state.color : .secondary.opacity(0.4))
                    Text(state.label)
                        .font(.caption.bold())
                        .foregroundStyle(state.id == highlighted ? .primary : .secondary)
                }
                .padding()
                .background(state.id == highlighted ? state.color.opacity(0.15) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
    }
}
