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
    
    // now in order to move our cars
    var canMove = false
    var leftCarToMoveLeft = true
    var rightCarToMoveRight = true
    
    var leftCarAtRight = false
    var rightCarAtLeft = false
    // after the func tocuhesbegan we create these vars
    var centerPoint: CGFloat!
    // we want to more cars based on position
    let leftCarMinX: CGFloat = -280
    let leftCarMaxX: CGFloat = -100  // we want to make sure it doesn't go past the middle lane 
    
    let rightCarMinX: CGFloat = 100
    let rightCarMaxM: CGFloat = 280
    
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
    
    // now we want the user to be able to move the cars on the screen, after this func we declare more variables
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            if touchLocation.x > centerPoint { // meaning on the right size
                if rightCarAtLeft {
                    rightCarAtLeft = false  // if right car is on the leftside of its lane
                    rightCarToMoveRight = true  // which is its initial position
                } else {
                    rightCarAtLeft = true
                    rightCarToMoveRight = false
                }
            } else {
                if leftCarAtRight {
                    leftCarAtRight = false
                    leftCarToMoveLeft = true  // which is its initial position
                } else {
                    leftCarAtRight = true
                    leftCarToMoveLeft = false
                }
            }
        canMove = true   // if the user touches the screen they will be able to move the car
        }
    }
    
    
    
    // instead of puttng it in the viewdidLoad we are doing a func
    func setUp() {
        leftCar = self.childNode(withName: "leftCar") as! SKSpriteNode
        rightCar = self.childNode(withName: "rightCar") as! SKSpriteNode
        centerPoint = self.frame.size.width / self.frame.size.height // getting the exact center
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

    
    func removeItems() {
        for child in children {   // children - all the nodes in my GameScene
            if child.position.y < -self.size.height - 100 { // we are creating the (white lines on the road)lines from the upper side but the lines go down so we use -self
                // so everytime the strips go down it will be removed my the parent, this is useful for optimization
            child.removeFromParent()
        }
    }
    }
    
    
    
}
