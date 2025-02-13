//
//  FlightScene.swift
//  SkyCraftBuildAndFly
//
//  Erweiterte FlightScene mit realistischeren physikalischen Effekten und einem HUD, das Echtzeit-Flugstatistiken anzeigt.
//

import SpriteKit
import CoreGraphics

class FlightScene: SKScene {
    
    var planeSprite: SKSpriteNode!
    var backButton: SKLabelNode!
    
    // HUD-Labels
    var speedLabel: SKLabelNode!
    var altitudeLabel: SKLabelNode!
    var fuelLabel: SKLabelNode!
    var damageLabel: SKLabelNode!
    var flightTimeLabel: SKLabelNode!
    
    // Zugriff auf den FlightStatsManager
    let statsManager = FlightStatsManager.shared
    
    // Zeitverwaltung
    var lastUpdateTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.cyan
        
        // Einfacher Hintergrund (hier kannst du dein eigenes Design einfügen)
        let sky = SKSpriteNode(color: SKColor.cyan, size: CGSize(width: size.width, height: size.height))
        sky.position = CGPoint(x: size.width / 2, y: size.height / 2)
        sky.zPosition = -1
        addChild(sky)
        
        // Flugzeug-Sprite
        planeSprite = SKSpriteNode(imageNamed: "aircraft_base")
        planeSprite.position = CGPoint(x: size.width * 0.2, y: size.height * 0.5)
        planeSprite.setScale(0.8)
        planeSprite.physicsBody = SKPhysicsBody(texture: planeSprite.texture!, size: planeSprite.size)
        planeSprite.physicsBody?.allowsRotation = false
        addChild(planeSprite)
        
        // Back-Button
        backButton = SKLabelNode(fontNamed: "AvenirNext-Bold")
        backButton.text = "Back"
        backButton.name = "backButton"
        backButton.fontSize = 30
        backButton.fontColor = SKColor.red
        backButton.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        addChild(backButton)
        
        // Setup HUD
        setupHUD()
        
        // Starte das Tracking der Flugdaten
        statsManager.resetStats()
        statsManager.startTracking()
    }
    
    func setupHUD() {
        speedLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        speedLabel.fontSize = 24
        speedLabel.fontColor = SKColor.white
        speedLabel.position = CGPoint(x: 100, y: size.height - 40)
        addChild(speedLabel)
        
        altitudeLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        altitudeLabel.fontSize = 24
        altitudeLabel.fontColor = SKColor.white
        altitudeLabel.position = CGPoint(x: size.width - 100, y: size.height - 40)
        addChild(altitudeLabel)
        
        fuelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        fuelLabel.fontSize = 24
        fuelLabel.fontColor = SKColor.white
        fuelLabel.position = CGPoint(x: 100, y: size.height - 80)
        addChild(fuelLabel)
        
        damageLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        damageLabel.fontSize = 24
        damageLabel.fontColor = SKColor.white
        damageLabel.position = CGPoint(x: size.width - 100, y: size.height - 80)
        addChild(damageLabel)
        
        flightTimeLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        flightTimeLabel.fontSize = 24
        flightTimeLabel.fontColor = SKColor.white
        flightTimeLabel.position = CGPoint(x: size.width / 2, y: size.height - 40)
        addChild(flightTimeLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        for node in touchedNodes {
            if node.name == "backButton" {
                let mainMenu = MainMenuScene(size: size)
                mainMenu.scaleMode = .aspectFill
                statsManager.stopTracking()
                self.view?.presentScene(mainMenu, transition: SKTransition.fade(withDuration: 1.0))
                return
            }
        }
    }
    
    // Steuerung: TouchesMoved steuern den Auf- und Abstieg
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let previousLocation = touch.previousLocation(in: self)
        let currentLocation = touch.location(in: self)
        let deltaY = currentLocation.y - previousLocation.y
        planeSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: deltaY * 0.1))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Delta Time berechnen
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if dt > 1 { return }  // Schutz gegen zu hohe dt
        
        // --- Erweiterte physikalische Simulation ---
        // Luftwiderstand: Reduziert Geschwindigkeit
        let airResistance = statsManager.currentSpeed * 0.02
        statsManager.currentSpeed = max(0, statsManager.currentSpeed - airResistance * CGFloat(dt))
        
        // Auftrieb: Wenn Geschwindigkeit hoch genug, steigt das Flugzeug, sonst sinkt es
        if statsManager.currentSpeed > 300 {
            planeSprite.position.y += 1 * CGFloat(dt * 60)
        } else {
            planeSprite.position.y -= 1 * CGFloat(dt * 60)
        }
        
        // Wind- und Turbulenzeffekte: Zufällige Kräfte in horizontaler Richtung
        let windForce = CGFloat.random(in: -5...5)
        let turbulenceForce = CGFloat.random(in: -3...3)
        planeSprite.physicsBody?.applyForce(CGVector(dx: windForce + turbulenceForce, dy: 0))
        
        // Treibstoffverbrauch simulieren
        statsManager.fuelLevel = max(0, statsManager.fuelLevel - 0.05 * CGFloat(dt * 60))
        
        // Stalleffekt: Wenn Geschwindigkeit unter 250 km/h sinkt das Flugzeug stärker
        if statsManager.currentSpeed < 250 {
            planeSprite.position.y -= 2 * CGFloat(dt * 60)
        }
        
        // --- HUD Aktualisierung ---
        speedLabel.text = "Speed: \(Int(statsManager.currentSpeed)) km/h"
        altitudeLabel.text = "Altitude: \(Int(planeSprite.position.y)) m"
        fuelLabel.text = "Fuel: \(Int(statsManager.fuelLevel))%"
        damageLabel.text = "Damage: \(Int(statsManager.damage))%"
        flightTimeLabel.text = String(format: "Time: %.1f s", statsManager.flightTime)
    }
}
