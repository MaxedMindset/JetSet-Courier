import SwiftUI
import SpriteKit
import CoreGraphics
import Foundation

// UIViewRepresentable, um die Hangar-Szene in SwiftUI einzubetten
struct BuildYourPlaneView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: UIScreen.main.bounds)
        let scene = HangarScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Hier kannst du Updates an die Szene übergeben (z.B. via Notification oder Shared Manager)
    }
}

// Container-View mit SwiftUI-Oberfläche, die zusätzliche UI-Elemente über dem SKView anzeigt
struct BuildYourPlaneContainer: View {
    // Beispielhafte Parameter – in einer echten App sollten diese an einen zentralen Manager übergeben werden.
    @State private var weight: CGFloat = 100.0
    @State private var lift: CGFloat = 100.0
    @State private var thrust: CGFloat = 100.0
    
    var body: some View {
        ZStack {
            // Der SKView mit der HangarScene
            BuildYourPlaneView()
                .edgesIgnoringSafeArea(.all)
            
            // Overlay: UI-Elemente zur Anpassung der Flugzeugkonfiguration
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Flugzeug Konfiguration")
                        .font(.headline)
                        .foregroundColor(.white)
                    HStack {
                        Text("Gewicht: \(Int(weight))")
                            .foregroundColor(.white)
                        Slider(value: $weight, in: 50...200)
                    }
                    HStack {
                        Text("Auftrieb: \(Int(lift))")
                            .foregroundColor(.white)
                        Slider(value: $lift, in: 50...200)
                    }
                    HStack {
                        Text("Schub: \(Int(thrust))")
                            .foregroundColor(.white)
                        Slider(value: $thrust, in: 50...200)
                    }
                    Button(action: {
                        // Hier kannst du z. B. die aktuellen Werte an deinen Configuration Manager übergeben
                        print("Test: Gewicht: \(weight), Auftrieb: \(lift), Schub: \(thrust)")
                        // Optional: Sende eine Notification an die HangarScene, damit diese ihre Konfiguration aktualisiert.
                    }) {
                        Text("Test Configuration")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.6))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

struct BuildYourPlaneContainer_Previews: PreviewProvider {
    static var previews: some View {
        BuildYourPlaneContainer()
    }
}
