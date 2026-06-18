import SwiftUI

struct SettingsTabView: View {
    @ObservedObject private var settings = SettingsStore.shared
    @EnvironmentObject private var progressStore: ProgressStore
    @EnvironmentObject private var rewardsStore: RewardsStore

    @State private var unlocked = false
    @State private var pinInput = ""
    @State private var newPIN = ""
    @State private var confirmPIN = ""
    @State private var showResetConfirm = false

    var body: some View {
        Group {
            if unlocked {
                settingsForm
            } else {
                pinGate
            }
        }
        .navigationTitle("Settings")
    }

    private var pinGate: some View {
        VStack(spacing: 20) {
            Text("Parent Settings")
                .font(.title2.bold())
            Text("Enter 4-digit PIN")
                .foregroundStyle(.secondary)
            SecureField("PIN", text: $pinInput)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.title)
                .frame(maxWidth: 200)
                .textFieldStyle(.roundedBorder)
            Button("Unlock") {
                if KeychainPIN.hasPIN {
                    unlocked = KeychainPIN.verifyPIN(pinInput)
                } else if pinInput.count == 4 {
                    KeychainPIN.savePIN(pinInput)
                    unlocked = true
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(pinInput.count != 4)
            if KeychainPIN.hasPIN {
                Text("First time? Ask a parent to set the PIN here.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background.ignoresSafeArea())
    }

    private var settingsForm: some View {
        Form {
            Section("Experience") {
                Toggle("Sound effects", isOn: $settings.soundEffectsEnabled)
                Toggle("Voice encouragement", isOn: $settings.voiceGuidanceEnabled)
                Toggle("Haptics", isOn: $settings.hapticsEnabled)
            }

            Section("Defaults") {
                Picker("Default difficulty", selection: Binding(
                    get: { settings.defaultDifficulty },
                    set: { settings.defaultDifficulty = $0 }
                )) {
                    ForEach(Difficulty.allCases) { d in
                        Text(d.friendlyLabel).tag(d)
                    }
                }
                Picker("Default question count", selection: $settings.defaultQuestionCount) {
                    Text("5").tag(5)
                    Text("10").tag(10)
                    Text("20").tag(20)
                }
            }

            Section("Parent PIN") {
                SecureField("New PIN", text: $newPIN)
                    .keyboardType(.numberPad)
                SecureField("Confirm PIN", text: $confirmPIN)
                    .keyboardType(.numberPad)
                Button("Update PIN") {
                    guard newPIN.count == 4, newPIN == confirmPIN else { return }
                    KeychainPIN.savePIN(newPIN)
                    newPIN = ""
                    confirmPIN = ""
                }
            }

            Section {
                Button("Reset All Progress", role: .destructive) {
                    showResetConfirm = true
                }
            }
        }
        .confirmationDialog("Reset all practice history?", isPresented: $showResetConfirm, titleVisibility: .visible) {
            Button("Reset", role: .destructive) {
                progressStore.resetAll()
                rewardsStore.resetAll()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
