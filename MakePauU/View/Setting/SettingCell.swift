//
//  SettingCell.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/24.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
}
