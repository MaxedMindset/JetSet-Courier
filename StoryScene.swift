//  Diese Szene präsentiert den Story-Modus im Karrieremodus. Der Spieler erlebt eine
//  fesselnde Geschichte, in der er als junger Ingenieur und Kurier in einer dystopischen Zukunft aufsteigt.
//  Zwischen den Missionen werden Dialoge angezeigt, in denen der Spieler Entscheidungen treffen kann,
//  die den Verlauf der Geschichte beeinflussen und Story-Punkte generieren.
//

import SpriteKit
import Foundation
import CoreGraphics

// MARK: - Datenmodelle für Dialoge

struct DialogueChoice {
    let text: String           // Text, der auf dem Button erscheint
    let nextNodeId: String     // ID der nächsten Dialog-Node
    let storyPoints: Int       // Punkte, die bei dieser Wahl vergeben werden
}

struct DialogueNode {
    let id: String             // Eindeutige ID für diesen Dialog
    let text: String           // Haupttext des Dialogs
    let choices: [DialogueChoice]? // Falls vorhanden, die möglichen Entscheidungen
}

// MARK: - StoryScene

class StoryScene: SKScene {
    
    var dialogueLabel: SKLabelNode!
    var choiceButtons: [SKLabelNode] = []
    
    // Der Dialogbaum als Dictionary: ID -> DialogueNode
    var dialogueTree: [String: DialogueNode] = [:]
    
    // Aktuelle Dialog-Node-ID
    var currentNodeId: String = "start"
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        
        setupDialogueTree()
        setupDialogueLabel()
        displayDialogue(nodeId: currentNodeId)
    }
    
    func setupDialogueLabel() {
        dialogueLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        dialogueLabel.fontSize = 28
        dialogueLabel.fontColor = SKColor.white
        dialogueLabel.numberOfLines = 0
        dialogueLabel.preferredMaxLayoutWidth = self.size.width - 40
        dialogueLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        addChild(dialogueLabel)
    }
    
    func clearChoiceButtons() {
        for button in choiceButtons {
            button.removeFromParent()
        }
        choiceButtons.removeAll()
    }
    
    func displayDialogue(nodeId: String) {
        clearChoiceButtons()
        guard let node = dialogueTree[nodeId] else {
            // Wenn kein Knoten gefunden wird, wechsle zurück ins Hauptmenü.
            let mainMenu = MainMenuScene(size: size)
            mainMenu.scaleMode = .aspectFill
            self.view?.presentScene(mainMenu, transition: SKTransition.fade(withDuration: 1.0))
            return
        }
        currentNodeId = node.id
        dialogueLabel.text = node.text
        
        if let choices = node.choices, !choices.isEmpty {
            // Erstelle für jede Wahl einen Button
            for (index, choice) in choices.enumerated() {
                let button = SKLabelNode(fontNamed: "AvenirNext-Bold")
                button.fontSize = 24
                button.fontColor = SKColor.yellow
                button.text = choice.text
                button.name = "choice_\(index)"
                // Positioniere die Buttons
                let yPos = size.height * 0.45 - CGFloat(index * 40)
                button.position = CGPoint(x: size.width / 2, y: yPos)
                addChild(button)
                choiceButtons.append(button)
            }
        } else {
            // Wenn es keine Entscheidungen gibt, zeige einen "Continue"-Button
            let continueButton = SKLabelNode(fontNamed: "AvenirNext-Bold")
            continueButton.fontSize = 28
            continueButton.fontColor = SKColor.green
            continueButton.text = "Continue"
            continueButton.name = "continueButton"
            continueButton.position = CGPoint(x: size.width / 2, y: size.height * 0.3)
            addChild(continueButton)
            choiceButtons.append(continueButton)
        }
    }
    
    // Aufbau des Dialogbaums
    func setupDialogueTree() {
        dialogueTree["start"] = DialogueNode(
            id: "start",
            text: "Willkommen in der dystopischen Zukunft. Du bist ein junger Ingenieur mit großen Träumen, den Himmel zu erobern. Deine Reise als Flugzeugdesigner und Kurier beginnt jetzt.",
            choices: [DialogueChoice(text: "Continue", nextNodeId: "missionIntro", storyPoints: 0)]
        )
        
        dialogueTree["missionIntro"] = DialogueNode(
            id: "missionIntro",
            text: "Deine erste Mission: Ein geheimnisvolles Paket soll ins Herz der verfallenen Megacity geliefert werden. Dein Auftrag birgt große Risiken und Chancen – deine Entscheidungen werden deinen weiteren Weg bestimmen.",
            choices: [
                DialogueChoice(text: "Risiko und Schnelligkeit", nextNodeId: "riskPath", storyPoints: 0),
                DialogueChoice(text: "Sicherheit und Beständigkeit", nextNodeId: "safePath", storyPoints: 0)
            ]
        )
        
        dialogueTree["riskPath"] = DialogueNode(
            id: "riskPath",
            text: "Du entscheidest dich für den schnellen, risikoreichen Weg. Mit Adrenalin in den Adern setzt du Kurs auf die pulsierende Megacity. Doch dein Flugzeug ist noch nicht perfekt ausbalanciert – ein heftiger Sturm bricht los und zwingt dich, schnell zu handeln.",
            choices: [
                DialogueChoice(text: "Kämpfe dich durch den Sturm", nextNodeId: "stormBattle", storyPoints: 20),
                DialogueChoice(text: "Weiche aus und suche Schutz", nextNodeId: "seekShelter", storyPoints: 5)
            ]
        )
        
        dialogueTree["safePath"] = DialogueNode(
            id: "safePath",
            text: "Du entscheidest dich für den sicheren Weg, der zwar länger dauert, aber das Risiko minimiert. Während des langsamen Fluges entdeckst du wertvolle Hinweise und Ressourcen, die dir auf deinem weiteren Weg helfen.",
            choices: [
                DialogueChoice(text: "Erkunde die Umgebung", nextNodeId: "explore", storyPoints: 15),
                DialogueChoice(text: "Setze die Mission fort", nextNodeId: "continueMission", storyPoints: 10)
            ]
        )
        
        dialogueTree["stormBattle"] = DialogueNode(
            id: "stormBattle",
            text: "Mit unglaublichem Mut kämpfst du dich durch den Sturm. Die Turbulenzen sind heftig, doch dein waghalsiger Flugstil bringt dir den Ruf eines wagemutigen Kurierpiloten ein. (+20 StoryPoints)",
            choices: [DialogueChoice(text: "Continue", nextNodeId: "end", storyPoints: 20)]
        )
        
        dialogueTree["seekShelter"] = DialogueNode(
            id: "seekShelter",
            text: "Du suchst schnell Schutz vor dem Sturm. Obwohl du den Sturm überlebst, verlierst du wertvolle Zeit und Energie. (+5 StoryPoints)",
            choices: [DialogueChoice(text: "Continue", nextNodeId: "end", storyPoints: 5)]
        )
        
        dialogueTree["explore"] = DialogueNode(
            id: "explore",
            text: "Beim Erkunden entdeckst du verborgene Geheimnisse der Megacity: verlassene Hangars, geheime Treffpunkte und Hinweise auf zukünftige Missionen. Dein Netzwerk wächst stetig. (+15 StoryPoints)",
            choices: [DialogueChoice(text: "Continue", nextNodeId: "end", storyPoints: 15)]
        )
        
        dialogueTree["continueMission"] = DialogueNode(
            id: "continueMission",
            text: "Mit kühlem Kopf setzt du deine Mission fort. Deine überlegte Herangehensweise führt dazu, dass du das Paket sicher ablieferst. (+10 StoryPoints)",
            choices: [DialogueChoice(text: "Continue", nextNodeId: "end", storyPoints: 10)]
        )
        
        dialogueTree["end"] = DialogueNode(
            id: "end",
            text: "Die Mission ist abgeschlossen. Dein Fortschritt im Karrieremodus wird aktualisiert. Drücke 'Return to Main Menu', um zurückzukehren.",
            choices: [DialogueChoice(text: "Return to Main Menu", nextNodeId: "mainMenu", storyPoints: 0)]
        )
        
        dialogueTree["mainMenu"] = DialogueNode(
            id: "mainMenu",
            text: "Vielen Dank für deine Mission. Dein Karrierefortschritt wurde gespeichert.\n\n(StoryPoints: \(CareerManager.shared.storyPoints))\n\nDrücke 'Continue', um ins Hauptmenü zurückzukehren.",
            choices: [DialogueChoice(text: "Continue", nextNodeId: "exit", storyPoints: 0)]
        )
        
        // Das "exit"-Node signalisiert das Ende der StoryScene. Hier wechseln wir zurück ins Hauptmenü.
        dialogueTree["exit"] = DialogueNode(
            id: "exit",
            text: "Du kehrst zurück ins Hauptmenü.",
            choices: nil
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            if let nodeName = node.name, nodeName.starts(with: "choice_") || nodeName == "continueButton" {
                if nodeName.starts(with: "choice_") {
                    let indexString = nodeName.replacingOccurrences(of: "choice_", with: "")
                    if let index = Int(indexString),
                       let choices = dialogueTree[currentNodeId]?.choices,
                       index < choices.count {
                        let choice = choices[index]
                        CareerManager.shared.addStoryPoints(choice.storyPoints)
                        displayDialogue(nodeId: choice.nextNodeId)
                        return
                    }
                } else if nodeName == "continueButton" {
                    // Standard "Continue" Aktion
                    displayDialogue(nodeId: getDefaultNextNode())
                    return
                }
            }
        }
        
        // Falls kein spezieller Button berührt wurde, gehe einfach zur nächsten Zeile (Continue)
        displayDialogue(nodeId: getDefaultNextNode())
    }
    
    func getDefaultNextNode() -> String {
        // Wenn es keine Wahl gibt, wird als Default "continueButton" verwendet,
        // oder wir wechseln zum "mainMenu".
        // Hier geben wir "mainMenu" zurück, um zum Hauptmenü zu gelangen.
        return "mainMenu"
    }
}
