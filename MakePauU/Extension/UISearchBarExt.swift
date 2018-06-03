//
//  UISearchBarExt.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/16.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        // TextField Color Customization
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(netHex: 0xE9A11A)
         
        
        // Glass Icon Customization
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = UIColor(netHex: 0xE9A11A)
        
        // Clear Button Customization
        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = UIColor(netHex: 0xE9A11A)
        
        self.isTranslucent = false
        
    }
}
