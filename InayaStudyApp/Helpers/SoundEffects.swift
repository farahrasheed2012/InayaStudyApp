import AVFoundation
import AudioToolbox

@MainActor
enum SoundEffects {
    private static var configured = false

    static func prepare() {
        guard !configured else { return }
        configured = true
        SpeechManager.shared.configureAudioSession()
    }

    static func playTap() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playTone(frequency: 520, duration: 0.05, volume: 0.2)
    }

    static func playCorrect() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playSequence(frequencies: [523.25, 659.25, 783.99], duration: 0.12)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            playApplause()
        }
    }

    /// Quick celebratory claps — layered after correct answers and big wins.
    static func playApplause() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        let clapCount = 7
        for index in 0..<clapCount {
            let delay = Double(index) * 0.07 + Double.random(in: 0...0.03)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let frequency = Double.random(in: 200...480)
                playTone(frequency: frequency, duration: 0.045, volume: 0.18)
            }
        }
    }

    static func playCelebration() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playSequence(frequencies: [523.25, 659.25, 880, 1046.5], duration: 0.14)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            playApplause()
        }
    }

    static func playIncorrect() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playTone(frequency: 180, duration: 0.22, volume: 0.35)
    }

    static func playStarEarned() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playSequence(frequencies: [880, 1046.5, 1318.5], duration: 0.1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            playApplause()
        }
    }

    static func playBadgeUnlocked() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playCelebration()
    }

    static func playUnlock() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playTone(frequency: 740, duration: 0.12, volume: 0.3)
    }

    static func playSparkyBleep() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playTone(frequency: 660, duration: 0.08, volume: 0.25)
    }

    private static func playSequence(frequencies: [Double], duration: Double) {
        for (index, frequency) in frequencies.enumerated() {
            let delay = Double(index) * duration
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                playTone(frequency: frequency, duration: duration, volume: 0.3)
            }
        }
    }

    private static func playTone(frequency: Double, duration: Double, volume: Double = 0.3) {
        let sampleRate = 44100.0
        let frameCount = Int(sampleRate * duration)
        var samples = [Float](repeating: 0, count: frameCount)
        for i in 0..<frameCount {
            let t = Double(i) / sampleRate
            let envelope = min(1.0, t * 40) * min(1.0, (duration - t) * 40)
            samples[i] = Float(sin(2.0 * .pi * frequency * t) * volume * envelope)
        }

        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(frameCount)) else {
            fallbackSystemClick()
            return
        }
        buffer.frameLength = AVAudioFrameCount(frameCount)
        let channel = buffer.floatChannelData![0]
        for i in 0..<frameCount { channel[i] = samples[i] }

        do {
            let engine = AVAudioEngine()
            let playerNode = AVAudioPlayerNode()
            engine.attach(playerNode)
            engine.connect(playerNode, to: engine.mainMixerNode, format: format)
            try engine.start()
            playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts) {
                engine.stop()
            }
            playerNode.play()
        } catch {
            fallbackSystemClick()
        }
    }

    private static func fallbackSystemClick() {
        AudioServicesPlaySystemSound(1104)
    }
}
