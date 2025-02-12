//  Diese Szene präsentiert die Storyline des Karrieremodus. Der Spieler sieht eine Reihe von
//  Dialogen, die den Verlauf der Geschichte erzählen. An bestimmten Stellen muss der Spieler Entscheidungen treffen,
//  die den weiteren Verlauf beeinflussen. Der Fortschritt wird über den CareerManager gespeichert.
//

import SpriteKit
import UIKit
import Foundation
import CoreGraphics

class StoryScene: SKScene {
    
    // UI-Elemente: Dialog-Label und Entscheidungsknöpfe
    var dialogueLabel: SKLabelNode!
    var decisionButton1: SKLabelNode!
    var decisionButton2: SKLabelNode!
    
    // Array mit Dialogtexten
    var dialogues: [String] = []
    var currentDialogueIndex: Int = 0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        
        // Beispielhafte Dialoge für die Story
        dialogues = [
            "Willkommen in der Zukunft. Du bist ein aufstrebender Flugzeugdesigner und Kurier.",
            "Deine erste Mission: Liefere das geheime Paket an einen verborgenen Ort.",
            "Möchtest du den schnellen, aber riskanten Weg wählen?",
            "Oder den sicheren, aber langsamen Weg?"
        ]
        
        // Dialog-Label einrichten
        dialogueLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        dialogueLabel.fontSize = 28
        dialogueLabel.fontColor = SKColor.white
        dialogueLabel.numberOfLines = 0
        dialogueLabel.preferredMaxLayoutWidth = size.width - 40
        dialogueLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.6)
        dialogueLabel.text = dialogues[currentDialogueIndex]
        addChild(dialogueLabel)
        
        // Entscheidungsknöpfe einrichten (initial ausgeblendet)
        decisionButton1 = SKLabelNode(fontNamed: "AvenirNext-Bold")
        decisionButton1.fontSize = 24
        decisionButton1.fontColor = SKColor.green
        decisionButton1.position = CGPoint(x: size.width / 2 - 100, y: size.height * 0.4)
        decisionButton1.name = "decision1"
        decisionButton1.text = "Ja, riskiere es!"
        decisionButton1.isHidden = true
        addChild(decisionButton1)
        
        decisionButton2 = SKLabelNode(fontNamed: "AvenirNext-Bold")
        decisionButton2.fontSize = 24
        decisionButton2.fontColor = SKColor.red
        decisionButton2.position = CGPoint(x: size.width / 2 + 100, y: size.height * 0.4)
        decisionButton2.name = "decision2"
        decisionButton2.text = "Nein, sicherer Weg!"
        decisionButton2.isHidden = true
        addChild(decisionButton2)
        
        updateDialogue()
    }
    
    func updateDialogue() {
        // Bei den Dialogen, bei denen Entscheidungen getroffen werden sollen, werden die Knöpfe eingeblendet.
        // In diesem Beispiel nehmen wir an, dass Dialog 2 und 3 Entscheidungsdialoge sind.
        if currentDialogueIndex == 2 || currentDialogueIndex == 3 {
            decisionButton1.isHidden = false
            decisionButton2.isHidden = false
        } else {
            decisionButton1.isHidden = true
            decisionButton2.isHidden = true
        }
        
        if currentDialogueIndex < dialogues.count {
            dialogueLabel.text = dialogues[currentDialogueIndex]
        } else {
            // Ende der Story, wechsle z. B. zum Hauptmenü oder nächsten Spielmodus
            let mainMenu = MainMenuScene(size: size)
            mainMenu.scaleMode = .aspectFill
            self.view?.presentScene(mainMenu, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        // Wenn ein Entscheidungsknopf sichtbar ist, überprüfe, ob einer der beiden gedrückt wurde.
        for node in touchedNodes {
            if let nodeName = node.name {
                if nodeName == "decision1" {
                    // Entscheidung 1: Risikoreicher Weg
                    CareerManager.shared.addStoryPoints(10)
                    dialogues.append("Du hast dich für den schnellen, riskanten Weg entschieden. Mehr Risiko, aber höhere Belohnungen!")
                    currentDialogueIndex += 1
                    updateDialogue()
                    return  // Entscheidung verarbeitet, nicht weiter inkrementieren.
                } else if nodeName == "decision2" {
                    // Entscheidung 2: Sicherer Weg
                    CareerManager.shared.addStoryPoints(5)
                    dialogues.append("Du hast dich für den sicheren Weg entschieden. Es dauert länger, aber es ist weniger riskant.")
                    currentDialogueIndex += 1
                    updateDialogue()
                    return
                }
            }
        }
        
        // Falls keine Entscheidung getroffen wurde, gehe zur nächsten Dialogzeile
        currentDialogueIndex += 1
        updateDialogue()
    }
}
