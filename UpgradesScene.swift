//
//  UpgradesScene.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  In dieser Szene kann der Spieler Upgrades für sein Flugzeug erwerben, die dessen
//  physikalische Parameter verbessern. Upgrades werden mit In-Game-Währung gekauft.
//

import SpriteKit

class UpgradesScene: SKScene {
    var currencyLabel: SKLabelNode!
    var upgradeButtons: [SKLabelNode] = []
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        
        let title = SKLabelNode(text: "Upgrades")
        title.fontSize = 40
        title.fontColor = .white
        title.position = CGPoint(x: size.width/2, y: size.height*0.85)
        addChild(title)
        
        // Zeige die aktuelle Währung
        currencyLabel = SKLabelNode(text: "Currency: \(UpgradesManager.shared.inGameCurrency)")
        currencyLabel.fontSize = 28
        currencyLabel.fontColor = .yellow
        currencyLabel.position = CGPoint(x: size.width/2, y: size.height*0.75)
        addChild(currencyLabel)
        
        // Erstelle Upgrade-Buttons
        for (index, upgrade) in UpgradesManager.shared.availableUpgrades.enumerated() {
            let button = SKLabelNode(text: "\(upgrade.name) - \(upgrade.cost)")
            button.name = "upgrade_\(index)"
            button.fontSize = 30
            button.fontColor = .green
            button.position = CGPoint(x: size.width/2, y: size.height*0.6 - CGFloat(index) * 40)
            addChild(button)
            upgradeButtons.append(button)
        }
        
        let backButton = SKLabelNode(text: "Back")
        backButton.name = "backButton"
        backButton.fontSize = 30
        backButton.fontColor = .red
        backButton.position = CGPoint(x: size.width/2, y: size.height*0.2)
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            if let name = node.name {
                if name == "backButton" {
                    let hangarScene = HangarScene(size: size)
                    hangarScene.scaleMode = .aspectFill
                    self.view?.presentScene(hangarScene, transition: SKTransition.fade(withDuration: 1.0))
                } else if name.hasPrefix("upgrade_") {
                    let indexString = name.replacingOccurrences(of: "upgrade_", with: "")
                    if let index = Int(indexString) {
                        let upgrade = UpgradesManager.shared.availableUpgrades[index]
                        if UpgradesManager.shared.purchaseUpgrade(upgrade) {
                            // Upgrade anwenden: Passe die aktuelle Aircraft-Konfiguration an
                            var config = AircraftConfigurationManager.shared.configuration
                            config.weight *= upgrade.weightModifier
                            config.lift *= upgrade.liftModifier
                            config.thrust *= upgrade.thrustModifier
                            AircraftConfigurationManager.shared.configuration = config
                            
                            let confirmation = SKLabelNode(text: "Upgrade \(upgrade.name) purchased!")
                            confirmation.fontSize = 28
                            confirmation.fontColor = .green
                            confirmation.position = CGPoint(x: size.width/2, y: size.height*0.5)
                            confirmation.zPosition = 100
                            addChild(confirmation)
                            confirmation.run(SKAction.sequence([SKAction.wait(forDuration: 2.0),
                                                                SKAction.fadeOut(withDuration: 1.0),
                                                                SKAction.removeFromParent()]))
                        } else {
                            let errorLabel = SKLabelNode(text: "Not enough currency!")
                            errorLabel.fontSize = 28
                            errorLabel.fontColor = .red
                            errorLabel.position = CGPoint(x: size.width/2, y: size.height*0.5)
                            errorLabel.zPosition = 100
                            addChild(errorLabel)
                            errorLabel.run(SKAction.sequence([SKAction.wait(forDuration: 2.0),
                                                              SKAction.fadeOut(withDuration: 1.0),
                                                              SKAction.removeFromParent()]))
                        }
                        // Update currency display
                        currencyLabel.text = "Currency: \(UpgradesManager.shared.inGameCurrency)"
                    }
                }
            }
        }
    }
}
