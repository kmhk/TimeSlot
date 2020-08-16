//
//  GroupSubmission.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

enum ConfirmStat: String {
    case noMember = "not_member"
    case ok = "confirmed"
    case pending = "pending"
}

class FDGroupSubmission: NSObject {
    var id: String = ""
    var businessId: String = ""
    var contractId: String = ""
    var start: Date?
    var end: Date?
    var users = [String]()
    var confirmedMap = [String: Bool]()
    
    
    init(_ dict:[String: Any]) {
        super.init()
        
        id = (dict["id"] ?? "") as! String
        businessId = (dict["businessId"] ?? "") as! String
        contractId = (dict["contractId"] ?? "") as! String
        
        let startInt = (dict["start"] ?? 0) as! Int
        start = Date(timeIntervalSince1970: TimeInterval(startInt / 1000))
        
        let endInt = (dict["end"] ?? 0) as! Int
        end = Date(timeIntervalSince1970: TimeInterval(endInt / 1000))
        
        confirmedMap = (dict["confirmedMap"] ?? [:]) as! [String: Bool]
        
        if let items = dict["users"] {
            users = Array((items as! [String: String]).values)
        }
    }
    
    
    func FDdata() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["id"] = id
        dict["businessId"] = businessId
        dict["contractId"] = contractId
        dict["start"] = Int(start!.timeIntervalSince1970 * 1000)
        dict["end"] = Int(end!.timeIntervalSince1970 * 1000)
        dict["confirmedMap"] = confirmedMap
        
        var subDict = [String: String]()
        for item in users {
            subDict[item] = item
        }
        dict["users"] = subDict
        
        return dict
    }
    
    
    func getConfirmed(_ uid: String) -> Bool {
        if let val = confirmedMap[uid], val == true {
            return true
        }
        
        return false
    }
    
    
    func getConfirmedCount() -> Int {
        var result: Int = 0
        
        for (_, value) in confirmedMap {
            if value == true {
                result += 1
            }
        }
        
        return result
    }
    
    
    func getPendingCount() -> Int {
        var result: Int = 0
        
        for (_, value) in confirmedMap {
            if value == false {
                result += 1
            }
        }
        
        return result
    }
    
    
    func isAllConfirmed() -> Bool {
        return ((getConfirmedCount() > 0) && (getConfirmedCount() == users.count))
    }
    
    
    func getConfirmedStatus(_ uid: String) -> ConfirmStat {
        guard users.firstIndex(of: uid) != nil else { return .noMember }
        
        if let val = confirmedMap[uid], val == true {
            return .ok
        }
        
        return .pending
    }
    
}
