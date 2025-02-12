//
//  Aircraft.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Diese Klasse repräsentiert das Flugzeug und simuliert physikalische Eigenschaften
//  basierend auf der im Hangar gewählten Konfiguration. Sie beinhaltet Methoden für
//  das Starten des Motors, Aufsteigen, Absteigen und das Anwenden von Stalleffekten
//  (z. B. bei zu hoher Flughöhe).
//

import SpriteKit

class Aircraft: SKSpriteNode {
    var weight: CGFloat = 100.0
    var lift: CGFloat = 100.0
    var thrust: CGFloat = 100.0
    var stability: CGFloat = 1.0
    
    // Engine-Power, die aus dem Triebwerk resultiert.
    var enginePower: CGFloat = 0.0
    
    init(configuration: AircraftConfiguration) {
        // Verwende ein Basisbild für das Flugzeug (muss in Assets vorhanden sein, z. B. "aircraft_base")
        let texture = SKTexture(imageNamed: "aircraft_base")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        // Setze Parameter basierend auf der Konfiguration
        self.weight = configuration.weight
        self.lift = configuration.lift
        self.thrust = configuration.thrust
        self.stability = configuration.stability
        
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPhysics()
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.mass = weight / 100.0
    }
    
    // Motorstart basierend auf der Triebwerksleistung.
    func startEngine() {
        enginePower = thrust
    }
    
    func ascend() {
        // Falls genügend Schub vorhanden ist, füge einen Impuls hinzu.
        if enginePower > weight * 0.8 {
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        }
    }
    
    func descend() {
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -50))
    }
    
    func update(deltaTime: TimeInterval) {
        // Wenn der Auftrieb (abhängig von Flügeln) zu gering ist, wird eine zusätzliche Abwärtskraft angewendet.
        if lift < weight * 0.9 {
            self.physicsBody?.applyForce(CGVector(dx: 0, dy: -30))
        }
    }
    
    // Wird aufgerufen, wenn das Flugzeug zu hoch steigt (dünnere Luft, geringere Triebwerksleistung).
    func applyStallEffect() {
        enginePower *= 0.95
        self.physicsBody?.applyForce(CGVector(dx: 0, dy: -100))
    }
}
