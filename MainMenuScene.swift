//  Diese Szene zeigt das Hauptmenü des Spiels an. Der Spieler sieht den Titel und mehrere Menüpunkte,
//  über die er zu den verschiedenen Spielmodi navigieren kann, einschließlich eines Karrieremodus ("Career Mode"),
//  der zu einer StoryScene führt, in der deine Storyline und Karrierefortschritte implementiert sind.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.blue
        
        setupMenu()
    }
    
    func setupMenu() {
        // Titel-Node
        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = "SkyCraft: Build & Fly"
        titleLabel.fontSize = 48
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.85)
        addChild(titleLabel)
        
        // Definiere Menüpunkte als Array: (Text, Name, Farbe)
        let menuItems = [
            ("Build Your Plane", "buildButton", SKColor.green),
            ("Start Flight", "flightButton", SKColor.yellow),
            ("Career Mode", "careerButton", SKColor.purple), // Neuer Menüpunkt für den Karrieremodus
            ("Shop", "shopButton", SKColor.orange),
            ("Settings", "settingsButton", SKColor.white)
        ]
        
        // Berechne Startposition und Abstand
        let baseY = size.height * 0.7
        let spacing: CGFloat = 60
        
        // Erstelle und füge jeden Button hinzu
        for (index, item) in menuItems.enumerated() {
            let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
            label.text = item.0
            label.name = item.1
            label.fontSize = 36
            label.fontColor = item.2
            label.position = CGPoint(x: size.width / 2, y: baseY - CGFloat(index) * spacing)
            label.zPosition = 1
            addChild(label)
            
            // Füge einen leichten Puls-Animationseffekt hinzu
            let pulseUp = SKAction.scale(to: 1.05, duration: 0.8)
            let pulseDown = SKAction.scale(to: 1.0, duration: 0.8)
            label.run(SKAction.repeatForever(SKAction.sequence([pulseUp, pulseDown])))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Debug: Ausgabe aller berührten Nodes
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        print("Touched nodes: \(touchedNodes.compactMap { $0.name })")
        
        for node in touchedNodes {
            if let nodeName = node.name {
                // Optionale Animation: Kurzes Aufblähen beim Berühren
                let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
                let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                node.run(SKAction.sequence([scaleUp, scaleDown]))
                
                // Überprüfe, welcher Button gedrückt wurde, und wechsle die Szene
                switch nodeName {
                case "buildButton":
                    print("Build Your Plane pressed")
                    let hangarScene = HangarScene(size: size)
                    hangarScene.scaleMode = .aspectFill
                    self.view?.presentScene(hangarScene, transition: SKTransition.fade(withDuration: 1.0))
                case "flightButton":
                    print("Start Flight pressed")
                    let flightScene = FlightScene(size: size)
                    flightScene.scaleMode = .aspectFill
                    self.view?.presentScene(flightScene, transition: SKTransition.fade(withDuration: 1.0))
                case "careerButton":
                    print("Career Mode pressed")
                    let storyScene = StoryScene(size: size)  // Stelle sicher, dass StoryScene.swift implementiert ist
                    storyScene.scaleMode = .aspectFill
                    self.view?.presentScene(storyScene, transition: SKTransition.fade(withDuration: 1.0))
                case "shopButton":
                    print("Shop pressed")
                    let shopScene = ShopScene(size: size)
                    shopScene.scaleMode = .aspectFill
                    self.view?.presentScene(shopScene, transition: SKTransition.fade(withDuration: 1.0))
                case "settingsButton":
                    print("Settings pressed")
                    let settingsScene = SettingsScene(size: size)
                    settingsScene.scaleMode = .aspectFill
                    self.view?.presentScene(settingsScene, transition: SKTransition.fade(withDuration: 1.0))
                default:
                    break
                }
            }
        }
    }
}
