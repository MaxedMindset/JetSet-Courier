import SwiftUI

struct StartFlightView: View {
    // Flugzustände und Steuerungsvariablen
    @State private var isAirborne: Bool = false
    @State private var speed: CGFloat = 0.0
    @State private var altitude: CGFloat = 0.0      // Negativer Wert = höher (Verschiebung nach oben)
    @State private var horizontalOffset: CGFloat = 0.0
    @State private var roll: CGFloat = 0.0            // Flugzeugrollung (Rotation)
    @State private var yaw: CGFloat = 0.0             // Seitliche Steuerung (links/rechts)
    
    // Beispielhaftes Ziel für die Minimap (Koordinaten im Minimap-System)
    let destination = CGPoint(x: 80, y: 20)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1. Hintergrund: Runway oder Open-World-Karte
                Image(isAirborne ? "openWorldMap" : "runwayBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // 2. Polizeiautos (nur, solange noch nicht abgehoben)
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
                    .transition(.opacity)
                }
                
                // 3. Das Flugzeug
                Image("airplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    // Rollung (Rotation) anwenden
                    .rotationEffect(Angle(degrees: Double(roll)))
                    // Mit Offset: horizontal (Steuerung) und vertikal (Altitude)
                    .offset(x: horizontalOffset, y: -altitude)
                    // Positioniert auf der unteren Bildschirmhälfte
                    .position(x: geometry.size.width/2, y: geometry.size.height * 0.8)
                    // Wischgesten: Vertikal = Höhe; Horizontal = Roll
                    .gesture(
                        DragGesture(minimumDistance: 20)
                            .onChanged { value in
                                let translation = value.translation
                                if abs(translation.height) > abs(translation.width) {
                                    // Vertikaler Swipe: Höhe anpassen (hier vereinfacht)
                                    altitude = translation.height * -1  // nach oben = negativer Y-Offset
                                } else {
                                    // Horizontaler Swipe: Rollung anpassen
                                    roll = translation.width / 5
                                }
                            }
                    )
                
                // 4. Oben links: Minimap (zeigt grob die Route zum Ziel)
                VStack {
                    HStack {
                        MiniMapView(currentPosition: CGPoint(x: horizontalOffset, y: altitude), destination: destination)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
                
                // 5. Unten links: Speedometer
                VStack {
                    Spacer()
                    HStack {
                        SpeedometerView(speed: speed)
                            .frame(width: 120, height: 60)
                            .padding()
                        Spacer()
                    }
                }
                
                // 6. Unten rechts: Control Panel (Gas und Brake)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ControlPanelView(onAccelerate: {
                            // Beschleunigen: Geschwindigkeit erhöhen
                            speed += 10
                            // Sobald Mindestgeschwindigkeit erreicht ist, hebt das Flugzeug ab
                            if !isAirborne && speed > 50 {
                                withAnimation {
                                    isAirborne = true
                                }
                            }
                        }, onBrake: {
                            // Bremsen: Geschwindigkeit verringern (nicht unter 0)
                            speed = max(speed - 10, 0)
                        })
                        .frame(width: 120, height: 60)
                        .padding()
                    }
                }
                
                // 7. Linke und rechte Steuerung durch transparente Tasten
                HStack(spacing: 0) {
                    // Linke Hälfte: Steuern nach links
                    Button(action: {
                        yaw -= 5
                        horizontalOffset -= 10  // einfache seitliche Anpassung
                    }) {
                        Color.clear
                    }
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height)
                    
                    // Rechte Hälfte: Steuern nach rechts
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

/// MARK: - Unteransichten

// MiniMapView: Zeigt einen einfachen runden Überblick mit einer Linie zur Zielposition
struct MiniMapView: View {
    let currentPosition: CGPoint
    let destination: CGPoint
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.3))
            // Einfache Routenanzeige (Linie von der Mitte zu einer Zielmarkierung)
            Path { path in
                let center = CGPoint(x: 50, y: 50)
                path.move(to: center)
                // Hier wird der Zielpunkt vereinfacht in den Minimap-Koordinaten dargestellt
                let destPoint = CGPoint(x: 50 + destination.x/2, y: 50 - destination.y/2)
                path.addLine(to: destPoint)
            }
            .stroke(Color.white, lineWidth: 2)
            
            // Zielmarkierung
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
                .position(x: 50 + destination.x/2, y: 50 - destination.y/2)
        }
    }
}

// SpeedometerView: Zeigt die aktuelle Geschwindigkeit an
struct SpeedometerView: View {
    let speed: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.5))
            Text("Speed: \(Int(speed))")
                .foregroundColor(.white)
                .font(.headline)
        }
    }
}

// ControlPanelView: Zwei Buttons für Gasgeben und Bremsen
struct ControlPanelView: View {
    let onAccelerate: () -> Void
    let onBrake: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: onBrake) {
                Text("Brake")
                    .frame(width: 50, height: 40)
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: onAccelerate) {
                Text("Gas")
                    .frame(width: 50, height: 40)
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
