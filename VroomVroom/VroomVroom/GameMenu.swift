//
//  GameMenu.swift
//  VroomVroom
//
//  Created by Jabeen's MacBook on 3/13/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import Foundation
import SpriteKit

class GameMenu: SKScene {
    
    // we need to initialize the label
    var startGame = SKLabelNode()
    var bestScore = SKLabelNode()
    var gameSettings = Settings.sharedInstance
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        startGame = self.childNode(withName: "startGame") as! SKLabelNode
        bestScore = self.childNode(withName: "bestScore") as! SKLabelNode
        bestScore.text = "Best : \(gameSettings.highScore)"
    }
// now we want to restart the game
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "startGame" {
                let gameScene = SKScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
            }
        }
    }


}
