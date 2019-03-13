//
//  Helper.swift
//  VroomVroom
//
//  Created by Jabeen's MacBook on 3/13/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import Foundation
import UIKit

// for the collison declare the cars as a physics body so we need to setup some static properties

struct ColliderType {
    static let CAR_COLLIDER: UInt32 = 0
    static let ITEM_COLLIDER: UInt32 = 1
    static let ITEM_COLLIDER_1: UInt32 = 2 
}
class Helper: NSObject {
    func randomBetweenTwoNums(firstNumber: CGFloat, secondNumber: CGFloat) -> CGFloat {
        return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(firstNumber - secondNumber) + min(firstNumber, secondNumber)
    }
}

// so the func is helping us get a random num from a range
// which we set up in our func leftTraffic 

// to save  the score
class Settings {
    static let sharedInstance = Settings()
    
    private init() {
        
    }
    
    var highScore = 0 
}
