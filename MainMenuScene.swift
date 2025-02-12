//
//  MainMenuScene.swift
//  SkyCraftBuildAndFly
//
//  Erstellt von ChatGPT
//  Zeigt das Hauptmenü mit den Optionen "Build Your Plane" und "Start Flight"
//

import SpriteKit

class MainMenuScene: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = .blue
        
        let title = SKLabelNode(text: "SkyCraft: Build & Fly")
        title.fontSize = 40
        title.fontColor = .white
        title.position = CGPoint(x: size.width/2, y: size.height*0.75)
        addChild(title)
        
        let buildButton = SKLabelNode(text: "Build Your Plane")
        buildButton.name = "buildButton"
        buildButton.fontSize = 30
        buildButton.fontColor = .green
        buildButton.position = CGPoint(x: size.width/2, y: size.height*0.5)
        addChild(buildButton)
        
        let flightButton = SKLabelNode(text: "Start Flight")
        flightButton.name = "flightButton"
        flightButton.fontSize = 30
        flightButton.fontColor = .yellow
        flightButton.position = CGPoint(x: size.width/2, y: size.height*0.4)
        addChild(flightButton)
        
        let shopButton = SKLabelNode(text: "Shop")
        shopButton.name = "shopButton"
        shopButton.fontSize = 30
        shopButton.fontColor = .orange
        shopButton.position = CGPoint(x: size.width/2, y: size.height*0.3)
        addChild(shopButton)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            if node.name == "buildButton" {
                let hangarScene = HangarScene(size: size)
                hangarScene.scaleMode = .aspectFill
                self.view?.presentScene(hangarScene, transition: SKTransition.fade(withDuration: 1.0))
            } else if node.name == "flightButton" {
                let flightScene = FlightScene(size: size)
                flightScene.scaleMode = .aspectFill
                self.view?.presentScene(flightScene, transition: SKTransition.fade(withDuration: 1.0))
                else if node.name == "shopButton" {
                let shopScene = ShopScene(size: size)
                shopScene.scaleMode = .aspectFill
                self.view?.presentScene(shopScene, transition: SKTransition.fade(withDuration: 1.0))
}

            }
        }
    }
}
