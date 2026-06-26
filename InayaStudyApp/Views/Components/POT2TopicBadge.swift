import SwiftUI

struct POT2TopicBadge: View {
    let topic: Topic

    var body: some View {
        if topic.isCompetitionOnly {
            Label("Bonus Challenge", systemImage: "star.fill")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.orange)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.15))
                .clipShape(Capsule())
        } else if let code = topic.potCode {
            Text(code)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
        }
    }
}
