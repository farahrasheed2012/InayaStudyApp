import Foundation

@MainActor
final class UserProfileStore: ObservableObject {
    static let shared = UserProfileStore()

    @Published var studentName: String {
        didSet { UserDefaults.standard.set(studentName, forKey: Keys.name) }
    }

    @Published var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: Keys.onboarding) }
    }

    private enum Keys {
        static let name = "inaya.studentName"
        static let onboarding = "inaya.hasCompletedOnboarding"
    }

    private init() {
        studentName = UserDefaults.standard.string(forKey: Keys.name) ?? "Inaya"
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Keys.onboarding)
    }

    func greeting() -> String {
        "Hi, \(studentName)! 👋"
    }

    func praise(_ phrase: String) -> String {
        phrase.replacingOccurrences(of: "Inaya", with: studentName)
    }
}
