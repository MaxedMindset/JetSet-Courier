import SwiftUI

struct StartFlightView: View {
    // Flugzustände und Steuerungsvariablen
    @State private var isAirborne: Bool = false
    @State private var speed: CGFloat = 0.0
    @State private var altitude: CGFloat = 0.0      // Negative Werte = höher (auf dem Bildschirm nach oben verschoben)
    @State private var horizontalOffset: CGFloat = 0.0
    @State private var roll: CGFloat = 0.0            // Rotation (Roll)
    @State private var yaw: CGFloat = 0.0             // Seitliche Steuerung (links/rechts)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1. Hintergrund: Wenn airborne -> Open-World-Map, sonst Runway
                if isAirborne {
                    ProceduralOpenWorldMapView()
                        .ignoresSafeArea()
                } else {
                    Image("runwayBackground")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                }
                
                // 2. Polizeiautos nur auf der Landebahn, bevor abgehoben wird
                if !isAirborne {
                    Group {
                        Image("policeCar")
                            .resizable()
                            .frame(width: 80, height: 40)
                            .position(x: 80, y: geometry.size.height - 100)
                        Image("policeCar")
                            .resizable()
                            .frame(width: 80, height: 40)
                            .position(x: geometry.size.width - 80, y: geometry.size.height - 100)
                    }
                }
                
                // 3. Das Flugzeug
                Image("airplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .rotationEffect(Angle(degrees: Double(roll)))
                    .offset(x: horizontalOffset, y: -altitude)
                    // Positioniere das Flugzeug relativ zur Bildschirmgröße (unten zentriert)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.8)
                    .gesture(
                        DragGesture(minimumDistance: 20)
                            .onChanged { value in
                                let translation = value.translation
                                if abs(translation.height) > abs(translation.width) {
                                    // Vertikaler Swipe: Höhe anpassen (nach oben bedeutet höher)
                                    altitude = translation.height * -1
                                } else {
                                    // Horizontaler Swipe: Roll-Wert anpassen
                                    roll = translation.width / 5
                                }
                            }
                    )
                
                // 4. UI-Overlays
                VStack {
                    HStack {
                        // Minimap-Overlay (Platzhalter)
                        Circle()
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 100, height: 100)
                            .overlay(Text("Minimap").foregroundColor(.white))
                            .padding()
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        // Speedometer-Overlay
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 120, height: 60)
                            .overlay(Text("Speed: \(Int(speed))").foregroundColor(.white))
                            .padding()
                        Spacer()
                        // Control Panel für Gasgeben und Bremsen
                        VStack(spacing: 10) {
                            Button(action: {
                                // Gas geben: Geschwindigkeit erhöhen
                                speed += 10
                                // Sobald Mindestgeschwindigkeit erreicht ist, hebt das Flugzeug ab
                                if !isAirborne && speed > 50 {
                                    withAnimation {
                                        isAirborne = true
                                    }
                                }
                            }) {
                                Text("Gas")
                                    .frame(width: 60, height: 40)
                                    .background(Color.green.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                // Bremsen: Geschwindigkeit verringern
                                speed = max(speed - 10, 0)
                            }) {
                                Text("Brake")
                                    .frame(width: 60, height: 40)
                                    .background(Color.red.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                }
                
                // 5. Transparente Tasten zur seitlichen Steuerung (links/rechts)
                HStack(spacing: 0) {
                    Button(action: {
                        yaw -= 5
                        horizontalOffset -= 10  // einfache seitliche Verschiebung
                    }) {
                        Color.clear
                    }
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height)
                    
                    Button(action: {
                        yaw += 5
                        horizontalOffset += 10
                    }) {
                        Color.clear
                    }
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct StartFlightView_Previews: PreviewProvider {
    static var previews: some View {
        StartFlightView()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}
