//
//  CustomButton.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/8.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class CustomButton: UIButton{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor(netHex: 0xE9A11A).cgColor
        self.layer.cornerRadius = 8.0
    }
}
