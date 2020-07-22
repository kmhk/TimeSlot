//
//  PrivateSubmission.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class FDPrivateSubmission: NSObject {
    var id: String = ""
    var businessId: String = ""
    var contractId: String = ""
    var start: Date?
    var end: Date?
    var userId: String = ""
    var confirmed: Bool = false
    
    
    init(_ dict:[String: Any]) {
        super.init()
        
        id = (dict["id"] ?? "") as! String
        businessId = (dict["businessId"] ?? "") as! String
        contractId = (dict["contractId"] ?? "") as! String
        
        let startInt = (dict["start"] ?? 0) as! Int
        start = Date(timeIntervalSince1970: TimeInterval(startInt / 1000))
        
        let endInt = (dict["end"] ?? 0) as! Int
        end = Date(timeIntervalSince1970: TimeInterval(endInt / 1000))
        
        userId = (dict["userId"] ?? "") as! String
        confirmed = (dict["confirmed"] ?? false) as! Bool
    }
    
    
    func FDdata() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["id"] = id
        dict["businessId"] = businessId
        dict["contractId"] = contractId
        dict["start"] = start!.timeIntervalSince1970 * 1000
        dict["end"] = end!.timeIntervalSince1970 * 1000
        dict["userId"] = userId
        dict["confirmed"] = confirmed
        
        return dict
    }
}
