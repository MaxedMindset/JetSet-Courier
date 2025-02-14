import SwiftUI

struct ExtendedSettingScene: View {
    // Audio Settings
    @State private var soundEffectsEnabled: Bool = true
    @State private var musicEnabled: Bool = true
    @State private var musicVolume: Double = 0.8

    // Grafik Settings
    @State private var graphicsQuality: String = "High"
    @State private var brightness: Double = 0.5

    // Steuerung
    @State private var invertedControls: Bool = false
    @State private var sensitivity: Double = 1.0

    // Erweiterte Einstellungen
    @State private var developerModeEnabled: Bool = false

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Audio Einstellungen
                Section(header: Text("Audio Settings")) {
                    Toggle(isOn: $soundEffectsEnabled) {
                        Text("Sound Effects")
                    }
                    Toggle(isOn: $musicEnabled) {
                        Text("Music")
                    }
                    if musicEnabled {
                        HStack {
                            Text("Music Volume")
                            Slider(value: $musicVolume, in: 0...1)
                        }
                    }
                }
                
                // MARK: - Grafik Einstellungen
                Section(header: Text("Graphics Settings")) {
                    Picker("Graphics Quality", selection: $graphicsQuality) {
                        Text("Low").tag("Low")
                        Text("Medium").tag("Medium")
                        Text("High").tag("High")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        Text("Brightness")
                        Slider(value: $brightness, in: 0...1)
                    }
                }
                
                // MARK: - Steuerung
                Section(header: Text("Controls")) {
                    Toggle(isOn: $invertedControls) {
                        Text("Inverted Controls")
                    }
                    
                    HStack {
                        Text("Sensitivity")
                        Slider(value: $sensitivity, in: 0.5...2.0)
                    }
                }
                
                // MARK: - Erweiterte Einstellungen
                Section(header: Text("Advanced Settings")) {
                    Toggle(isOn: $developerModeEnabled) {
                        Text("Developer Mode")
                    }
                    if developerModeEnabled {
                        Button(action: {
                            resetAdvancedSettings()
                        }) {
                            Text("Reset Advanced Options")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationBarTitle("Extended Settings", displayMode: .inline)
        }
    }
    
    // Funktion zum Zurücksetzen der erweiterten Einstellungen
    private func resetAdvancedSettings() {
        invertedControls = false
        sensitivity = 1.0
        graphicsQuality = "High"
    }
}

struct ExtendedSettingScene_Previews: PreviewProvider {
    static var previews: some View {
        ExtendedSettingScene()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}
