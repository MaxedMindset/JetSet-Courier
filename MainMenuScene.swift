//
//  MainMenuScene.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//
//  Diese Szene zeigt das Hauptmenü des Spiels an. Der Spieler sieht den Titel und mehrere
//  Menüpunkte, über die er zu den verschiedenen Spielmodi (Flugzeugbau, Flugmodus, Shop, Settings)
//  navigieren kann.
//  Es werden Debug-Ausgaben ausgegeben, damit du nachvollziehen kannst, welche Buttons berührt werden.
//
import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.blue
        
        // Titel-Node
        let titleLabel = SKLabelNode(text: "SkyCraft: Build & Fly")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 48
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.75)
        addChild(titleLabel)
        
        // "Build Your Plane" Button
        let buildButton = SKLabelNode(text: "Build Your Plane")
        buildButton.name = "buildButton"
        buildButton.fontName = "AvenirNext-Bold"
        buildButton.fontSize = 36
        buildButton.fontColor = SKColor.green
        buildButton.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        addChild(buildButton)
        
        // "Start Flight" Button
        let flightButton = SKLabelNode(text: "Start Flight")
        flightButton.name = "flightButton"
        flightButton.fontName = "AvenirNext-Bold"
        flightButton.fontSize = 36
        flightButton.fontColor = SKColor.yellow
        flightButton.position = CGPoint(x: size.width / 2, y: size.height * 0.45)
        addChild(flightButton)
        
        // "Shop" Button
        let shopButton = SKLabelNode(text: "Shop")
        shopButton.name = "shopButton"
        shopButton.fontName = "AvenirNext-Bold"
        shopButton.fontSize = 30
        shopButton.fontColor = SKColor.orange
        shopButton.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
        addChild(shopButton)
        
        // "Settings" Button
        let settingsButton = SKLabelNode(text: "Settings")
        settingsButton.name = "settingsButton"
        settingsButton.fontName = "AvenirNext-Bold"
        settingsButton.fontSize = 30
        settingsButton.fontColor = SKColor.white
        settingsButton.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        addChild(settingsButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Debug: Ausgabe aller berührten Nodes
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        print("Touched nodes: \(nodesAtPoint.compactMap { $0.name })")
        
        // Prüfe, welcher Button gedrückt wurde
        for node in nodesAtPoint {
            if let nodeName = node.name {
                switch nodeName {
                case "buildButton":
                    print("Build button pressed")
                    let hangarScene = HangarScene(size: size)
                    hangarScene.scaleMode = .aspectFill
                    self.view?.presentScene(hangarScene, transition: SKTransition.fade(withDuration: 1.0))
                case "flightButton":
                    print("Flight button pressed")
                    let flightScene = FlightScene(size: size)
                    flightScene.scaleMode = .aspectFill
                    self.view?.presentScene(flightScene, transition: SKTransition.fade(withDuration: 1.0))
                case "shopButton":
                    print("Shop button pressed")
                    let shopScene = ShopScene(size: size)
                    shopScene.scaleMode = .aspectFill
                    self.view?.presentScene(shopScene, transition: SKTransition.fade(withDuration: 1.0))
                case "settingsButton":
                    print("Settings button pressed")
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
