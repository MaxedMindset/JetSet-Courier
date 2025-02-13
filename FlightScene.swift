//
//  FlightScene.swift
//  SkyCraftBuildAndFly
//
//  Erweiterte FlightScene mit realistischen aerodynamischen Effekten, HUD und animierten UI-Übergängen
//

import SpriteKit
import CoreGraphics

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
        
        // Hintergrund (ein einfacher Himmel)
        let sky = SKSpriteNode(color: SKColor.cyan, size: CGSize(width: size.width, height: size.height))
        sky.position = CGPoint(x: size.width / 2, y: size.height / 2)
        sky.zPosition = -2
        addChild(sky)
        
        // Flugzeug-Sprite
        planeSprite = SKSpriteNode(imageNamed: "aircraft_base")
        planeSprite.position = CGPoint(x: size.width * 0.2, y: size.height * 0.5)
        planeSprite.setScale(0.8)
        planeSprite.physicsBody = SKPhysicsBody(texture: planeSprite.texture!, size: planeSprite.size)
        planeSprite.physicsBody?.allowsRotation = false
        addChild(planeSprite)
        
        // HUD-Setup
        setupHUD()
        
        // "Tap to Start" Overlay
        tapToStartLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        tapToStartLabel.text = "Tap to Start"
        tapToStartLabel.fontSize = 36
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        tapToStartLabel.alpha = 0.0
        tapToStartLabel.zPosition = 10
        addChild(tapToStartLabel)
        
        // Fade in "Tap to Start"
        tapToStartLabel.run(SKAction.fadeIn(withDuration: 1.0))
        
        // Game Over Overlay (initial versteckt)
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
        flightTimeLabel.position = CGPoint(x: size.width / 2, y: size.height - 40)
        flightTimeLabel.zPosition = 5
        addChild(flightTimeLabel)
    }
    
    func setupGameOverOverlay() {
        // Halbtransparentes Overlay
        gameOverOverlay = SKSpriteNode(color: SKColor.black.withAlphaComponent(0.7), size: self.size)
        gameOverOverlay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        gameOverOverlay.zPosition = 20
        gameOverOverlay.alpha = 0.0
        addChild(gameOverOverlay)
        
        // Game Over Label
        gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: 0, y: 20)
        gameOverLabel.alpha = 0.0
        gameOverOverlay.addChild(gameOverLabel)
        
        // Restart Button
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
        damageLabel.text = "Damage: \(Int(0))%"  // Hier könntest du z. B. Schadensberechnung integrieren.
        flightTimeLabel.text = String(format: "Time: %.1f s", flightTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Wenn das Spiel noch nicht gestartet wurde, wird das "Tap to Start" Overlay entfernt.
        if tapToStartLabel.parent != nil {
            tapToStartLabel.run(SKAction.fadeOut(withDuration: 0.5)) {
                self.tapToStartLabel.removeFromParent()
            }
            return
        }
        
        // Falls Game Over und Restart-Button sichtbar, überprüfe ob Restart gedrückt wurde
        guard !gameOver, let touch = touches.first else {
            if gameOver, let touch = touches.first {
                let location = touch.location(in: gameOverOverlay)
                if gameOverOverlay.nodes(at: location).contains(where: { $0.name == "restartButton" }) {
                    restartGame()
                }
            }
            return
        }
        
        // Standard-Impulse: Beim Tippen wird ein Aufwärtsimpuls ausgegeben
        let impulse = CGVector(dx: 0, dy: 50)
        planeSprite.physicsBody?.applyImpulse(impulse)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Optionale Steuerung per Wisch: Hier könnte man zusätzliche Effekte integrieren
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Berechne dt (Delta Time)
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        if gameOver { return }
        
        // Aktualisiere Flugzeit
        flightTime += dt
        
        // Erhöhe den Score oder verändere Flugparameter (hier simuliert als Änderung der Geschwindigkeit)
        // In einer echten Simulation würden physikalische Kräfte (Luftwiderstand, Auftrieb) hier wirken:
        let airResistance = currentSpeed * 0.02
        currentSpeed = max(0, currentSpeed - airResistance * CGFloat(dt))
        
        // Simuliere Auftrieb: Ist die Geschwindigkeit hoch, steigt das Flugzeug
        if currentSpeed > 300 {
            planeSprite.position.y += 1 * CGFloat(dt * 60)
        } else {
            planeSprite.position.y -= 1 * CGFloat(dt * 60)
        }
        
        // Simuliere zufällige Umwelteinflüsse: Wind und Turbulenzen
        let windForce = CGFloat.random(in: -5...5)
        let turbulenceForce = CGFloat.random(in: -3...3)
        planeSprite.physicsBody?.applyForce(CGVector(dx: windForce + turbulenceForce, dy: 0))
        
        // Simuliere Treibstoffverbrauch
        fuelLevel = max(0, fuelLevel - 0.05 * CGFloat(dt * 60))
        
        // Trigger Game Over, wenn der Treibstoff aufgebraucht ist
        if fuelLevel <= 0 {
            triggerGameOver()
        }
        
        // Aktualisiere das HUD
        updateHUD()
        
        // Stalleffekt: Wenn die Geschwindigkeit zu niedrig ist, sinkt das Flugzeug stärker
        if currentSpeed < 250 {
            planeSprite.position.y -= 2 * CGFloat(dt * 60)
        }
    }
    
    func triggerGameOver() {
        gameOver = true
        // Stoppe Flugdaten-Tracking (z. B. via FlightStatsManager)
        // Füge zusätzliche Effekte (z. B. Explosionen) hier ein
        // Blende das Game Over-Overlay ein:
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
        
        // Score an Leaderboard reporten (hier als Platzhalter)
        LeaderboardManager.shared.reportScore(Int(flightTime * 100))
    }
    
    func restartGame() {
        // Setze alle Parameter zurück
        gameOver = false
        flightTime = 0
        fuelLevel = 100.0
        currentSpeed = 300.0
        planeSprite.position = CGPoint(x: size.width * 0.2, y: size.height / 2)
        gameOverOverlay.run(SKAction.fadeOut(withDuration: 0.5))
        statsResetAndStartTracking()
    }
    
    func statsResetAndStartTracking() {
        // In einer echten Implementierung: Reset der FlightStatsManager-Daten
        // Hier setzen wir einfach die Variablen zurück
    }
}
