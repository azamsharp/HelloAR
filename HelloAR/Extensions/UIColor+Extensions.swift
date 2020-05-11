//
//  UIColor+Extensions.swift
//  HelloAR
//
//  Created by Mohammad Azam on 5/11/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func random() -> UIColor {
        
        return UIColor(displayP3Red: CGFloat(Double.random(in: 0...1)), green: CGFloat(Double.random(in: 0...1)), blue: CGFloat(Double.random(in: 0...1)), alpha: 1.0)
        
    }
    
}
