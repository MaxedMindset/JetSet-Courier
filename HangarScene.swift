//
//  HangarScene.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  In dieser Szene kann der Spieler sein Flugzeug aus verschiedenen Komponenten zusammenbauen.
//  Die Auswahl beeinflusst Parameter wie Gewicht, Lift und Schubkraft.
//  Anschließend kann er in den Flugmodus wechseln.
//

import SpriteKit

class HangarScene: SKScene {
    // Standardoptionen (anpassbar über Buttons)
    var weightOption: CGFloat = 100.0
    var liftOption: CGFloat = 100.0
    var thrustOption: CGFloat = 100.0
    // Direkt nach den anderen UI-Elementen in HangarScene:
    var readinessLabel: SKLabelNode!

    
    override func didMove(to view: SKView) {
        self.backgroundColor = .darkGray
        
        let titleLabel = SKLabelNode(text: "Build Your Airplane")
        titleLabel.fontSize = 40
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width/2, y: size.height*0.8)
        addChild(titleLabel)
        
        let instructionLabel = SKLabelNode(text: "Select components to optimize flight performance!")
        instructionLabel.fontSize = 20
        instructionLabel.fontColor = .white
        instructionLabel.position = CGPoint(x: size.width/2, y: size.height*0.75)
        addChild(instructionLabel)
        
        // Rumpf-Auswahl: Leicht vs. Schwer
        let lightRumpf = SKLabelNode(text: "Light Rumpf")
        lightRumpf.name = "lightRumpf"
        lightRumpf.fontSize = 30
        lightRumpf.fontColor = .green
        lightRumpf.position = CGPoint(x: size.width*0.3, y: size.height*0.6)
        addChild(lightRumpf)
        
        let heavyRumpf = SKLabelNode(text: "Heavy Rumpf")
        heavyRumpf.name = "heavyRumpf"
        heavyRumpf.fontSize = 30
        heavyRumpf.fontColor = .red
        heavyRumpf.position = CGPoint(x: size.width*0.7, y: size.height*0.6)
        addChild(heavyRumpf)
        
        // Flügel-Auswahl: Große vs. Kleine Flügel
        let bigWings = SKLabelNode(text: "Big Wings")
        bigWings.name = "bigWings"
        bigWings.fontSize = 30
        bigWings.fontColor = .green
        bigWings.position = CGPoint(x: size.width*0.3, y: size.height*0.5)
        addChild(bigWings)
        
        let smallWings = SKLabelNode(text: "Small Wings")
        smallWings.name = "smallWings"
        smallWings.fontSize = 30
        smallWings.fontColor = .red
        smallWings.position = CGPoint(x: size.width*0.7, y: size.height*0.5)
        addChild(smallWings)
        
        // Triebwerks-Auswahl: Starke vs. Schwache Motoren
        let strongEngine = SKLabelNode(text: "Strong Engine")
        strongEngine.name = "strongEngine"
        strongEngine.fontSize = 30
        strongEngine.fontColor = .green
        strongEngine.position = CGPoint(x: size.width*0.3, y: size.height*0.4)
        addChild(strongEngine)
        
        let weakEngine = SKLabelNode(text: "Weak Engine")
        weakEngine.name = "weakEngine"
        weakEngine.fontSize = 30
        weakEngine.fontColor = .red
        weakEngine.position = CGPoint(x: size.width*0.7, y: size.height*0.4)
        addChild(weakEngine)
        
        // Start Flight Button
        let startFlightButton = SKLabelNode(text: "Start Flight")
        startFlightButton.name = "startFlight"
        startFlightButton.fontSize = 36
        startFlightButton.fontColor = .yellow
        startFlightButton.position = CGPoint(x: size.width/2, y: size.height*0.2)
        addChild(startFlightButton)
        
        // Flugbereitschaftsstatus anzeigen
        let readinessLabel = SKLabelNode(text: "Flugbereitschaft: Unbekannt")
        readinessLabel.fontSize = 28
        readinessLabel.fontColor = .white
        readinessLabel.position = CGPoint(x: size.width/2, y: size.height*0.3)
        readinessLabel.zPosition = 15
        addChild(readinessLabel)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            if let name = node.name {
                switch name {
                case "lightRumpf":
                    weightOption = 80.0
                    node.run(SKAction.scale(to: 1.2, duration: 0.2))
                case "heavyRumpf":
                    weightOption = 150.0
                    node.run(SKAction.scale(to: 1.2, duration: 0.2))
                case "bigWings":
                    liftOption = 150.0
                    node.run(SKAction.scale(to: 1.2, duration: 0.2))
                case "smallWings":
                    liftOption = 80.0
                    node.run(SKAction.scale(to: 1.2, duration: 0.2))
                case "strongEngine":
                    thrustOption = 150.0
                    node.run(SKAction.scale(to: 1.2, duration: 0.2))
                case "weakEngine":
                    thrustOption = 80.0
                    node.run(SKAction.scale(to: 1.2, duration: 0.2))
                case "startFlight":
                    // Speichere die Konfiguration.
                    let config = AircraftConfiguration(weight: weightOption, lift: liftOption, thrust: thrustOption, stability: 1.0)
                    AircraftConfigurationManager.shared.configuration = config
                    // Wechsel in den Flugmodus.
                    let flightScene = FlightScene(size: size)
                    flightScene.scaleMode = .aspectFill
                    self.view?.presentScene(flightScene, transition: SKTransition.fade(withDuration: 1.0))
                    if node.name == "startFlight" {
                    // Konfiguration speichern
                    let config = AircraftConfiguration(weight: weightOption, lift: liftOption, thrust: thrustOption, stability: 1.0)
                    AircraftConfigurationManager.shared.configuration = config

                   // Aktualisiere das Readiness-Label
                   let rating = AircraftSimulator.readinessRating(for: config)
                   readinessLabel.text = "Flugbereitschaft: \(rating)"
    
                   // Option: Wenn das Flugzeug nicht flugbereit ist, zeige eine Warnung und verhindere den Wechsel.
                   if AircraftSimulator.calculateFlightReadiness(for: config) < 50 {
                   let warning = SKLabelNode(text: "Dein Flugzeug ist nicht flugbereit!")
                   warning.fontSize = 28
                   warning.fontColor = .red
                   warning.position = CGPoint(x: size.width/2, y: size.height*0.15)
                   warning.zPosition = 100
                   addChild(warning)
                   let wait = SKAction.wait(forDuration: 2.0)
                   warning.run(SKAction.sequence([wait, SKAction.fadeOut(withDuration: 1.0), SKAction.removeFromParent()]))
                   } else {
                   // Wechsel in den Flugmodus, wenn das Flugzeug flugbereit ist.
                   let flightScene = FlightScene(size: size)
                   flightScene.scaleMode = .aspectFill
                   self.view?.presentScene(flightScene, transition: SKTransition.fade(withDuration: 1.0))
                   }
                    }
                    default:
                    break
                }
            }
        }
    }
}
