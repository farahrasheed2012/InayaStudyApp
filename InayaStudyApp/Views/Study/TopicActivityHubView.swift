import SwiftUI

struct TopicActivityHubView: View {
    let topic: Topic

    @EnvironmentObject private var profileStore: UserProfileStore
    private var accent: Color { TopicAccent(topic: topic).color }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    Image(systemName: topic.icon)
                        .font(.largeTitle)
                        .foregroundStyle(accent)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(topic.name)
                            .font(AppTypography.hero)
                        Text("TEKS \(topic.teks)")
                            .font(AppTypography.label)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(20)
                .background(AppTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                CharacterView(
                    mood: .idle,
                    size: 88,
                    speechText: "Learn first, then earn stars, \(profileStore.studentName)!"
                )

                VStack(spacing: 14) {
                    NavigationLink {
                        StudyWithSparkyView(topic: topic)
                    } label: {
                        hubButton(
                            title: "Study with Sparky",
                            subtitle: "Guide + 2 example problems — no scoring",
                            icon: "book.fill",
                            color: accent
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        SessionSetupView(topic: topic)
                    } label: {
                        hubButton(
                            title: "Start Practice",
                            subtitle: "Quiz for stars and badges",
                            icon: "star.fill",
                            color: .yellow.opacity(0.9)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .fullWidthContent()
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle(topic.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private func hubButton(title: String, subtitle: String, icon: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(AppTypography.sectionTitle)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(AppTypography.studyBody)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(color.opacity(0.35), lineWidth: 2)
        )
    }
}
