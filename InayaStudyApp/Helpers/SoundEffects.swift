import AVFoundation
import AudioToolbox

@MainActor
enum SoundEffects {
    private static var player: AVAudioPlayer?

    static func playCorrect() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playTone(frequency: 880, duration: 0.15)
    }

    static func playIncorrect() {
        guard SettingsStore.shared.soundEffectsEnabled else { return }
        playTone(frequency: 220, duration: 0.2)
    }

    private static func playTone(frequency: Double, duration: Double) {
        let sampleRate = 44100.0
        let frameCount = Int(sampleRate * duration)
        var samples = [Float](repeating: 0, count: frameCount)
        for i in 0..<frameCount {
            let t = Double(i) / sampleRate
            samples[i] = Float(sin(2.0 * .pi * frequency * t) * 0.3)
        }
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(frameCount)) else { return }
        buffer.frameLength = AVAudioFrameCount(frameCount)
        let channel = buffer.floatChannelData![0]
        for i in 0..<frameCount { channel[i] = samples[i] }
        AudioServicesPlaySystemSound(1057)
    }
}
