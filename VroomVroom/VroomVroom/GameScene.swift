//
//  GameScene.swift
//  VroomVroom
//
//  Created by Jabeen's MacBook on 3/12/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // now we want both the car properties here
    
    var leftCar = SKSpriteNode()
    var rightCar = SKSpriteNode()
    
    
    
    
    // whenever the scene is called this method is initialized
    override func didMove(to view: SKView) {
        //set the anchor point of the scene, we are centering it
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
        // until I did have have this Timer part set up when I ran my app I just saw one road line but this will make the line appear every 0.1 sec
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.createRoadLines), userInfo: nil, repeats: true)
    }

    // default method
    // this method is calling every frame per sec, we have 60 frames so will be called 60 times per sec
    override func update(_ currentTime: TimeInterval) {
        showRoadLine()  // this update func calls showRoadLine 60 times so everytime it will subtract your position by 30
    }
    
    
    // instead of puttng it in the viewdidLoad we are doing a func
    func setUp() {
        leftCar = self.childNode(withName: "leftCar") as! SKSpriteNode
        rightCar = self.childNode(withName: "rightCar") as! SKSpriteNode
    }

    // we want the cars moving straight on the road
    @objc func createRoadLines() {
        let leftRoadLine = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        leftRoadLine.strokeColor = SKColor.white
        leftRoadLine.fillColor = SKColor.white
        leftRoadLine.alpha = 0.4 // this makes it tranparent
        leftRoadLine.name = "leftRoadLine"
        leftRoadLine.zPosition = 10
        leftRoadLine.position.x = -187.5 // this is the middle point for the left side car between the green and the peach line (that separates both cars)
        leftRoadLine.position.y = 700
        addChild(leftRoadLine)
        
        
        let rightRoadLine = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        rightRoadLine.strokeColor = SKColor.white
        rightRoadLine.fillColor = SKColor.white
        rightRoadLine.alpha = 0.4 // this makes it transparent
        rightRoadLine.name = "rightRoadLine"
        rightRoadLine.zPosition = 10
        rightRoadLine.position.x = 187.5 // this is the middle point for the right side car between the green and the peach line (that separates both cars)
        rightRoadLine.position.y = 700
        addChild(rightRoadLine)
        
        
    }

    func showRoadLine() {
        enumerateChildNodes(withName: "leftRoadLine", using: { (roadLine, stop) in
            let line = roadLine as! SKShapeNode
            line.position.y -= 30    // whatever the height is this subtracts 30
        })
        enumerateChildNodes(withName: "rightRoadLine", using: { (roadLine, stop) in
            let line = roadLine as! SKShapeNode
            line.position.y -= 30
        })
    }

}
