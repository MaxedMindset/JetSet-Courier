import SwiftUI
import SpriteKit
import CoreGraphics
import Foundation

// UIViewRepresentable, um die FlightScene einzubetten
struct StartFlightView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: UIScreen.main.bounds)
        let scene = FlightScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Hier kannst du Updates weitergeben, wenn nötig.
    }
}

// Container-View mit zusätzlichen HUD-Elementen
struct StartFlightContainer: View {
    // Beispielhafte Werte – in einer echten App werden diese Werte von der FlightScene (z. B. über Notifications oder Binding) geliefert.
    @State private var currentSpeed: CGFloat = 300
    @State private var altitude: CGFloat = 1500
    
    var body: some View {
        ZStack {
            StartFlightView()
                .edgesIgnoringSafeArea(.all)
            
            // HUD-Overlay
            VStack {
                HStack {
                    Text("Geschwindigkeit: \(Int(currentSpeed)) km/h")
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    Spacer()
                    Text("Höhe: \(Int(altitude)) m")
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }
                .padding(.top, 40)
                Spacer()
                // Optionale Steuerungselemente, z.B. Pause oder Boost-Buttons, können hier eingefügt werden.
            }
        }
        .onAppear {
            // Beispielsweise können hier Funktionen aufgerufen werden, um aktuelle Flugdaten abzurufen.
            // In diesem Beispiel setzen wir feste Dummy-Werte.
            currentSpeed = 300
            altitude = 1500
        }
    }
}

struct StartFlightContainer_Previews: PreviewProvider {
    static var previews: some View {
        StartFlightContainer()
    }
}
