//
//  StartStatus.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/15.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import Foundation

//for startgameVC 判斷
class StartStatus {
    
    static var sharedInstance = StartStatus()
    
    private init() {
        
    }
    
    var ifEntered: Bool = false
}
