//
//  CustomTabBar.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/8.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class CustomTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 0.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height
        }
        return sizeThatFits
    }
}
