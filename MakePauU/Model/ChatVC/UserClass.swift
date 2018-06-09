//
//  UserClass.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/6/9.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import Foundation

class UserClass: NSObject {
    @objc var id: String?
    @objc var name: String?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
