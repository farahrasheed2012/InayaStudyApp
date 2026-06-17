import SwiftUI

struct ArrayGridView: View {
    let rows: Int
    let cols: Int

    var body: some View {
        let columns = Array(repeating: GridItem(.fixed(28), spacing: 4), count: cols)
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(0..<(rows * cols), id: \.self) { _ in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.blue.opacity(0.5))
                    .frame(width: 28, height: 28)
            }
        }
        .padding()
    }
}
