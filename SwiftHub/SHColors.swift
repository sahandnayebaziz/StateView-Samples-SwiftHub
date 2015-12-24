//
//  SHColors.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/21/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit

struct SHColors {
    private static func createColorFromRGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
    
    static var grayBlue: UIColor {
        return createColorFromRGB(220, g: 222, b: 227)
    }
    
    static var grayLight: UIColor {
        return createColorFromRGB(200, g: 200, b: 200)
    }
    
    static var grayLightest: UIColor {
        return createColorFromRGB(244, g: 244, b: 244)
    }
    
    static var blue: UIColor {
        return createColorFromRGB(74, g: 144, b: 226)
    }
}