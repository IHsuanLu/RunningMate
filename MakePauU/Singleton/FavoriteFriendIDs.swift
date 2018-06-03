//
//  FavoriteFriendIDs.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/6/3.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import Foundation

class FavoriteFriendIDs {
    
    static let sharedInstance = FavoriteFriendIDs()
    
    private init() {
        
    }
    
    var favoriteFriends: [String] = []
}
