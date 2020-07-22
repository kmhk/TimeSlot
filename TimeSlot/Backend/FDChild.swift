//
//  FDChild.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class FDChild: NSObject {
    var uid: String = ""
    var username: String = ""
    var parent: String = ""
    var location: String = ""
    var photoUri: String = ""
    var birthDay: Date?
    
    
    init(_ id: String) {
        super.init()
        
        uid = id
    }
    
    init(_ dict:[String: Any]) {
        super.init()
        
        uid = (dict["uid"] ?? "") as! String
        username = (dict["username"] ?? "") as! String
        parent = (dict["parent"] ?? "") as! String
        location = (dict["location"] ?? "") as! String
        photoUri = (dict["photoUri"] ?? "") as! String
        
        let interval = (dict["birthDay"] ?? 0) as! Int
        birthDay = Date(timeIntervalSince1970: TimeInterval(interval / 1000))
    }
    
    func FDdata() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["uid"] = uid
        dict["username"] = username
        dict["parent"] = parent
        dict["location"] = location
        dict["photoUri"] = photoUri
        dict["birthDay"] = Int(birthDay!.timeIntervalSince1970 * 1000)
        
        return dict
    }
}
