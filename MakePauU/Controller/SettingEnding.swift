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
    
    var views = [UIView]()
    var num = 5
    
    func showSetting(){
        
        if let window = UIApplication.shared.keyWindow{
    
            print(window.frame.size.width)
            print(window.frame.size.height)
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.6)
            
            blackView.frame = window.frame  // set constraint
            blackView.alpha = 0
            window.addSubview(blackView)
            
            
            for _ in 1...num {
                let view = EndingView()
                views.append(view)
                
                view.center = blackView.center
                blackView.addSubview(view)
            }
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                for view in self.views{
                    view.frame.size = CGSize(width: window.frame.size.width - 60, height: window.frame.size.height - 100)
                    view.center = self.blackView.center
                }
                
            }, completion: nil)
        }
    }
    
    // serve as viewDidLoad
    override init() {
        super.init()
        
    }
}
