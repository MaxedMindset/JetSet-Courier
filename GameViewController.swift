//
//  GameViewController.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Lädt die erste Szene (MainMenuScene) in einem SKView
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let skView = self.view as? SKView {
            let scene = MainMenuScene(size: skView.bounds.size)
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            
            // Debug-Optionen
            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
    }
    
    override func loadView() {
        self.view = SKView(frame: UIScreen.main.bounds)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
