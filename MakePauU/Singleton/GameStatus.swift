//
//  GameStatus.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/20.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import Foundation

class GameStatus {
    
    static var sharedInstance = GameStatus()
    
    private init() {
        
    }
    
    var ifStarted: Bool = false
}

