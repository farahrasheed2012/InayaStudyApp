import AVFoundation
import AudioToolbox

@MainActor
enum SoundEffects {
    private static var player: AVAudioPlayer?

    static func playTap() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playTone(frequency: 520, duration: 0.05, volume: 0.2)
    }

    static func playCorrect() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playSequence(frequencies: [523.25, 659.25, 783.99], duration: 0.12)
    }

    static func playIncorrect() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playTone(frequency: 180, duration: 0.22, volume: 0.35)
    }

    static func playStarEarned() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playSequence(frequencies: [880, 1046.5, 1318.5], duration: 0.1)
    }

    static func playBadgeUnlocked() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playSequence(frequencies: [523.25, 659.25, 880, 1046.5], duration: 0.14)
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
