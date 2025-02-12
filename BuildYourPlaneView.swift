//
//  BuildYourPlaneView.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Diese SwiftUI-View bettet einen SKView ein, der die HangarScene (Flugzeugbau-Modus) lädt.
//  Stelle sicher, dass HangarScene.swift im Projekt vorhanden und korrekt implementiert ist.
//
import SwiftUI
import SpriteKit

struct BuildYourPlaneView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: UIScreen.main.bounds)
        let scene = HangarScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Hier kannst du dynamische Updates einbauen, falls nötig.
    }
}

struct BuildYourPlaneView_Previews: PreviewProvider {
    static var previews: some View {
        BuildYourPlaneView().edgesIgnoringSafeArea(.all)
    }
}
