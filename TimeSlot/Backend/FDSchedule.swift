//
//  FDSchedule.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class FDSchedule: NSObject {
    var id: String = ""
    var uid: String = ""
    var type: String = ""
    var start: Date?
    var end: Date?
    
    
    init(_ id: String) {
        super.init()
        
        self.id = id
    }
    
    
    init(_ dict:[String: Any]) {
        super.init()
        
        id = (dict["id"] ?? "") as! String
        uid = (dict["uid"] ?? "") as! String
        type = (dict["type"] ?? "") as! String
        
        let startInt = (dict["start"] ?? 0) as! Int
        start = Date(timeIntervalSince1970: TimeInterval(startInt / 1000))
        
        let endInt = (dict["end"] ?? 0) as! Int
        end = Date(timeIntervalSince1970: TimeInterval(endInt / 1000))
    }
    
    
    func FDdata() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["id"] = id
        dict["uid"] = uid
        dict["type"] = type
        dict["start"] = Int(start!.timeIntervalSince1970 * 1000)
        dict["end"] = Int(end!.timeIntervalSince1970 * 1000)
        
        return dict
    }
}
