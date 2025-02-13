//
//  FlightScene.swift
//  SkyCraftBuildAndFly
//
//  Erweiterte FlightScene mit realistischen aerodynamischen Effekten, HUD und animierten UI-Übergängen,
//  inklusive PhysicsCategory für Kollisionserkennung.
//

import SpriteKit
import CoreGraphics

// Definiere PhysicsCategory für die Kollisionserkennung
struct PhysicsCategory {
    static let none: UInt32      = 0
    static let plane: UInt32     = 0b1       // 1
    static let ground: UInt32    = 0b10      // 2
    static let obstacle: UInt32  = 0b100     // 4
    // Weitere Kategorien können hier hinzugefügt werden, z. B. für Power-Ups, Wände, etc.
}

class FlightScene: SKScene {
    
    var planeSprite: SKSpriteNode!
    
    // HUD-Labels
    var speedLabel: SKLabelNode!
    var altitudeLabel: SKLabelNode!
    var fuelLabel: SKLabelNode!
    var damageLabel: SKLabelNode!
    var flightTimeLabel: SKLabelNode!
    
    // Start-/Game-Over UI
    var tapToStartLabel: SKLabelNode!
    var gameOverOverlay: SKSpriteNode!
    var gameOverLabel: SKLabelNode!
    var restartButton: SKLabelNode!
    
    // Simulationseigenschaften
    var currentSpeed: CGFloat = 300.0
    var fuelLevel: CGFloat = 100.0
    var flightTime: TimeInterval = 0.0
    var gameOver: Bool = false
    
    // Zeitverwaltung
    var lastUpdateTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.cyan
        
        // Hintergrund
        let sky = SKSpriteNode(color: SKColor.cyan, size: self.size)
        sky.position = CGPoint(x: size.width/2, y: size.height/2)
        sky.zPosition = -2
        addChild(sky)
        
        // Flugzeug-Sprite einrichten
        planeSprite = SKSpriteNode(imageNamed: "aircraft_base")
        planeSprite.position = CGPoint(x: size.width * 0.2, y: size.height * 0.5)
        planeSprite.setScale(0.8)
        planeSprite.physicsBody = SKPhysicsBody(texture: planeSprite.texture!, size: planeSprite.size)
        planeSprite.physicsBody?.allowsRotation = false
        // Weisen Sie dem Flugzeug eine Kategorie zu
        planeSprite.physicsBody?.categoryBitMask = PhysicsCategory.plane
        planeSprite.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.obstacle
        planeSprite.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.obstacle
        addChild(planeSprite)
        
        // Back-Button
        backButton = SKLabelNode(fontNamed: "AvenirNext-Bold")
        backButton.text = "Back"
        backButton.name = "backButton"
        backButton.fontSize = 30
        backButton.fontColor = SKColor.red
        backButton.position = CGPoint(x: size.width/2, y: size.height * 0.1)
        addChild(backButton)
        
        // HUD Setup
        setupHUD()
        
        // "Tap to Start" Overlay
        tapToStartLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        tapToStartLabel.text = "Tap to Start"
        tapToStartLabel.fontSize = 36
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        tapToStartLabel.alpha = 0.0
        tapToStartLabel.zPosition = 10
        addChild(tapToStartLabel)
        tapToStartLabel.run(SKAction.fadeIn(withDuration: 1.0))
        
        // Game Over Overlay Setup
        setupGameOverOverlay()
        
        lastUpdateTime = 0
    }
    
    func setupHUD() {
        speedLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        speedLabel.fontSize = 24
        speedLabel.fontColor = SKColor.white
        speedLabel.position = CGPoint(x: 100, y: size.height - 40)
        speedLabel.zPosition = 5
        addChild(speedLabel)
        
        altitudeLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        altitudeLabel.fontSize = 24
        altitudeLabel.fontColor = SKColor.white
        altitudeLabel.position = CGPoint(x: size.width - 100, y: size.height - 40)
        altitudeLabel.zPosition = 5
        addChild(altitudeLabel)
        
        fuelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        fuelLabel.fontSize = 24
        fuelLabel.fontColor = SKColor.white
        fuelLabel.position = CGPoint(x: 100, y: size.height - 80)
        fuelLabel.zPosition = 5
        addChild(fuelLabel)
        
        damageLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        damageLabel.fontSize = 24
        damageLabel.fontColor = SKColor.white
        damageLabel.position = CGPoint(x: size.width - 100, y: size.height - 80)
        damageLabel.zPosition = 5
        addChild(damageLabel)
        
        flightTimeLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        flightTimeLabel.fontSize = 24
        flightTimeLabel.fontColor = SKColor.white
        flightTimeLabel.position = CGPoint(x: size.width/2, y: size.height - 40)
        flightTimeLabel.zPosition = 5
        addChild(flightTimeLabel)
    }
    
    func setupGameOverOverlay() {
        gameOverOverlay = SKSpriteNode(color: SKColor.black.withAlphaComponent(0.7), size: self.size)
        gameOverOverlay.position = CGPoint(x: size.width/2, y: size.height/2)
        gameOverOverlay.zPosition = 20
        gameOverOverlay.alpha = 0.0
        addChild(gameOverOverlay)
        
        gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: 0, y: 20)
        gameOverLabel.alpha = 0.0
        gameOverOverlay.addChild(gameOverLabel)
        
        restartButton = SKLabelNode(fontNamed: "AvenirNext-Bold")
        restartButton.text = "Restart"
        restartButton.name = "restartButton"
        restartButton.fontSize = 36
        restartButton.fontColor = SKColor.green
        restartButton.position = CGPoint(x: 0, y: -40)
        restartButton.alpha = 0.0
        gameOverOverlay.addChild(restartButton)
    }
    
    func updateHUD() {
        speedLabel.text = "Speed: \(Int(currentSpeed)) km/h"
        altitudeLabel.text = "Altitude: \(Int(planeSprite.position.y)) m"
        fuelLabel.text = "Fuel: \(Int(fuelLevel))%"
        damageLabel.text = "Damage: \(Int(0))%" // Hier kann zukünftige Schadenslogik eingefügt werden
        flightTimeLabel.text = String(format: "Time: %.1f s", flightTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Erstes Tippen entfernt das "Tap to Start" Overlay
        if tapToStartLabel.parent != nil {
            tapToStartLabel.run(SKAction.fadeOut(withDuration: 0.5)) {
                self.tapToStartLabel.removeFromParent()
            }
            return
        }
        
        // Game Over: Restart prüfen
        guard !gameOver, let touch = touches.first else {
            if gameOver, let touch = touches.first {
                let location = touch.location(in: gameOverOverlay)
                if gameOverOverlay.nodes(at: location).contains(where: { $0.name == "restartButton" }) {
                    restartGame()
                }
            }
            return
        }
        
        // Standard-Impulse beim Tippen: Aufwärtsimpuls
        let impulse = CGVector(dx: 0, dy: 50)
        planeSprite.physicsBody?.applyImpulse(impulse)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Delta Time berechnen
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        if gameOver { return }
        
        // Flugzeit erhöhen
        flightTime += dt
        
        // Simuliere Luftwiderstand
        let airResistance = currentSpeed * 0.02
        currentSpeed = max(0, currentSpeed - airResistance * CGFloat(dt))
        
        // Simuliere Auftrieb: Steigen oder Sinken
        if currentSpeed > 300 {
            planeSprite.position.y += 1 * CGFloat(dt * 60)
        } else {
            planeSprite.position.y -= 1 * CGFloat(dt * 60)
        }
        
        // Simuliere Wind und Turbulenzen
        let windForce = CGFloat.random(in: -5...5)
        let turbulenceForce = CGFloat.random(in: -3...3)
        planeSprite.physicsBody?.applyForce(CGVector(dx: windForce + turbulenceForce, dy: 0))
        
        // Treibstoffverbrauch simulieren
        fuelLevel = max(0, fuelLevel - 0.05 * CGFloat(dt * 60))
        if fuelLevel <= 0 {
            triggerGameOver()
        }
        
        // HUD aktualisieren
        updateHUD()
        
        // Stalleffekt: Wenn die Geschwindigkeit zu niedrig ist, sinkt das Flugzeug stärker
        if currentSpeed < 250 {
            planeSprite.position.y -= 2 * CGFloat(dt * 60)
        }
    }
    
    func triggerGameOver() {
        gameOver = true
        // Hier kann das Tracking von Echtzeit-Daten gestoppt werden
        gameOverOverlay.run(SKAction.fadeIn(withDuration: 1.0))
        gameOverLabel.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.scale(to: 1.2, duration: 0.3),
            SKAction.scale(to: 1.0, duration: 0.3)
        ]))
        restartButton.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.scale(to: 1.2, duration: 0.3),
            SKAction.scale(to: 1.0, duration: 0.3)
        ]))
        
        // Score reporten (Platzhalter)
        LeaderboardManager.shared.reportScore(Int(flightTime * 100))
    }
    
    func restartGame() {
        gameOver = false
        flightTime = 0
        fuelLevel = 100.0
        currentSpeed = 300.0
        planeSprite.position = CGPoint(x: size.width * 0.2, y: size.height / 2)
        gameOverOverlay.run(SKAction.fadeOut(withDuration: 0.5))
        // Setze weitere Variablen ggf. zurück, z. B. Schadensstatus
    }
}
