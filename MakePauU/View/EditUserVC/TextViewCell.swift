//
//  TextViewCell.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/1.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentTextView.delegate = self
        //adjustTextViewHeight()
    }
    
    func adjustTextViewHeight() {
    
        let fixedWidth = contentTextView.frame.size.width
        let newSize = contentTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        self.contentViewHeight.constant = newSize.height
            
        self.layoutIfNeeded()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //self.adjustTextViewHeight()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
}
