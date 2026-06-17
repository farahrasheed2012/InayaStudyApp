import SwiftUI

struct ScienceToolView: View {
    let name: String
    let symbol: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 48))
                .foregroundStyle(Color.orange)
            Text(name)
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
    }
}
