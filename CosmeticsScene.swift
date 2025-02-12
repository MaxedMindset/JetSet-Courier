//
//  CosmeticsScene.swift
//  SkyCraftBuildAndFly
//
//  Diese Szene zeigt einen Platzhalter für kosmetische Upgrades des Flugzeugs.
//  Hier könnte der Spieler verschiedene Skins, Lackierungen und Effekte auswählen.
//
import SpriteKit

class CosmeticsScene: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        
        let titleLabel = SKLabelNode(text: "Cosmetics")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 40
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: size.width/2, y: size.height*0.75)
        addChild(titleLabel)
        
        let infoLabel = SKLabelNode(text: "Komm bald zurück für mehr Anpassungsoptionen!")
        infoLabel.fontName = "AvenirNext-Bold"
        infoLabel.fontSize = 24
        infoLabel.fontColor = SKColor.white
        infoLabel.position = CGPoint(x: size.width/2, y: size.height*0.6)
        addChild(infoLabel)
        
        let backButton = SKLabelNode(text: "Back")
        backButton.name = "backButton"
        backButton.fontName = "AvenirNext-Bold"
        backButton.fontSize = 30
        backButton.fontColor = SKColor.red
        backButton.position = CGPoint(x: size.width/2, y: size.height*0.2)
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            if node.name == "backButton" {
                let mainMenu = MainMenuScene(size: size)
                mainMenu.scaleMode = .aspectFill
                self.view?.presentScene(mainMenu, transition: SKTransition.fade(withDuration: 1.0))
            }
        }
    }
}
