import SwiftUI

struct SettingsScene: View {
    @State private var soundEnabled: Bool = true
    @State private var musicEnabled: Bool = true
    @State private var difficulty: Double = 1.0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Audio Settings")) {
                    Toggle(isOn: $soundEnabled) {
                        Text("Sound Effects")
                    }
                    Toggle(isOn: $musicEnabled) {
                        Text("Music")
                    }
                }
                
                Section(header: Text("Gameplay")) {
                    HStack {
                        Text("Difficulty")
                        Slider(value: $difficulty, in: 0...2, step: 1)
                    }
                }
                
                Section {
                    Button("Reset Settings") {
                        soundEnabled = true
                        musicEnabled = true
                        difficulty = 1.0
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

struct SettingsScene_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScene()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}
