//
//  SettingsScene.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Diese Szene zeigt grundlegende Einstellungen an, die der Spieler ändern kann,
//  wie Sound und Vibration. Zudem gibt es einen Back-Button, um ins Hauptmenü zurückzukehren.
//  Änderungen werden hier nur lokal angezeigt – für eine vollständige Umsetzung müsstest du
//  die Einstellungen in einem zentralen Manager speichern und anwenden.
//

import SpriteKit

class SettingsScene: SKScene {
    
    // Statusvariablen für die Einstellungen (in einer echten App in einem SettingsManager speichern)
    var soundEnabled: Bool = true
    var vibrationEnabled: Bool = true
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.gray
        
        // Titel
        let titleLabel = SKLabelNode(text: "Settings")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 40
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        addChild(titleLabel)
        
        // Sound-Toggle
        let soundToggle = SKLabelNode(text: "Sound: ON")
        soundToggle.name = "soundToggle"
        soundToggle.fontName = "AvenirNext-Bold"
        soundToggle.fontSize = 30
        soundToggle.fontColor = SKColor.white
        soundToggle.position = CGPoint(x: size.width / 2, y: size.height * 0.6)
        addChild(soundToggle)
        
        // Vibration-Toggle
        let vibrationToggle = SKLabelNode(text: "Vibration: ON")
        vibrationToggle.name = "vibrationToggle"
        vibrationToggle.fontName = "AvenirNext-Bold"
        vibrationToggle.fontSize = 30
        vibrationToggle.fontColor = SKColor.white
        vibrationToggle.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        addChild(vibrationToggle)
        
        // Back-Button
        let backButton = SKLabelNode(text: "Back")
        backButton.name = "backButton"
        backButton.fontName = "AvenirNext-Bold"
        backButton.fontSize = 30
        backButton.fontColor = SKColor.red
        backButton.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if let nodeName = node.name {
                switch nodeName {
                case "backButton":
                    // Wechsel zurück zum Hauptmenü
                    let mainMenu = MainMenuScene(size: size)
                    mainMenu.scaleMode = .aspectFill
                    self.view?.presentScene(mainMenu, transition: SKTransition.fade(withDuration: 1.0))
                case "soundToggle":
                    // Toggle Sound-Einstellung
                    if let label = node as? SKLabelNode {
                        soundEnabled.toggle()
                        label.text = soundEnabled ? "Sound: ON" : "Sound: OFF"
                        // Hier könntest du auch deinen SoundManager anpassen, um Sounds zu aktivieren/deaktivieren
                    }
                case "vibrationToggle":
                    // Toggle Vibrationseinstellung
                    if let label = node as? SKLabelNode {
                        vibrationEnabled.toggle()
                        label.text = vibrationEnabled ? "Vibration: ON" : "Vibration: OFF"
                        // Hier könntest du ggf. auch Vibrationen aktivieren/deaktivieren
                    }
                default:
                    break
                }
            }
        }
    }
}
