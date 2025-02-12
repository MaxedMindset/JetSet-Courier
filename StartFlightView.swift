//
//  StartFlightView.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Diese SwiftUI-View bettet einen SKView ein, der die FlightScene (Flugmodus) lädt.
//  Stelle sicher, dass FlightScene.swift im Projekt vorhanden und korrekt implementiert ist.
//
import SwiftUI
import SpriteKit

struct StartFlightView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: UIScreen.main.bounds)
        let scene = FlightScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Dynamische Updates falls nötig
    }
}

struct StartFlightView_Previews: PreviewProvider {
    static var previews: some View {
        StartFlightView().edgesIgnoringSafeArea(.all)
    }
}
