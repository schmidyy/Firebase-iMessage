//
//  Message.swift
//  iMessage
//
//  Created by Mat Schmid on 2017-04-13.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromID: String?
    var text: String?
    var timestamp: NSNumber?
    var toID: String?
    
    init(dictionary: [String: Any]) {
        self.fromID = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toID = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
    }
    
    
    func chatPartnerID() -> String? {
        return self.fromID == FIRAuth.auth()?.currentUser?.uid ? toID : fromID
    }
    

}
