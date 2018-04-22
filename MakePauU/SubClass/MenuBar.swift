//
//  MenuBar.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/21.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class MenuBar: UIView{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor(netHex: 0xE9A11A).cgColor
    }
}
