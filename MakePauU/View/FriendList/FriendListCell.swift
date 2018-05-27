//
//  FriendListCell.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/27.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

class FriendListCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chatBtn.layer.cornerRadius = 12.5
    }
}
