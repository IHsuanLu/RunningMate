//
//  CountDownVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/16.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class CountDownVC: NSObject{
    
    let blackView = UIView()
    let countDownLabel = UILabel()
    
    var timer = Timer()
    var count = 4 //倒數時間
    
    var startGameVC = StartGameVC()
    
    func showSetting(){
        // access the whole screen
        if let window = UIApplication.shared.keyWindow{
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.6)
            
            blackView.frame = window.frame  // set constraint
            blackView.alpha = 0
            window.addSubview(blackView)
            
            countDownLabel.frame.size = CGSize(width: blackView.frame.width - 40, height: blackView.frame.height - 40)
            countDownLabel.center = blackView.center
            countDownLabel.font = UIFont.boldSystemFont(ofSize: 200)
            countDownLabel.textColor = UIColor.white
            countDownLabel.textAlignment = .center
            blackView.addSubview(countDownLabel)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 1
            
        }, completion: nil)
    
        setTimer()
    }
    
    // set Timer
    func setTimer(){
        //Timer (呼叫 updateTimer every second)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        
        if count >= 2 {
            
            let seconds = String(count % 60 - 1)
            countDownLabel.text = seconds
            count = count - 1
            
        } else if count == 1 {
            
            countDownLabel.font = UIFont.boldSystemFont(ofSize: 50)
            countDownLabel.text = "開始約跑囉！"
            count = count - 1
            
        } else if count == 0 {
            
            blackView.alpha = 0
            timer.invalidate()
            
            // 計時開始
            startGameVC.setTimer_Game()
            
            // 遊戲開始
            GameStatus.sharedInstance.ifStarted = true
        }
    }
    
    func dismiss(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
        })
    }
    
    
    override init() {
        super.init()
    }
}

