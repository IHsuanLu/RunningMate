//
//  SearchBarSegue.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/16.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class SearchBarSegue: UIStoryboardSegue {
    
    // customize segue
    override func perform() {
        scale()
    }
    
    // deal with animation
    func scale(){
        
        //設定角色
        let toVC = self.destination
        let fromVC = self.source
        
        //access UI Window
        let containerView = fromVC.view.superview
        containerView?.addSubview(toVC.view)
        
        UIView.animate(withDuration: 0.01, delay: 0, options: .curveEaseInOut, animations: {
            
            fromVC.view.alpha = 0
            
        }, completion: { success in
            
            UIView.animate(withDuration: 0.01, animations: {
                toVC.view.alpha = 1
            }, completion: nil)
            
            fromVC.present(toVC, animated: false, completion: nil)
        })
    }
}


class UnwindSearchBarSegue: UIStoryboardSegue{
    
    // customize segue
    override func perform() {
        scale()
    }
    
    // deal with animation
    func scale(){
        
        //設定角色
        let toVC = self.destination
        let fromVC = self.source
        
        fromVC.view.superview?.insertSubview(toVC.view, at: 0)
        
        UIView.animate(withDuration: 0.01, delay: 0, options: .curveEaseInOut, animations: {
            
            fromVC.view.alpha = 0.9
            
        }, completion: { success in
            
            UIView.animate(withDuration: 0.01, animations: {
                toVC.view.alpha = 1
            }, completion: nil)
            
            fromVC.dismiss(animated: true, completion: nil)
        })
    }
}
