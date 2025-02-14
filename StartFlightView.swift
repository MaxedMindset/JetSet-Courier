import SwiftUI
import GameplayKit
import Combine

struct StartFlightView: View {
    // Flugzustände und Steuerungsvariablen
    @State private var isAirborne: Bool = false
    @State private var speed: CGFloat = 0.0          // Aktuelle Fluggeschwindigkeit
    @State private var altitude: CGFloat = 0.0       // Visuelle Flughöhe (über Swipe-Gesten)
    
    // Simulation der Flugposition (Weltkoordinaten) und Flugrichtung (in Grad)
    @State private var flightPosition: CGPoint = CGPoint(x: 400, y: 400)
    @State private var flightDirection: CGFloat = 0.0  // 0° = nach rechts
    // Yaw steuert, wie stark das Flugzeug links/rechts dreht
    @State private var yaw: CGFloat = 0.0
    // Roll ist rein optisch (vom Swipe gesteuert)
    @State private var roll: CGFloat = 0.0
    
    // Zielposition in Weltkoordinaten
    let destination: CGPoint = CGPoint(x: 900, y: 900)
    
    // Timer zur kontinuierlichen Aktualisierung (ca. 50 FPS)
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1. Hintergrund: Bei Abheben wird die prozedurale Open-World-Map angezeigt,
                //    sonst der statische Runway-Hintergrund.
                if isAirborne {
                    ProceduralOpenWorldMapView()
                        // Die Kamera folgt dem Flugzeug: Wir verschieben die Map so, dass
                        // der aktuelle Flugpositions-Punkt immer in der Mitte liegt.
                        .offset(x: geometry.size.width/2 - flightPosition.x,
                                y: geometry.size.height/2 - flightPosition.y)
                        .animation(.easeInOut, value: flightPosition)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Image("runwayBackground")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                }
                
                // 2. Das Flugzeug (als feste Kamera in der Bildschirmmitte)
                Image("airplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    // Der Rollwinkel (optisch) wird per Wisch gesteuert.
                    .rotationEffect(Angle(degrees: Double(roll)))
                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
                    // Wischgesten: Vertikal steuert Altitude, horizontal den Rollwinkel.
                    .gesture(
                        DragGesture(minimumDistance: 10)
                            .onChanged { value in
                                altitude = -value.translation.height   // nach oben wischen → höhere Altitude
                                roll = value.translation.width / 5       // rollt je nach horizontaler Bewegung
                            }
                            .onEnded { _ in
                                // Bei Loslassen setzen wir den Rollwinkel zurück.
                                roll = 0
                            }
                    )
                
                // 3. UI-Overlays (Minimap, Speedometer, Control Panel)
                VStack {
                    HStack {
                        // Voll funktionsfähige Minimap: Zeigt Flugposition, Route und Ziel.
                        MinimapView(flightPosition: flightPosition, destination: destination)
                            .frame(width: 120, height: 120)
                            .padding()
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        // Unten links: Speedometer
                        Text("Speed: \(Int(speed))")
                            .padding(8)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .padding(.leading)
                        Spacer()
                        // Unten rechts: Control Panel mit Gas- und Brake-Buttons
                        VStack(spacing: 10) {
                            Button(action: {
                                // Gas geben: Geschwindigkeit erhöhen.
                                speed += 5
                                // Sobald eine Mindestgeschwindigkeit erreicht ist, hebt das Flugzeug ab.
                                if !isAirborne && speed > 50 {
                                    withAnimation {
                                        isAirborne = true
                                    }
                                }
                            }) {
                                Text("Gas")
                                    .frame(width: 60, height: 40)
                                    .background(Color.green)
             
