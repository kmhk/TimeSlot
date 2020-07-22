//
//  FDPersonal.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class FDPersonal: NSObject {
    var uid: String = ""
    var username: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var location: String = ""
    var photoUri: String = ""
    var type: String = ""
    var childIds = [String]()
    var goldenCoin: Int = 0
    var has_scrimit_pass: Bool = false
    var scrimit_pass_expiry: Int = 0
    
    
    init(_ id: String) {
        super.init()
        
        uid = id
        type = UserType.personal.rawValue
        goldenCoin = 10
        has_scrimit_pass = false
        scrimit_pass_expiry = -1
    }
    
    
    init(_ dict:[String: Any]) {
        super.init()
        
        uid = (dict["uid"] ?? "") as! String
        username = (dict["username"] ?? "") as! String
        email = (dict["email"] ?? "") as! String
        phoneNumber = (dict["phoneNumber"] ?? "") as! String
        location = (dict["location"] ?? "") as! String
        photoUri = (dict["photoUri"] ?? "") as! String
        type = (dict["type"] ?? "") as! String
        goldenCoin = (dict["goldenCoin"] ?? 0) as! Int
        has_scrimit_pass = (dict["has_scrimit_pass"] ?? false) as! Bool
        scrimit_pass_expiry = (dict["scrimit_pass_expiry"] ?? 0) as! Int
        
        if let items = dict["childIds"] {
            childIds = Array((items as! [String: String]).values)
        }
    }
    
    
    func FDdata() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["uid"] = uid
        dict["username"] = username
        dict["email"] = email
        dict["phoneNumber"] = phoneNumber
        dict["location"] = location
        dict["photoUri"] = photoUri
        dict["type"] = type
        dict["goldenCoin"] = goldenCoin
        dict["has_scrimit_pass"] = has_scrimit_pass
        dict["scrimit_pass_expiry"] = scrimit_pass_expiry
        
        var subDict = [String: String]()
        for item in childIds {
            subDict[item] = item
        }
        dict["childIds"] = subDict
        
        return dict
    }
}
