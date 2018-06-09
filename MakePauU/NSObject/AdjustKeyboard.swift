//
//  AdjustKeyboard.swift
//  StayTuned App
//
//  Created by 呂易軒 on 2018/5/5.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class AdjustKeyboard: NSObject {
    
    static let sharedInstance = AdjustKeyboard()
    
    var frameView = UIView()
    var activeTextField = UITextField()
    var activeTextView = UITextView()
    
    func keyboardStatus(frameView view: UIView, activeTextField textField: UITextField){
        
        self.frameView = view
        self.activeTextField = textField
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // action for keyboard observers
    @objc func keyboardDidShow(notification: NSNotification) {
        
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let keyboardY = frameView.frame.size.height - keyboardSize.height
        
        let editingTextFieldY:CGFloat! = self.activeTextField.frame.origin.y
        
        if frameView.frame.origin.y >= 0 {
            
            //Checking if the textfield is really hidden behind the keyboard
            if editingTextFieldY > keyboardY - 30 {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.frameView.frame = CGRect(x: 0, y: self.frameView.frame.origin.y - (editingTextFieldY! - (keyboardY - 60)), width: self.frameView.bounds.width,height: self.frameView.bounds.height)
                }, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.frameView.frame = CGRect(x: 0, y: 0,width: self.frameView.bounds.width, height: self.frameView.bounds.height)
        }, completion: nil)
    }
    
    
    func keyboardStatus_TextView(frameView view: UIView, activeTextView textView: UITextView){
        
        self.frameView = view
        self.activeTextView = textView
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow_TextView), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide_TextView), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // action for keyboard observers
    @objc func keyboardDidShow_TextView(notification: NSNotification) {
        
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let keyboardY = frameView.frame.size.height - keyboardSize.height
        
        let editingTextFieldY:CGFloat! = self.activeTextView.frame.origin.y
        
        if frameView.frame.origin.y >= 0 {
            
            //Checking if the textfield is really hidden behind the keyboard
            if editingTextFieldY > keyboardY - 30 {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.frameView.frame = CGRect(x: 0, y: self.frameView.frame.origin.y - (editingTextFieldY! - (keyboardY - 60)), width: self.frameView.bounds.width,height: self.frameView.bounds.height)
                }, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillHide_TextView(notification: NSNotification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.frameView.frame = CGRect(x: 0, y: 0,width: self.frameView.bounds.width, height: self.frameView.bounds.height)
        }, completion: nil)
    }
}
