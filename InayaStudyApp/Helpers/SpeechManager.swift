import AVFoundation

@MainActor
final class SpeechManager: NSObject {
    static let shared = SpeechManager()

    private let synthesizer = AVSpeechSynthesizer()

    override private init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }

    func configureAudioSession() {
        #if os(iOS)
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
        #endif
    }

    func speak(_ text: String) {
        guard SettingsStore.shared.voiceGuidanceEnabled else { return }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(makeUtterance(trimmed))
    }

    func speakPraise(name: String, subject: Subject) {
        let phrases: [String]
        switch subject {
        case .math:
            phrases = [
                "Great job, \(name)!",
                "Awesome work, \(name)!",
                "You got it, \(name)!",
                "Super star, \(name)!",
                "Way to go, \(name)!",
                "Brilliant, \(name)!",
            ]
        case .science:
            phrases = [
                "Great scientist, \(name)!",
                "Amazing discovery, \(name)!",
                "You figured it out, \(name)!",
                "Science star, \(name)!",
                "Super observation, \(name)!",
            ]
        }
        speak(phrases.randomElement() ?? "Great job, \(name)!")
    }

    func speakResults(stars: Int, name: String, subject: Subject) {
        let message = Encouragement.resultsMessage(stars: stars, subject: subject, name: name)
        speak(message.sanitizedForSpeech)
    }

    func speakBadgeUnlock(topicName: String, name: String) {
        speak("Congratulations \(name)! You unlocked the \(topicName) master badge!")
    }

    func speakGreeting(name: String) {
        speak("Hi \(name)! I'm Sparky. Let's learn together!")
    }

    func previewVoice() {
        let name = UserProfileStore.shared.studentName
        speak("Hi \(name)! This is how Sparky sounds now.")
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    private func makeUtterance(_ text: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.44
        utterance.pitchMultiplier = 1.08
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        return utterance
    }
}

private extension String {
    var sanitizedForSpeech: String {
        replacingOccurrences(of: "🌟", with: "")
            .replacingOccurrences(of: "🔬", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension SpeechManager: AVSpeechSynthesizerDelegate {}
