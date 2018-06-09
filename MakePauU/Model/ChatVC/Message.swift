//
//  Message.swift
//  chatchatchat
//
//  Created by Hsieh Tony on 2018/6/7.
//  Copyright © 2018 Hsieh Tony. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    @objc var toId: String?
    @objc var timestamp: NSNumber?
    @objc var text: String?
    @objc var fromId: String?
    
    init(dictionary: [String: AnyObject]) {
        
        super.init()
        toId = dictionary["toId"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        text = dictionary["text"] as? String
        fromId = dictionary["fromId"] as? String
    }
    
    func chatPartnerId() -> String? {
        if fromId == MemberId.sharedInstance.member_id {
            return toId
        } else {
            return fromId
        }
    }
}
