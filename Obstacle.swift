//
//  Obstacle.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Diese Klasse definiert ein Hindernis, das dem Flugzeug in der Flugphase entgegenkommt.
//

import SpriteKit

class Obstacle: SKSpriteNode {
    init(position: CGPoint, size: CGSize) {
        let texture = SKTexture(imageNamed: "obstacle")
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
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        // Hier wird das Hindernis als Kollision mit dem Flugzeug erkannt.
        self.physicsBody?.categoryBitMask = FlightScene.PhysicsCategory.obstacle
        self.physicsBody?.contactTestBitMask = FlightScene.PhysicsCategory.aircraft
    }
    
    func startMoving(withDuration duration: TimeInterval, sceneWidth: CGFloat) {
        let moveLeft = SKAction.moveBy(x: -sceneWidth - self.size.width * 2, y: 0, duration: duration)
        let remove = SKAction.removeFromParent()
        self.run(SKAction.sequence([moveLeft, remove]))
    }
}
