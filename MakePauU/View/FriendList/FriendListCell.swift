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
    @IBOutlet weak var metTimesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 27.5
        chatBtn.layer.cornerRadius = 12.5
    }
}
