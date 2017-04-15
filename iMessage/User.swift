//
//  User.swift
//  iMessage
//
//  Created by Mat Schmid on 2017-04-10.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import UIKit

class User: NSObject {
    var name : String?
    var email : String?
    var profileImageURL : String?
    var id : String?
    
    init(dictionary: [AnyHashable: Any]) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageURL = dictionary["profileImageUrl"] as? String
    }
}
