import SwiftUI

struct FoodChainView: View {
    let producer: String
    let herbivore: String
    let carnivore: String

    var body: some View {
        HStack(spacing: 8) {
            chainBox(title: producer, symbol: "leaf.fill", color: .green)
            Image(systemName: "arrow.right")
                .foregroundStyle(.secondary)
            chainBox(title: herbivore, symbol: "hare.fill", color: .orange)
            Image(systemName: "arrow.right")
                .foregroundStyle(.secondary)
            chainBox(title: carnivore, symbol: "pawprint.fill", color: .red)
        }
        .padding()
    }

    private func chainBox(title: String, symbol: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: symbol)
                .font(.title2)
                .foregroundStyle(color)
            Text(title)
                .font(.caption.bold())
                .multilineTextAlignment(.center)
        }
        .frame(minWidth: 72)
        .padding(10)
        .background(color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
