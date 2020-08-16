//
//  FDBusiness.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class FDBusiness: NSObject {
    var uid: String = ""
    var username: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var location: String = ""
    var photoUri: String = ""
    var service: String = ""
    var type: String = ""
    var followers = [String]()
    var pendingIDs = [String]()
    var goldenCoin: Int = 0
    var latitude: Double = 0
    var longitude: Double = 0
    var has_scrimit_pass: Bool = false
    var available_mode: Bool = false
    var scrimit_pass_expiry: Int = 0
    
    
    init(_ id: String) {
        super.init()
        
        uid = id
        type = UserType.coach.rawValue
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
        latitude = (dict["latitude"] ?? 0.0) as! Double
        longitude = (dict["longitude"] ?? 0.0) as! Double
        photoUri = (dict["photoUri"] ?? "") as! String
        type = (dict["type"] ?? "") as! String
        service = (dict["service"] ?? "") as! String
        goldenCoin = (dict["goldenCoin"] ?? 0) as! Int
        has_scrimit_pass = (dict["has_scrimit_pass"] ?? false) as! Bool
        available_mode = (dict["available_mode"] ?? false) as! Bool
        scrimit_pass_expiry = (dict["scrimit_pass_expiry"] ?? 0) as! Int
        
        if let items = dict["followers"] {
            followers = Array((items as! [String: String]).values)
        }
        
        if let items = dict["pendingIds"] {
            pendingIDs = Array((items as! [String: String]).values)
        }
    }
    
    
    func FDdata() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["uid"] = uid
        dict["username"] = username
        dict["email"] = email
        dict["phoneNumber"] = phoneNumber
        dict["location"] = location
        dict["latitude"] = latitude
        dict["longitude"] = longitude
        dict["photoUri"] = photoUri
        dict["type"] = type
        dict["service"] = service
        dict["goldenCoin"] = goldenCoin
        dict["has_scrimit_pass"] = has_scrimit_pass
        dict["available_mode"] = available_mode
        dict["scrimit_pass_expiry"] = scrimit_pass_expiry
        
        var subDict = [String: String]()
        for item in followers {
            subDict[item] = item
        }
        dict["followers"] = subDict
        
        subDict = [String: String]()
        for item in followers {
            subDict[item] = item
        }
        dict["pendingIds"] = subDict
        
        return dict
    }
}
