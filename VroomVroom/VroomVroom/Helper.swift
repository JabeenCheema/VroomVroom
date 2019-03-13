//
//  Helper.swift
//  VroomVroom
//
//  Created by Jabeen's MacBook on 3/13/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import Foundation
import UIKit


class Helper: NSObject {
    func randomBetweenTwoNums(firstNumber: CGFloat, secondNumber: CGFloat) -> CGFloat {
        return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(firstNumber - secondNumber) + min(firstNumber, secondNumber)
    }
}

// so the func is helping us get a random num from a range
// which we set up in our func leftTraffic 
