//
//  FlightScene.swift
//  SkyCraftBuildAndFly
//
//  Diese erweiterte FlightScene simuliert realistischere aerodynamische Effekte wie Auftrieb, Luftwiderstand,
//  Trägheit und Stalleffekte. Zudem werden Umwelteinflüsse (Wind, Turbulenzen) einbezogen.
//  Ein HUD zeigt Echtzeit-Daten wie Geschwindigkeit, Flughöhe, Treibstoff, Schadensstatus und Flugzeit an.
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
    
    // Simulierte physikalische Parameter
    var currentSpeed: CGFloat = 300
    var currentAltitude: CGFloat = 1500
    var fuelLevel: CGFloat = 100.0
    var damage: CGFloat = 0.0
    var flightTime: TimeInterval = 0.0
    
    // Wind- und Turbulenzeffekte
    var windForce: CGFloat = 0
    var turbulenceForce: CGFloat = 0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.cyan
        
        // Hintergrund (einfacher Himmel)
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
        
        setupHUD()
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
                self.view?.presentScene(mainMenu, transition: SKTransition.fade(withDuration: 1.0))
                return
            }
        }
    }
    
    // Steuerung über touchesMoved: Wischgesten zum Steigen/Sinken
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let previous = touch.previousLocation(in: self)
        let current = touch.location(in: self)
        let deltaY = current.y - previous.y
        planeSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: deltaY * 0.1))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Erhöhe Flugzeit
        flightTime += 1.0 / 60.0
        
        // Simuliere einfache Physik: Luftwiderstand und Auftrieb
        // Hier ein rudimentäres Beispiel:
        let airResistance = currentSpeed * 0.02
        currentSpeed = max(0, currentSpeed - airResistance)
        
        // Simuliere Auftrieb: Wenn Geschwindigkeit hoch genug, steigt das Flugzeug, sonst sinkt es.
        if currentSpeed > 300 {
            planeSprite.position.y += 1
        } else {
            planeSprite.position.y -= 1
        }
        
        // Simuliere Wind- und Turbulenzeffekte
        windForce = CGFloat.random(in: -5...5)
        turbulenceForce = CGFloat.random(in: -3...3)
        planeSprite.physicsBody?.applyForce(CGVector(dx: windForce + turbulenceForce, dy: 0))
        
        // Aktualisiere HUD-Labels
        speedLabel.text = "Speed: \(Int(currentSpeed)) km/h"
        altitudeLabel.text = "Altitude: \(Int(planeSprite.position.y)) m"
        fuelLabel.text = "Fuel: \(Int(fuelLevel))%"
        damageLabel.text = "Damage: \(Int(damage))%"
        flightTimeLabel.text = String(format: "Time: %.1f s", flightTime)
        
        // Simuliere Treibstoffverbrauch
        fuelLevel = max(0, fuelLevel - 0.05)
        
        // Simuliere Stalleffekt: Wenn die Geschwindigkeit zu niedrig ist, sinkt das Flugzeug schneller
        if currentSpeed < 250 {
            planeSprite.position.y -= 2
        }
    }
}
