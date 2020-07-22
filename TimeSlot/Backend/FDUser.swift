//
//  FDUser.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class FDUser: NSObject {
    var uid: String = ""
    var username: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var type: String = ""
    
    
    init(_ id: String) {
        super.init()
        
        uid = id
    }
    
    
    init(_ dict:[String: Any]) {
        super.init()
        
        uid = (dict["uid"] ?? "") as! String
        username = (dict["username"] ?? "") as! String
        email = (dict["email"] ?? "") as! String
        phoneNumber = (dict["phoneNumber"] ?? "") as! String
        type = (dict["type"] ?? "") as! String
    }
    
    
    func FDdata() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["uid"] = uid
        dict["username"] = username
        dict["email"] = email
        dict["phoneNumber"] = phoneNumber
        dict["type"] = type
        
        return dict
    }
}
