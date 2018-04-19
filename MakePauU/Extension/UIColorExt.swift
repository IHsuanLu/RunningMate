//
//  UIColorExt.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/1.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

/** extension to UIColor to allow setting the color
 value by hex value */
extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        
        /** Verify that we have valid values */
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /** Initializes and sets color by hex value */
    convenience init(netHex:Int) {
        
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
}
