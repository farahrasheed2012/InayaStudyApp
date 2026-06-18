import SwiftUI

struct StreakRowView: View {
    let currentStreak: Int
    let lastPracticed: Date

    @ScaledMetric(relativeTo: .caption) private var dayCircleSize: CGFloat = 34

    private var weekDays: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0 - 6, to: today) }
    }

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 4) {
                Text("🔥")
                Text("\(currentStreak)")
                    .font(AppTypography.sectionTitle)
            }

            Spacer()

            HStack(spacing: 6) {
                ForEach(weekDays, id: \.self) { day in
                    dayCircle(for: day)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func dayCircle(for day: Date) -> some View {
        let practiced = practicedOn(day)
        return ZStack {
            Circle()
                .fill(practiced ? Color.orange.opacity(0.25) : Color.secondary.opacity(0.12))
                .frame(width: dayCircleSize, height: dayCircleSize)
            if practiced {
                Text("🔥")
                    .font(AppTypography.caption)
            } else {
                Text(shortWeekday(day))
                    .font(AppTypography.badge)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func practicedOn(_ day: Date) -> Bool {
        let calendar = Calendar.current
        let practicedDay = calendar.startOfDay(for: lastPracticed)
        return practicedDay == calendar.startOfDay(for: day)
    }

    private func shortWeekday(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: date)
    }
}
