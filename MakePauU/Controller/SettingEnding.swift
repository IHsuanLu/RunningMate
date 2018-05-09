//
//  SettingEnding.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/2.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import Foundation

class SettingEnding: NSObject{
    
    let blackView = UIView()
    
    //調整view位置
    var centers = CGPoint()
    
    var views = [UIView]()
    var num = 5  // user numbers

    func showSetting(){
        
        if let window = UIApplication.shared.keyWindow{
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.6)
            
            blackView.frame = window.frame  // set constraint
            blackView.alpha = 0
            window.addSubview(blackView)
            
            
            centers = blackView.center
            centers.y = blackView.center.y + 12
            
            
            for i in 1...num {
                
                let view = EndingView(frame: .zero, counter: i)
                views.append(view)
                
                view.center = centers
                blackView.addSubview(view)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
            }, completion: nil)
            
            for view in self.views{
                
                view.frame.size = CGSize(width: window.frame.size.width - 60, height: window.frame.size.height - 100)
                
                self.centers.y = self.centers.y - CGFloat(3.5)
                print(self.centers.y)
                view.center = self.centers
            }
        }
    }
    
    // serve as viewDidLoad
    override init() {
        super.init()
        
    }
}
