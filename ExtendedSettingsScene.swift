//
//  ExtendedSettingsScene.swift
//  SkyCraftBuildAndFly
//
//  Diese Szene bietet erweiterte Einstellungen, z. B. Grafikqualität, Steuerungsoptionen
//  und Sound-Einstellungen. Hier können Spieler das Spiel individuell anpassen.
//
import SpriteKit

class ExtendedSettingsScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.darkGray
        
        let titleLabel = SKLabelNode(text: "Erweiterte Einstellungen")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 40
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        addChild(titleLabel)
        
        // Beispieloptionen
        let graphicsOption = SKLabelNode(text: "Grafik: High")
        graphicsOption.fontName = "AvenirNext-Bold"
        graphicsOption.fontSize = 30
        graphicsOption.fontColor = SKColor.white
        graphicsOption.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        graphicsOption.name = "graphicsOption"
        addChild(graphicsOption)
        
        let controlOption = SKLabelNode(text: "Steuerung: Touch")
        controlOption.fontName = "AvenirNext-Bold"
        controlOption.fontSize = 30
        controlOption.fontColor = SKColor.white
        controlOption.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        controlOption.name = "controlOption"
        addChild(controlOption)
        
        let soundOption = SKLabelNode(text: "Sound: On")
        soundOption.fontName = "AvenirNext-Bold"
        soundOption.fontSize = 30
        soundOption.fontColor = SKColor.white
        soundOption.position = CGPoint(x: size.width / 2, y: size.height * 0.45)
        soundOption.name = "soundOption"
        addChild(soundOption)
        
        let backButton = SKLabelNode(text: "Back")
        backButton.name = "backButton"
        backButton.fontName = "AvenirNext-Bold"
        backButton.fontSize = 30
        backButton.fontColor = SKColor.red
        backButton.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        for node in touchedNodes {
            if let nodeName = node.name {
                if nodeName == "backButton" {
                    let mainMenu = MainMenuScene(size: size)
                    mainMenu.scaleMode = .aspectFill
                    self.view?.presentScene(mainMenu, transition: SKTransition.fade(withDuration: 1.0))
                }
                // Hier können weitere Optionen per Touch getoggelt werden.
            }
        }
    }
}
