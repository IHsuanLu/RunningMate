//
//  SetLoadingScreen.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/8.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class SetLoadingScreen: NSObject {
    
    static let sharedInstance = SetLoadingScreen()
    
    var activityIndicator = UIActivityIndicatorView()
    var whiteView = UIView()
    
    func startActivityIndicator(view: UIView){
        
        activityIndicator.frame.origin = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2 - 80)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        whiteView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        whiteView.backgroundColor = UIColor(netHex: 0xFFFFFF)
        whiteView.alpha = 0.6
        
        view.addSubview(whiteView)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        //make sure your app stop receiving any input
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
        whiteView.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

