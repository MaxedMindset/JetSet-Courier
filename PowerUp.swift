//
//  PowerUp.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Diese Klasse definiert ein PowerUp, das der Spieler einsammeln kann, um beispielsweise
//  den Eco-Score zu erhöhen oder temporäre Boosts zu erhalten.
//

import SpriteKit

class PowerUp: SKSpriteNode {
    init(position: CGPoint, size: CGSize) {
        let texture = SKTexture(imageNamed: "powerup")
        super.init(texture: texture, color: .clear, size: size)
        self.position = position
        setupPhysics()
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPhysics()
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = FlightScene.PhysicsCategory.powerUp
        self.physicsBody?.contactTestBitMask = FlightScene.PhysicsCategory.aircraft
    }
    
    func startMoving(withDuration duration: TimeInterval, sceneWidth: CGFloat) {
        let moveLeft = SKAction.moveBy(x: -sceneWidth - self.size.width * 2, y: 0, duration: duration)
        let remove = SKAction.removeFromParent()
        self.run(SKAction.sequence([moveLeft, remove]))
    }
}
