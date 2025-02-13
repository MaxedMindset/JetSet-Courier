//
//  ShopScene.swift
//  SkyCraftBuildAndFly
//
//  In dieser Szene kann der Spieler Upgrades erwerben, die funktionale Verbesserungen für sein Flugzeug bieten.
//  Das Shopsystem greift auf das persistente Wirtschaftssystem zu (über GameDataManager).
//

import SpriteKit

struct ShopItem {
    let name: String
    let description: String
    let cost: Int
    let weightModifier: CGFloat  // z.B. 0.9 reduziert Gewicht um 10%
    let liftModifier: CGFloat    // z.B. 1.15 erhöht Auftrieb um 15%
    let thrustModifier: CGFloat  // z.B. 1.2 erhöht Schub um 20%
}

class ShopScene: SKScene {
    var currencyLabel: SKLabelNode!
    var shopItems: [ShopItem] = []
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.darkGray
        
        let titleLabel = SKLabelNode(text: "Upgrade Shop")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 40
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: size.width/2, y: size.height*0.8)
        addChild(titleLabel)
        
        currencyLabel = SKLabelNode(text: "Coins: \(GameDataManager.shared.coins)")
        currencyLabel.fontName = "AvenirNext-Bold"
        currencyLabel.fontSize = 28
        currencyLabel.fontColor = SKColor.yellow
        currencyLabel.position = CGPoint(x: size.width/2, y: size.height*0.7)
        addChild(currencyLabel)
        
        setupShopItems()
        setupShopUI()
        
        let backButton = SKLabelNode(text: "Back")
        backButton.name = "backButton"
        backButton.fontName = "AvenirNext-Bold"
        backButton.fontSize = 30
        backButton.fontColor = SKColor.red
        backButton.position = CGPoint(x: size.width/2, y: size.height*0.1)
        addChild(backButton)
    }
    
    func setupShopItems() {
        shopItems.append(ShopItem(name: "Ultra Light Material",
                                  description: "Reduziert Gewicht um 10%",
                                  cost: 150,
                                  weightModifier: 0.90,
                                  liftModifier: 1.0,
                                  thrustModifier: 1.0))
        shopItems.append(ShopItem(name: "Advanced Aerodynamics",
                                  description: "Erhöht Auftrieb um 15%",
                                  cost: 200,
                                  weightModifier: 1.0,
                                  liftModifier: 1.15,
                                  thrustModifier: 1.0))
        shopItems.append(ShopItem(name: "Turbo Engine",
                                  description: "Erhöht Schub um 20%",
                                  cost: 250,
                                  weightModifier: 1.0,
                                  liftModifier: 1.0,
                                  thrustModifier: 1.20))
    }
    
    func setupShopUI() {
        for (index, item) in shopItems.enumerated() {
            let button = SKLabelNode(text: "\(item.name) - \(item.cost) coins")
            button.name = "upgrade_\(index)"
            button.fontName = "AvenirNext-Bold"
            button.fontSize = 30
            button.fontColor = SKColor.green
            button.position = CGPoint(x: size.width/2, y: size.height*0.6 - CGFloat(index * 40))
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
                    let mainMenu = MainMenuScene(size: size)
                    mainMenu.scaleMode = .aspectFill
                    self.view?.presentScene(mainMenu, transition: SKTransition.fade(withDuration: 1.0))
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
        let dataManager = GameDataManager.shared
        if dataManager.coins >= item.cost {
            dataManager.coins -= item.cost
            // Hier würden wir die Flugzeugkonfiguration (via AircraftConfigurationManager) anpassen.
            // Beispiel: AircraftConfigurationManager.shared.configuration.weight *= item.weightModifier
            let confirmation = SKLabelNode(text: "Purchased \(item.name)!")
            confirmation.fontName = "AvenirNext-Bold"
            confirmation.fontSize = 28
            confirmation.fontColor = SKColor.green
            confirmation.position = CGPoint(x: size.width/2, y: size.height*0.5)
            confirmation.zPosition = 100
            addChild(confirmation)
            let wait = SKAction.wait(forDuration: 2.0)
            confirmation.run(SKAction.sequence([wait, SKAction.fadeOut(withDuration: 1.0), SKAction.removeFromParent()]))
        } else {
            let errorLabel = SKLabelNode(text: "Not enough coins!")
            errorLabel.fontName = "AvenirNext-Bold"
            errorLabel.fontSize = 28
            errorLabel.fontColor = SKColor.red
            errorLabel.position = CGPoint(x: size.width/2, y: size.height*0.5)
            errorLabel.zPosition = 100
            addChild(errorLabel)
            let wait = SKAction.wait(forDuration: 2.0)
            errorLabel.run(SKAction.sequence([wait, SKAction.fadeOut(withDuration: 1.0), SKAction.removeFromParent()]))
        }
        currencyLabel.text = "Coins: \(GameDataManager.shared.coins)"
    }
}
