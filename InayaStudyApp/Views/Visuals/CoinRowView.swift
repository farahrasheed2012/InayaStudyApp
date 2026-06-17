import SwiftUI

struct CoinRowView: View {
    let coins: [CoinType]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(Array(coins.enumerated()), id: \.offset) { _, coin in
                coinView(coin)
            }
        }
        .padding()
    }

    @ViewBuilder
    private func coinView(_ coin: CoinType) -> some View {
        switch coin {
        case .dollar:
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.green.opacity(0.3))
                .frame(width: 56, height: 28)
                .overlay(Text("$1").font(.caption.bold()))
        default:
            Circle()
                .fill(coinColor(coin))
                .frame(width: 40, height: 40)
                .overlay(Text(coinLabel(coin)).font(.caption2.bold()).foregroundStyle(.white))
        }
    }

    private func coinColor(_ coin: CoinType) -> Color {
        switch coin {
        case .penny: return .brown
        case .nickel: return .gray
        case .dime: return .blue.opacity(0.7)
        case .quarter: return .gray.opacity(0.8)
        case .dollar: return .green
        }
    }

    private func coinLabel(_ coin: CoinType) -> String {
        switch coin {
        case .penny: return "1¢"
        case .nickel: return "5¢"
        case .dime: return "10¢"
        case .quarter: return "25¢"
        case .dollar: return "$1"
        }
    }
}
