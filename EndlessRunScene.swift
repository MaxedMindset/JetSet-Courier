//
//  EndlessRunScene.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  In diesem Modus fliegt der Spieler endlos, sammelt Punkte basierend auf der Flugzeit (oder Distanz)
//  und versucht, so lange wie möglich durchzuhalten. Bei Spielende wird der Score an das Leaderboard gemeldet.
//

import SpriteKit
import CoreGraphics

class EndlessRunScene: SKScene {
    
    var planeSprite: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var restartButton: SKLabelNode!
    
    // Simulationseigenschaften
    var score: Int = 0
    var fuelLevel: CGFloat = 100.0
    var gameOver: Bool = false
    
    // Timer für Endlos-Score und Physik
    var lastUpdateTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.cyan
        
        // Hintergrund (ein einfacher Himmel – ggf. durch ein Bild ersetzen)
        let sky = SKSpriteNode(color: SKColor.cyan, size: CGSize(width: size.width, height: size.height))
        sky.position = CGPoint(x: size.width / 2, y: size.height / 2)
        sky.zPosition = -2
        addChild(sky)
        
        // Flugzeug-Sprite
        planeSprite = SKSpriteNode(imageNamed: "aircraft_base")
        planeSprite.position = CGPoint(x: size.width * 0.2, y: size.height / 2)
        planeSprite.setScale(0.8)
        planeSprite.physicsBody = SKPhysicsBody(texture: planeSprite.texture!, size: planeSprite.size)
        planeSprite.physicsBody?.allowsRotation = false
        addChild(planeSprite)
        
        // Score-Label
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.fontSize = 28
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 50)
        addChild(scoreLabel)
        updateScoreLabel()
        
        // Game-Over Label (initial versteckt)
        gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOverLabel.text = "Game Over"
        gameOverLabel.isHidden = true
        addChild(gameOverLabel)
        
        // Restart-Button (initial versteckt)
        restartButton = SKLabelNode(fontNamed: "AvenirNext-Bold")
        restartButton.fontSize = 30
        restartButton.fontColor = SKColor.green
        restartButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 60)
        restartButton.text = "Restart"
        restartButton.name = "restartButton"
        restartButton.isHidden = true
        addChild(restartButton)
        
        // Start tracking game time
        lastUpdateTime = 0
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)  Fuel: \(Int(fuelLevel))%"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameOver, let touch = touches.first else {
            // Falls Game Over und Restart-Button berührt wird
            if gameOver, let touch = touches.first {
                let location = touch.location(in: self)
                if nodes(at: location).contains(where: { $0.name == "restartButton" }) {
                    restartGame()
                }
            }
            return
        }
        
        // Steuerung: Wenn der Spieler den Bildschirm berührt, wird ein Aufwärtsimpuls ausgelöst.
        let impulse = CGVector(dx: 0, dy: 50)
        planeSprite.physicsBody?.applyImpulse(impulse)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Optional: Hier kann zusätzliche Steuerung implementiert werden
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Berechne Delta Time
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        if gameOver { return }
        
        // Erhöhe den Score basierend auf der Zeit
        score += Int(dt * 100)
        
        // Simuliere Treibstoffverbrauch
        fuelLevel = max(0, fuelLevel - CGFloat(dt * 2))
        
        // Wenn der Treibstoff leer ist, beende das Spiel
        if fuelLevel <= 0 {
            triggerGameOver()
        }
        
        // Simuliere Umwelteinflüsse: Wind und Turbulenzen
        let windForce = CGFloat.random(in: -5...5)
        let turbulenceForce = CGFloat.random(in: -3...3)
        planeSprite.physicsBody?.applyForce(CGVector(dx: windForce + turbulenceForce, dy: 0))
        
        // Aktualisiere HUD
        updateScoreLabel()
        
        // Zusätzliche Flugphysik: Simuliere einen Stalleffekt, wenn die Geschwindigkeit zu niedrig ist.
        if let body = planeSprite.physicsBody, body.velocity.dx < 100 {
            planeSprite.position.y -= 2
        }
    }
    
    func triggerGameOver() {
        gameOver = true
        statsStopTrackingAndReportScore()
        gameOverLabel.isHidden = false
        restartButton.isHidden = false
    }
    
    func statsStopTrackingAndReportScore() {
        FlightStatsManager.shared.stopTracking()
        // Simuliere das Reporten des Scores an ein Leaderboard
        LeaderboardManager.shared.reportScore(score)
    }
    
    func restartGame() {
        // Reset Werte
        score = 0
        fuelLevel = 100.0
        gameOver = false
        updateScoreLabel()
        gameOverLabel.isHidden = true
        restartButton.isHidden = true
        FlightStatsManager.shared.resetStats()
        FlightStatsManager.shared.startTracking()
        // Setze die Position des Flugzeugs zurück
        planeSprite.position = CGPoint(x: size.width * 0.2, y: size.height / 2)
    }
}
