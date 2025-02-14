import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Versuche, den SKView zu erhalten
        if let skView = self.view as? SKView {
            // Erstelle die GameScene und konfiguriere sie
            let scene = GameScene(size: skView.bounds.size)
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            
            skView.ignoresSiblingOrder = true
            
            // FPS- und Knotenanzahl-Anzeige zum Debuggen
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// Eine einfache GameScene zur Demonstration
class GameScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let label = SKLabelNode(text: "Game Started")
        label.fontSize = 40
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
    }
}
