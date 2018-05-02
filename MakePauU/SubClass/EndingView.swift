//
//  EndingView.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/2.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class EndingView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let window = UIApplication.shared.keyWindow{
            
            self.backgroundColor = UIColor(netHex: 0xFFFFFF)
            self.frame.size = CGSize(width: window.frame.size.width - 50, height: window.frame.size.height - 80)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            swipeRight.direction = .right
            self.addGestureRecognizer(swipeRight)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            swipeLeft.direction = .left
            self.addGestureRecognizer(swipeLeft)
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer){
        
        if gesture.direction == .left{
            if let window = UIApplication.shared.keyWindow {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.frame = CGRect(x: window.frame.size.width * -1 , y: self.frame.origin.y + 20, width: self.frame.width, height: self.frame.height)
                
                }, completion: { (finish: Bool) in
                    
                    self.isHidden = true
                })
            }
        } else if gesture.direction == .right{
            if let window = UIApplication.shared.keyWindow {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.frame = CGRect(x: window.frame.size.width * 1 , y: self.frame.origin.y + 20, width: self.frame.width, height: self.frame.height)
                    
                }, completion: { (finish: Bool) in
                    
                    self.isHidden = true
                })
            }
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
