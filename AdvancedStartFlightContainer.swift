//
//  AdvancedStartFlightContainer.swift
//  SkyCraftBuildAndFly
//
//  Diese View integriert die FlightScene in eine SwiftUI-Umgebung und erweitert das HUD um
//  zusätzliche Schaltflächen (z. B. Pause, Boost) und Animationen für den Spielstart sowie Game Over-Übergänge.
//

import SwiftUI
import SpriteKit
import CoreGraphics

struct AdvancedStartFlightView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: UIScreen.main.bounds)
        let scene = FlightScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        return skView
    }
    func updateUIView(_ uiView: SKView, context: Context) { }
}

struct AdvancedStartFlightContainer: View {
    @ObservedObject var stats = FlightStatsManager.shared
    @State private var paused: Bool = false
    
    var body: some View {
        ZStack {
            AdvancedStartFlightView()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Speed: \(Int(stats.currentSpeed)) km/h")
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    Spacer()
                    Text("Altitude: \(Int(stats.currentAltitude)) m")
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }
                .padding(.top, 40)
                
                HStack {
                    Text("Fuel: \(Int(stats.fuelLevel))%")
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    Spacer()
                    Text("Time: \(String(format: "%.1f s", stats.flightTime))")
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }
                .padding(.top, 10)
                
                Spacer()
                
                HStack(spacing: 40) {
                    // Pause / Resume Button
                    Button(action: {
                        paused.toggle()
                        // Sende eine Benachrichtigung oder rufe in der FlightScene eine Pause-Methode auf
                        NotificationCenter.default.post(name: Notification.Name("TogglePause"), object: paused)
                    }) {
                        Image(systemName: paused ? "play.circle.fill" : "pause.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                    }
                    
                    // Boost Button
                    Button(action: {
                        // Sende Boost-Impulse an die FlightScene
                        NotificationCenter.default.post(name: Notification.Name("BoostImpulse"), object: nil)
                    }) {
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            stats.resetStats()
            stats.startTracking()
        }
        .onDisappear {
            stats.stopTracking()
        }
    }
}

struct AdvancedStartFlightContainer_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedStartFlightContainer()
    }
}
