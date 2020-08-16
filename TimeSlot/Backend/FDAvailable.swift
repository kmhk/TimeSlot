//
//  FDAvailable.swift
//  TimeSlot
//
//  Created by com on 8/16/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class FDAvailable: NSObject {
    var id: String = ""
    var businessId: String = ""
    var title: String = ""
    var note: String = ""
    var timezone: String = ""
    var start: Date?
    var end: Date?
    var startTime: Date?
    var duration: Int = 0
    var type: RepeatType = .normal
    
    var allDay: Bool = false
    var repeatly: Bool = false
    
    var monday: Bool = false
    var tuesday: Bool = false
    var wednesday: Bool = false
    var thursday: Bool = false
    var friday: Bool = false
    var saturday: Bool = false
    var sunday: Bool = false
    
    
    init(_ dict:[String: Any]) {
        super.init()
        
        id = (dict["id"] ?? "") as! String
        businessId = (dict["businessId"] ?? "") as! String
        title = (dict["title"] ?? "") as! String
        note = (dict["note"] ?? "") as! String
        timezone = (dict["timezone"] ?? "") as! String
        
        let startInt = (dict["start"] ?? 0) as! Int
        start = Date(timeIntervalSince1970: TimeInterval(startInt / 1000))
        
        let endInt = (dict["end"] ?? 0) as! Int
        end = Date(timeIntervalSince1970: TimeInterval(endInt / 1000))
        
        let startTimeInt = ((dict["startTime"] ?? 0) as! NSNumber).intValue
        startTime = Date(timeIntervalSince1970: TimeInterval(startTimeInt / 1000))
        
        duration = (dict["duration"] ?? 0) as! Int
        type = RepeatType(rawValue: (dict["type"] ?? 0) as! Int)!
        
        allDay = (dict["allDay"] ?? false) as! Bool
        repeatly = (dict["repeat"] ?? false) as! Bool
        monday = (dict["monday"] ?? false) as! Bool
        tuesday = (dict["tuesday"] ?? false) as! Bool
        wednesday = (dict["wednesday"] ?? false) as! Bool
        thursday = (dict["thursday"] ?? false) as! Bool
        friday = (dict["friday"] ?? false) as! Bool
        saturday = (dict["saturday"] ?? false) as! Bool
        sunday = (dict["sunday"] ?? false) as! Bool
    }
    
    
    func FDdata() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["id"] = id
        dict["businessId"] = businessId
        dict["title"] = title
        dict["note"] = note
        dict["timezone"] = timezone
        
        dict["start"] = Int(start!.timeIntervalSince1970 * 1000)
        dict["end"] = Int(end!.timeIntervalSince1970 * 1000)
        
        dict["startTime"] = Int(startTime!.timeIntervalSince1970 * 1000)
        
        dict["duration"] = duration
        dict["type"] = type.rawValue
        
        dict["allDay"] = allDay
        dict["repeat"] = repeatly
        dict["monday"] = monday
        dict["tuesday"] = tuesday
        dict["wednesday"] = wednesday
        dict["thursday"] = thursday
        dict["friday"] = friday
        dict["saturday"] = saturday
        dict["sunday"] = sunday
        
        return dict
    }
}
