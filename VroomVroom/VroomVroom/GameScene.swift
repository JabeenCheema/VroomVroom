//
//  GameScene.swift
//  VroomVroom
//
//  Created by Jabeen's MacBook on 3/12/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {  // in order to get collision to work we need Physics
    
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
        physicsWorld.contactDelegate = self 
        // until I did not have have this Timer part set up when I ran my app I just saw one road line but this will make the line appear every 0.1 sec
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.createRoadLines), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: (TimeInterval(Helper().randomBetweenTwoNums(firstNumber: 0, secondNumber: 1.8))), target: self, selector: #selector(GameScene.leftTraffic), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: (TimeInterval(Helper().randomBetweenTwoNums(firstNumber: 0, secondNumber: 1.8))), target: self, selector: #selector(GameScene.rightTraffic), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.2), target: self, selector: #selector(GameScene.removeItems), userInfo: nil, repeats: true)
    }

    // default method
    // this method is calling every frame per sec, we have 60 frames so will be called 60 times per sec
    override func update(_ currentTime: TimeInterval) {
        if canMove {
            moveLeftCar(leftSide: leftCarToMoveLeft)  // when i run my app and i touch the car it disappears because we have not set the max and min borders of the car
            moveRightCar(rightSide: rightCarToMoveRight)
        }
        showRoadLine()  // this update func calls showRoadLine 60 times so everytime it will subtract your position by 30
    }
    
    // whenever a collision happens
    // there is no collision detected yet because we initialized the bodies as cicrcleRadius (look in funcs leftTraffic and rightTraffic), after this we need to go to the GameScene.sks select the cars and the Physics Def Bounding rectangle
    // our car also goes down so we also need to disable gravity 
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        // everytime a collision happens we have to identify which body is our car
        if contact.bodyA.node?.name == "leftCar" || contact.bodyA.node?.name == "rightCar" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        // so we can easily remove when the collision happens
    firstBody.node?.removeFromParent()
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
        
        leftCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        leftCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        leftCar.physicsBody?.collisionBitMask = 0
        
        rightCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        rightCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER_1
        rightCar.physicsBody?.collisionBitMask = 0
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
            line.position.y -= 30  // this is setting the speed of moving it
        })
        enumerateChildNodes(withName: "orangeCar", using: { (leftCar, stop) in
            let car = leftCar as! SKSpriteNode
            car.position.y -= 30
        })
        enumerateChildNodes(withName: "greenCar", using: { (rightCar, stop) in
            let car = rightCar as! SKSpriteNode
            car.position.y -= 30
        })
    }

    
    @objc func removeItems() {
        for child in children {   // children - all the nodes in my GameScene
            if child.position.y < -self.size.height - 100 { // we are creating the (white lines on the road)lines from the upper side but the lines go down so we use -self
                // so everytime the strips go down it will be removed my the parent, this is useful for optimization
            child.removeFromParent()  
            }
        }
    }
    
    func moveLeftCar(leftSide: Bool) {
        if leftSide {
            leftCar.position.x -= 20 // if the car is on the left side in the lane its moving towards the right side
            // at this point when i run my code my car moves from left to right within the boundaries and within its lane
            if leftCar.position.x < leftCarMinX { // here we are setting the boundaries so the car does not disappear from the screen
                leftCar.position.x = leftCarMinX
            }
        } else {
            leftCar.position.x += 20 // if the car is on the right in the lane its moving towrds the left side
            if leftCar.position.x > leftCarMaxX {
                leftCar.position.x = leftCarMaxX
            }
        }
    }
    
    func moveRightCar(rightSide: Bool) { // now we are able to toggle both our cars 
        if rightSide {
            rightCar.position.x += 20
            if rightCar.position.x > rightCarMaxM {
                rightCar.position.x = rightCarMaxM
            }
        } else {
            rightCar.position.x -= 20
            if rightCar.position.x < rightCarMinX {
                rightCar.position.x = rightCarMinX
            }
        }
    }

    @objc func leftTraffic() {
        let leftTrafficItem: SKSpriteNode!
        let randomNum = Helper().randomBetweenTwoNums(firstNumber: 1, secondNumber: 8)
        switch Int(randomNum) {
        case 1...4:
            leftTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
            leftTrafficItem.name = "orangeCar"
            break
        case 5...8:
            leftTrafficItem = SKSpriteNode(imageNamed: "greenCar")
            leftTrafficItem.name = "greenCar"
            break
        default:
            leftTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
            leftTrafficItem.name = "orangeCar"
        }
    leftTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    leftTrafficItem.zPosition = 10
        let randomNumber = Helper().randomBetweenTwoNums(firstNumber: 1, secondNumber: 10)
        switch Int(randomNumber) {
        case 1...4:
            leftTrafficItem.position.x = -280
            break
        case 5...10:
            leftTrafficItem.position.x = -100
            break
        default:
            leftTrafficItem.position.x = -280
        }
        leftTrafficItem.position.y = 700
        // initialize physicsbody
        leftTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: leftTrafficItem.size.height/2)
        leftTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
        leftTrafficItem.physicsBody?.collisionBitMask = 0
        leftTrafficItem.physicsBody?.affectedByGravity = false
        addChild(leftTrafficItem)
    }

   @objc func rightTraffic() {       // now we have cars showing on both sides
        let rightTrafficItem: SKSpriteNode!
        let randomNum = Helper().randomBetweenTwoNums(firstNumber: 1, secondNumber: 8)
        switch Int(randomNum) {
        case 1...4:
            rightTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
            rightTrafficItem.name = "orangeCar"
            break
        case 5...8:
            rightTrafficItem = SKSpriteNode(imageNamed: "greenCar")
            rightTrafficItem.name = "greenCar"
            break
        default:
            rightTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
            rightTrafficItem.name = "orangeCar"
        }
        rightTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rightTrafficItem.zPosition = 10
        let randomNumber = Helper().randomBetweenTwoNums(firstNumber: 1, secondNumber: 10)
        switch Int(randomNumber) {
        case 1...4:
            rightTrafficItem.position.x = 280
            break
        case 5...10:
            rightTrafficItem.position.x = 100
            break
        default:
            rightTrafficItem.position.x = 280
        }
        rightTrafficItem.position.y = 700
    // initialize physicsbody
    rightTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: rightTrafficItem.size.height/2)
    rightTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER_1
    rightTrafficItem.physicsBody?.collisionBitMask = 0
    rightTrafficItem.physicsBody?.affectedByGravity = false
        addChild(rightTrafficItem)
    }







}
