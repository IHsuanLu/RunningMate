//
//  EnterRoomStatus.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/24.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import Foundation

//Overall
class EnterRoomStatus {
    
    static var sharedInstance = EnterRoomStatus()
    
    private init() {
        
    }
    
    var ifEnteredRoom: Bool = false
}
