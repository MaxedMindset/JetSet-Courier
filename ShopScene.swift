//
//  ShopScene.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  In dieser Szene kann der Spieler Upgrades für sein Flugzeug erwerben.
//  Die verfügbaren Artikel werden aufgelistet, und der Spieler kann sie kaufen,
//  sofern genügend In-Game-Währung vorhanden ist. Beim Kauf wird die aktuelle
//  Aircraft-Konfiguration (verwaltet über AircraftConfigurationManager) angepasst.
//
import SpriteKit

class ShopScene: SKScene {
    
    var currencyLabel: SKLabelNode!
    var shopItems: [ShopItem] = []
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .darkGray
        
        // Zeige den Titel der Szene
        let titleLabel = SKLabelNode(text: "Upgrade Shop")
        titleLabel.fontSize = 40
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width/2, y: size.height*0.85)
        addChild(titleLabel)
        
        // Zeige die aktuelle Währung
        currencyLabel = SKLabelNode(text: "Currency: \(UpgradesManager.shared.inGameCurrency)")
        currencyLabel.fontSize = 28
        currencyLabel.fontColor = .yellow
        currencyLabel.position = CGPoint(x: size.width/2, y: size.height*0.78)
        addChild(currencyLabel)
        
        // Erstelle Beispiel-Upgrades
        setupShopItems()
        
        // Erstelle UI-Elemente für jedes Upgrade
        setupShopUI()
        
        // Füge einen Back-Button hinzu, um zur vorherigen Szene (z. B. HangarScene) zurückzukehren
        let backButton = SKLabelNode(text: "Back")
        backButton.name = "backButton"
        backButton.fontSize = 30
        backButton.fontColor = .red
        backButton.position = CGPoint(x: size.width/2, y: size.height*0.1)
        addChild(backButton)
    }
    
    func setupShopItems() {
        // Beispiel-Upgrades hinzufügen
        shopItems.append(ShopItem(name: "Ultra Light Material",
                                  description: "Reduziert Gewicht um 15%",
                                  cost: 150,
                                  weightModifier: 0.85,
                                  liftModifier: 1.0,
                                  thrustModifier: 1.0))
        shopItems.append(ShopItem(name: "Advanced Aerodynamics",
                                  description: "Erhöht Auftrieb um 20%",
                                  cost: 200,
                                  weightModifier: 1.0,
                                  liftModifier: 1.20,
                                  thrustModifier: 1.0))
        shopItems.append(ShopItem(name: "Turbo Engine",
                                  description: "Erhöht Schub um 25%",
                                  cost: 250,
                                  weightModifier: 1.0,
                                  liftModifier: 1.0,
                                  thrustModifier: 1.25))
    }
    
    func setupShopUI() {
        // Erstelle einen Button (Label) für jedes Upgrade
        for (index, item) in shopItems.enumerated() {
            let button = SKLabelNode(text: "\(item.name) - \(item.cost) coins")
            button.name = "upgrade_\(index)"
            button.fontSize = 30
            button.fontColor = .green
            button.position = CGPoint(x: size.width/2, y: size.height*0.65 - CGFloat(index) * 40)
            addChild(button)
        }
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
                        purchaseItem(at: index)
                    }
                }
            }
        }
    }
    
    func purchaseItem(at index: Int) {
        let item = shopItems[index]
        let manager = UpgradesManager.shared
        if manager.inGameCurrency >= item.cost {
            manager.inGameCurrency -= item.cost
            
            // Aktualisiere die Aircraft-Konfiguration basierend auf dem Upgrade
            var config = AircraftConfigurationManager.shared.configuration
            config.weight *= item.weightModifier
            config.lift *= item.liftModifier
            config.thrust *= item.thrustModifier
            AircraftConfigurationManager.shared.configuration = config
            
            // Bestätigung anzeigen
            let confirmation = SKLabelNode(text: "Purchased \(item.name)!")
            confirmation.fontSize = 28
            confirmation.fontColor = .green
            confirmation.position = CGPoint(x: size.width/2, y: size.height*0.5)
            confirmation.zPosition = 100
            addChild(confirmation)
            let wait = SKAction.wait(forDuration: 2.0)
            confirmation.run(SKAction.sequence([wait, SKAction.fadeOut(withDuration: 1.0), SKAction.removeFromParent()]))
        } else {
            // Fehlermeldung anzeigen, wenn nicht genügend Coins vorhanden sind
            let errorLabel = SKLabelNode(text: "Not enough coins!")
            errorLabel.fontSize = 28
            errorLabel.fontColor = .red
            errorLabel.position = CGPoint(x: size.width/2, y: size.height*0.5)
            errorLabel.zPosition = 100
            addChild(errorLabel)
            let wait = SKAction.wait(forDuration: 2.0)
            errorLabel.run(SKAction.sequence([wait, SKAction.fadeOut(withDuration: 1.0), SKAction.removeFromParent()]))
        }
        // Aktualisiere das Währungsetikett
        currencyLabel.text = "Currency: \(manager.inGameCurrency)"
    }
}
