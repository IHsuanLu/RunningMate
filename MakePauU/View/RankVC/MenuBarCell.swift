//
//  MenuBarCell.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/21.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class MenuBarCell: UICollectionViewCell{
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override var isHighlighted: Bool{
        
        didSet{
            titleLbl.textColor = isHighlighted ? UIColor(netHex: 0xE9A11A) : UIColor(netHex: 0x999999)
            self.backgroundColor = isHighlighted ? UIColor(netHex: 0xffffff) : UIColor(netHex: 0xF5F5F5)
        }
    }
    
    override var isSelected: Bool{
        
        didSet{
            titleLbl.textColor = isSelected ? UIColor(netHex: 0xE9A11A) : UIColor(netHex: 0x999999)
            self.backgroundColor = isSelected ? UIColor(netHex: 0xffffff) : UIColor(netHex: 0xF5F5F5)
        }
    }
}
