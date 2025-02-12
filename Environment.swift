//
//  Environment.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT – Erweiterte Version
//
//  Diese Klasse verwaltet den gesamten Hintergrund und die dynamische Umgebung.
//  Sie besteht aus mehreren statischen Layern (Himmel, Berge, Wald, Vordergrund),
//  dynamischen Elementen (Wolken, Vögel, fallende Blätter),
//  Wettereffekten (Regen, Schnee) sowie einem Tag-Nacht-Zyklus, der die Beleuchtung und
//  Farbgebung der Szene anpasst. Alle Parameter und Funktionen sind ausführlich kommentiert.
//

import SpriteKit

class Environment {
    
    // MARK: - Statische Hintergrundlayer
    var skyLayer: SKSpriteNode!
    var mountainLayer: SKSpriteNode!
    var forestLayer: SKSpriteNode!
    var foregroundLayer: SKSpriteNode!
    
    // MARK: - Dynamische Elemente
    var cloudNodes: [SKSpriteNode] = []
    var birdNodes: [SKSpriteNode] = []
    var leafNodes: [SKSpriteNode] = []  // Zusätzliche fallende Blätter
    
    // MARK: - Wettereffekte
    var rainEmitter: SKEmitterNode?
    var snowEmitter: SKEmitterNode?
    
    // MARK: - Tag-/Nachtzyklus
    /// dayTime: 1.0 = voller Tag, 0.0 = volle Nacht
    var dayTime: CGFloat = 1.0
    var timeElapsed: TimeInterval = 0
    
    // MARK: - Referenz zur Szene
    let scene: SKScene
    
    // MARK: - Initialisierung
    init(scene: SKScene) {
        self.scene = scene
        
        // Aufbau der statischen Layer
        setupSky()
        setupMountains()
        setupForest()
        setupForeground()
        
        // Aufbau der dynamischen Elemente
        setupClouds()
        setupBirds()
        setupFallingLeaves()
        
        // Wettereffekte werden initial nicht aktiviert
        rainEmitter = nil
        snowEmitter = nil
    }
    
    // MARK: - Setup statischer Layer
    func setupSky() {
        // Lade das Himmelbild aus dem Asset-Katalog
        skyLayer = SKSpriteNode(imageNamed: "background_sky")
        skyLayer.anchorPoint = CGPoint.zero
        skyLayer.position = CGPoint.zero
        skyLayer.zPosition = -20
        skyLayer.size = scene.size
        scene.addChild(skyLayer)
    }
    
    func setupMountains() {
        // Lade das Bild der Berge
        mountainLayer = SKSpriteNode(imageNamed: "background_mountains")
        mountainLayer.anchorPoint = CGPoint.zero
        // Positionierung etwas höher, um einen Tiefe-Effekt zu erzeugen
        mountainLayer.position = CGPoint(x: 0, y: scene.size.height * 0.15)
        mountainLayer.zPosition = -15
        // Vergrößere das Bild, damit es über den gesamten Bildschirm reicht
        mountainLayer.size = CGSize(width: scene.size.width * 1.5, height: scene.size.height * 0.5)
        scene.addChild(mountainLayer)
    }
    
    func setupForest() {
        // Lade das Bild für den Wald
        forestLayer = SKSpriteNode(imageNamed: "background_forest")
        forestLayer.anchorPoint = CGPoint.zero
        forestLayer.position = CGPoint(x: 0, y: scene.size.height * 0.05)
        forestLayer.zPosition = -10
        forestLayer.size = CGSize(width: scene.size.width * 1.5, height: scene.size.height * 0.4)
        scene.addChild(forestLayer)
    }
    
    func setupForeground() {
        // Lade das Vordergrundbild, z. B. Gras oder nahe Vegetation
        foregroundLayer = SKSpriteNode(imageNamed: "foreground")
        foregroundLayer.anchorPoint = CGPoint.zero
        foregroundLayer.position = CGPoint(x: 0, y: 0)
        foregroundLayer.zPosition = -5
        foregroundLayer.size = CGSize(width: scene.size.width * 1.5, height: scene.size.height * 0.3)
        scene.addChild(foregroundLayer)
    }
    
    // MARK: - Setup dynamischer Elemente
    func setupClouds() {
        // Erstelle 8 Wolken, die über den Himmel ziehen
        for _ in 0..<8 {
            let cloud = SKSpriteNode(imageNamed: "cloud")
            // Zufällige Transparenz zwischen 0.6 und 0.9
            cloud.alpha = CGFloat.random(in: 0.6...0.9)
            // Zufällige Position: x innerhalb der Szene, y in der oberen Hälfte
            let randomX = CGFloat(arc4random_uniform(UInt32(scene.size.width)))
            let randomY = CGFloat(arc4random_uniform(UInt32(scene.size.height / 2))) + scene.size.height * 0.5
            cloud.position = CGPoint(x: randomX, y: randomY)
            cloud.zPosition = -18
            cloud.setScale(CGFloat.random(in: 0.5...1.5))
            scene.addChild(cloud)
            cloudNodes.append(cloud)
            
            // Erstelle eine Endlosschleife, um die Wolke von rechts nach links über den Bildschirm zu bewegen
            let duration = TimeInterval(CGFloat.random(in: 40...80))
            let moveLeft = SKAction.moveBy(x: -scene.size.width - cloud.size.width, y: 0, duration: duration)
            let reset = SKAction.moveBy(x: scene.size.width + cloud.size.width, y: 0, duration: 0)
            let sequence = SKAction.sequence([moveLeft, reset])
            let repeatForever = SKAction.repeatForever(sequence)
            cloud.run(repeatForever)
        }
    }
    
    func setupBirds() {
        // Erstelle 4 Vögel, die sich leicht auf und ab bewegen
        for _ in 0..<4 {
            let bird = SKSpriteNode(imageNamed: "bird")
            bird.alpha = 0.9
            let randomX = CGFloat(arc4random_uniform(UInt32(scene.size.width)))
            let randomY = CGFloat(arc4random_uniform(UInt32(scene.size.height / 3))) + scene.size.height * 0.6
            bird.position = CGPoint(x: randomX, y: randomY)
            bird.zPosition = -17
            bird.setScale(CGFloat.random(in: 0.8...1.2))
            scene.addChild(bird)
            birdNodes.append(bird)
            
            // Animation: Leichtes Auf- und Abbewegen
            let moveUp = SKAction.moveBy(x: 0, y: 20, duration: 2.0)
            let moveDown = SKAction.moveBy(x: 0, y: -20, duration: 2.0)
            let sequence = SKAction.sequence([moveUp, moveDown])
            let repeatForever = SKAction.repeatForever(sequence)
            bird.run(repeatForever)
        }
    }
    
    func setupFallingLeaves() {
        // Erstelle 10 fallende Blätter
        for _ in 0..<10 {
            let leaf = SKSpriteNode(imageNamed: "leaf")
            leaf.alpha = CGFloat.random(in: 0.7...1.0)
            let randomX = CGFloat(arc4random_uniform(UInt32(scene.size.width)))
            let randomY = scene.size.height + CGFloat(arc4random_uniform(100))
            leaf.position = CGPoint(x: randomX, y: randomY)
            leaf.zPosition = -8
            leaf.setScale(CGFloat.random(in: 0.5...1.0))
            scene.addChild(leaf)
            leafNodes.append(leaf)
            
            // Animation: Blätter fallen langsam nach unten, drehen sich und werden dann zurückgesetzt
            let fallDuration = TimeInterval(CGFloat.random(in: 10...20))
            let fallAction = SKAction.moveBy(x: 0, y: -scene.size.height - leaf.size.height, duration: fallDuration)
            let rotateAction = SKAction.rotate(byAngle: CGFloat.pi, duration: fallDuration)
            let group = SKAction.group([fallAction, rotateAction])
            let resetPosition = SKAction.run {
                leaf.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.scene.size.width))), y: self.scene.size.height + leaf.size.height)
                leaf.zRotation = 0
            }
            let sequence = SKAction.sequence([group, resetPosition])
            leaf.run(SKAction.repeatForever(sequence))
        }
    }
    
    // MARK: - Wettereffekte
    func setupRain() {
        // Lade den Regen-Partikelemitter. Stelle sicher, dass "Rain.sks" existiert.
        if let rain = SKEmitterNode(fileNamed: "Rain.sks") {
            rain.position = CGPoint(x: scene.size.width / 2, y: scene.size.height)
            rain.zPosition = -12
            rain.targetNode = scene
            scene.addChild(rain)
            rainEmitter = rain
        }
    }
    
    func setupSnow() {
        // Lade den Schnee-Partikelemitter. Stelle sicher, dass "Snow.sks" existiert.
        if let snow = SKEmitterNode(fileNamed: "Snow.sks") {
            snow.position = CGPoint(x: scene.size.width / 2, y: scene.size.height)
            snow.zPosition = -12
            snow.targetNode = scene
            scene.addChild(snow)
            snowEmitter = snow
        }
    }
    
    func removeRain() {
        rainEmitter?.removeFromParent()
        rainEmitter = nil
    }
    
    func removeSnow() {
        snowEmitter?.removeFromParent()
        snowEmitter = nil
    }
    
    // MARK: - Tag-Nacht-Zyklus
    func updateDayCycle(deltaTime: TimeInterval) {
        timeElapsed += deltaTime
        let cycleDuration: TimeInterval = 60.0  // Ein vollständiger Tag-Nacht-Zyklus in Sekunden
        let phase = timeElapsed.truncatingRemainder(dividingBy: cycleDuration)
        
        // Berechne dayTime: 1.0 = Tag, 0.0 = Nacht
        if phase < 15.0 {
            dayTime = CGFloat(phase / 15.0)
        } else if phase < 30.0 {
            dayTime = 1.0
        } else if phase < 45.0 {
            dayTime = CGFloat(1.0 - ((phase - 30.0) / 15.0))
        } else {
            dayTime = 0.0
        }
        
        // Passe die Helligkeit des Himmels und anderer Layer an:
        let nightColor = SKColor(white: 0.0, alpha: 1.0 - dayTime)
        skyLayer.color = nightColor
        skyLayer.colorBlendFactor = 0.5
        
        mountainLayer.color = SKColor(white: 0.8, alpha: 1.0 - dayTime * 0.5)
        mountainLayer.colorBlendFactor = 0.3
        
        forestLayer.color = SKColor(white: 0.9, alpha: 1.0 - dayTime * 0.4)
        forestLayer.colorBlendFactor = 0.3
    }
    
    // MARK: - Update-Funktion
    /// Diese Funktion wird jeden Frame aufgerufen, um die Umgebung dynamisch zu aktualisieren.
    /// Sie berücksichtigt den Tag-Nacht-Zyklus, Parallax-Scrolling und dynamische Wettereffekte.
    func update(deltaTime: TimeInterval, playerSpeed: CGFloat) {
        updateDayCycle(deltaTime: deltaTime)
        
        // Parallax-Scrolling: Verschiebe die statischen Layer basierend auf ihrer Tiefe.
        let parallaxFactors: [SKSpriteNode: CGFloat] = [
            skyLayer: 0.05,
            mountainLayer: 0.1,
            forestLayer: 0.2,
            foregroundLayer: 0.4
        ]
        for (layer, factor) in parallaxFactors {
            layer.position.x -= playerSpeed * CGFloat(deltaTime) * factor
            if layer.position.x <= -scene.size.width / 2 {
                layer.position.x += scene.size.width / 2
            }
        }
        
        // Aktualisiere die Transparenz der Wolken (kann an den Tag-Nacht-Zyklus gekoppelt werden)
        for cloud in cloudNodes {
            cloud.alpha = CGFloat.random(in: 0.6...0.9) * dayTime + 0.1
        }
        
        // Bewege die Vögel leicht, um Dynamik zu erzeugen
        for bird in birdNodes {
            let randomOffset = CGFloat(arc4random_uniform(3)) - 1.5
            bird.position.x -= randomOffset * CGFloat(deltaTime)
        }
        
        // Wettereffekte: Wenn es dunkel (Nacht) ist, werden zufällig Regen oder Schnee aktiviert.
        if dayTime < 0.3 && rainEmitter == nil && snowEmitter == nil {
            let weatherChance = Int(arc4random_uniform(100))
            if weatherChance < 30 {
                setupRain()
            } else if weatherChance < 60 {
                setupSnow()
            }
        } else if dayTime > 0.5 {
            if rainEmitter != nil { removeRain() }
            if snowEmitter != nil { removeSnow() }
        }
    }
}
