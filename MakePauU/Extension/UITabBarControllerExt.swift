//
//  UITabBarControllerExt.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/8.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

extension UITabBarController{
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tabBar.isTranslucent = false
        self.tabBar.layer.borderWidth = 0.0
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.tintColor = UIColor(netHex: 0xFFFFFF)
        
        var tabFrame = self.tabBar.frame
        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
        tabFrame.size.height = 60
        tabFrame.size.width = self.view.frame.width

        tabFrame.origin.y = self.view.frame.size.height - 60
        self.tabBar.frame = tabFrame
        
        setUpSeparators()
    }
    
    func setUpSeparators(){

        let itemWidth = self.tabBar.frame.size.width / 4
        let separatorWidth: CGFloat = 1
        
        for i in 1...5{
            
            let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(i) , y: 0, width: CGFloat(separatorWidth), height: 60))
            
            separator.backgroundColor = UIColor.white
            
            self.tabBar.addSubview(separator)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
