//
//  FlightScene.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  In dieser Szene wird das Flugzeug (mit den im Hangar gewählten Parametern)
//  in einer offenen, urbanen Umgebung geflogen. Der Spieler muss ein Paket abliefern,
//  Hindernissen ausweichen und dabei unter einem maximalen Höhenlimit bleiben,
//  weil in großer Höhe die Luft dünner wird und der Schub nachlässt.
//  Zudem wird der Spieler von feindlichen Polizeieinheiten verfolgt.
// 

import SpriteKit

class FlightScene: SKScene, SKPhysicsContactDelegate {
    var aircraft: Aircraft!
    var packageNode: SKSpriteNode!
    var policeNodes: [SKSpriteNode] = []
    
    // Physics-Kategorien
    struct PhysicsCategory {
        static let aircraft: UInt32 = 0b1
        static let obstacle: UInt32 = 0b10
        static let package: UInt32 = 0b100
        static let police: UInt32 = 0b1000
        static let ground: UInt32 = 0b10000
    }
    
    // Maximale Flughöhe (z. B. wegen dünner Luft oder feindlicher Drohnen)
    var maxAltitude: CGFloat = 800
    var currentAltitude: CGFloat = 0
    
    var scoreLabel: SKLabelNode!
    var packageDelivered: Bool = false
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .cyan
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        // Boden
        let ground = SKSpriteNode(color: .brown, size: CGSize(width: size.width*2, height: 100))
        ground.position = CGPoint(x: 0, y: 0)
        ground.anchorPoint = CGPoint.zero
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size, center: CGPoint(x: ground.size.width/2, y: ground.size.height/2))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        addChild(ground)
        
        // Flugzeug anhand der Konfiguration bauen
        let config = AircraftConfigurationManager.shared.configuration
        aircraft = Aircraft(configuration: config)
        aircraft.position = CGPoint(x: size.width * 0.2, y: 150)
        addChild(aircraft)
        aircraft.startEngine()
        
        // Paket
        packageNode = SKSpriteNode(imageNamed: "package")
        packageNode.position = CGPoint(x: size.width*1.5, y: 200)
        packageNode.setScale(0.8)
        packageNode.physicsBody = SKPhysicsBody(rectangleOf: packageNode.size)
        packageNode.physicsBody?.isDynamic = false
        packageNode.physicsBody?.categoryBitMask = PhysicsCategory.package
        addChild(packageNode)
        
        // Score Label
        scoreLabel = SKLabelNode(text: "Deliver the Package!")
        scoreLabel.fontSize = 28
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height-50)
        addChild(scoreLabel)
        
        // Polizei spawnen periodisch
        let spawnPolice = SKAction.run { [weak self] in
            self?.spawnPolice()
        }
        let wait = SKAction.wait(forDuration: 5.0)
        run(SKAction.repeatForever(SKAction.sequence([spawnPolice, wait])))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Berechne aktuelle Flughöhe
        currentAltitude = aircraft.position.y
        
        // Wenn die Flughöhe zu hoch ist, wendet sich der Auftrieb – simuliert durch einen zusätzlichen Abwärtsimpuls.
        if aircraft.position.y > maxAltitude {
            aircraft.applyStallEffect()
            scoreLabel.text = "Too High! Thin Air!"
        }
        
        // Kamera folgt dem Flugzeug (hier einfach ein leichtes Verschieben des Szenen-Inhalts)
        self.anchorPoint = CGPoint(x: 0.3, y: 0.5)
        
        // Paketabgabe: Sobald das Flugzeug am Paket vorbeifliegt
        if !packageDelivered, aircraft.position.x > packageNode.position.x {
            deliverPackage()
        }
    }
    
    func spawnPolice() {
        let police = SKSpriteNode(imageNamed: "policeHelicopter")
        police.position = CGPoint(x: size.width + 100, y: size.height * 0.8)
        police.setScale(0.5)
        police.physicsBody = SKPhysicsBody(rectangleOf: police.size)
        police.physicsBody?.isDynamic = false
        police.physicsBody?.categoryBitMask = PhysicsCategory.police
        addChild(police)
        policeNodes.append(police)
        
        let moveAction = SKAction.moveBy(x: -size.width - 200, y: 0, duration: 10)
        let removeAction = SKAction.removeFromParent()
        police.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    func deliverPackage() {
        packageDelivered = true
        packageNode.removeFromParent()
        scoreLabel.text = "Package Delivered! Mission Accomplished!"
        let wait = SKAction.wait(forDuration: 3.0)
        let endAction = SKAction.run { [weak self] in
            self?.endGame()
        }
        run(SKAction.sequence([wait, endAction]))
    }
    
    func endGame() {
        let mainMenu = MainMenuScene(size: size)
        mainMenu.scaleMode = .aspectFill
        self.view?.presentScene(mainMenu, transition: SKTransition.fade(withDuration: 1.0))
    }
    
    // Kontaktbehandlung
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.categoryBitMask == PhysicsCategory.aircraft &&
           secondBody.categoryBitMask == PhysicsCategory.police {
            endGame()
        }
        if firstBody.categoryBitMask == PhysicsCategory.aircraft &&
           secondBody.categoryBitMask == PhysicsCategory.package {
            deliverPackage()
        }
    }
    
    // Steuerung: Mit Touch-Gesten kann man das Flugzeug in der Höhe anpassen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        // Ist der Touch im oberen Teil des Bildschirms, soll das Flugzeug steigen, im unteren sinken.
        if location.y > size.height/2 {
            aircraft.ascend()
        } else {
            aircraft.descend()
        }
    }
}
