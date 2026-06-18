import SwiftUI

struct OnboardingView: View {
    @ObservedObject var profileStore: UserProfileStore
    var onFinish: () -> Void

    @State private var page = 0

    var body: some View {
        VStack {
            TabView(selection: $page) {
                meetSparkyCard.tag(0)
                adventureCard.tag(1)
                nameCard.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .animation(.spring(), value: page)

            Button(page < 2 ? "Next" : "Let's Go!") {
                if page < 2 {
                    withAnimation { page += 1 }
                } else {
                    profileStore.hasCompletedOnboarding = true
                    SpeechManager.shared.speakGreeting(name: profileStore.studentName)
                    onFinish()
                }
            }
            .font(.title3.bold())
            .frame(maxWidth: .infinity, minHeight: 54)
            .background(Color.accentColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding()
        }
        .background(AppTheme.background.ignoresSafeArea())
    }

    private var meetSparkyCard: some View {
        VStack(spacing: 24) {
            Text("Meet Sparky")
                .font(.largeTitle.bold())
            CharacterView(mood: .excited, size: 120, speechText: "Hi! I'm Sparky! Let's learn together! 🤖")
            Text("Your robot buddy cheers you on during every adventure.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
        .padding()
    }

    private var adventureCard: some View {
        VStack(spacing: 24) {
            Text("Your Adventure")
                .font(.largeTitle.bold())
            miniMapPreview
            Text("Follow the path, unlock worlds, and collect badges!")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
        .padding()
    }

    private var nameCard: some View {
        VStack(spacing: 24) {
            Text("What's your name?")
                .font(.largeTitle.bold())
            CharacterView(mood: .thinking, size: 90)
            TextField("Your name", text: $profileStore.studentName)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
                .background(AppTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 32)
            Text("Sparky will cheer for you by name!")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private var miniMapPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.color(hex: "87CEEB"), AppTheme.color(hex: "E0F7FA")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            VStack(spacing: 20) {
                ForEach(0..<4, id: \.self) { i in
                    HStack {
                        if i.isMultiple(of: 2) {
                            circlePreview
                            Spacer()
                        } else {
                            Spacer()
                            circlePreview
                        }
                    }
                }
            }
            .padding(32)
        }
        .frame(height: 220)
        .padding(.horizontal)
    }

    private var circlePreview: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 44, height: 44)
            .overlay(Image(systemName: "star.fill").foregroundStyle(.white).font(.caption))
    }
}
