//
//  UIButtonExt.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/1.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

extension UIButton{
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setTitleColor(UIColor.gray, for: UIControlState.selected)
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    
}
