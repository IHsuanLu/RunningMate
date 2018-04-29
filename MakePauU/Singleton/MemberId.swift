//
//  MemberId.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/29.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import Foundation

class MemberId {
    
    static var sharedInstance = MemberId()
    
    private init() {
        
    }
    
    var member_id: String = ""
}
