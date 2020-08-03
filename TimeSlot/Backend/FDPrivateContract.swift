//
//  FDPrivateContract.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class FDPrivateContract: NSObject {
    var id: String = ""
    var title: String = ""
    var iconUri: String = ""
    var videoUri: String = ""
    var descript: String = ""
    var businessId : String = ""
    var hourlyRate: Double = 0
    var length: Int = 0
    
    init(_ dict:[String: Any]) {
        super.init()
        
        id = (dict["id"] ?? "") as! String
        title = (dict["contractId"] ?? "") as! String
        videoUri = (dict["videoUri"] ?? "") as! String
        iconUri = (dict["userId"] ?? "") as! String
        descript = (dict["description"] ?? "") as! String
        businessId = (dict["businessId"] ?? "") as! String
        length = (dict["length"] ?? 0) as! Int
        hourlyRate = (dict["hourlyRate"] ?? 0.0) as! Double
    }
    
    func FDdata() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["id"] = id
        dict["contractId"] = title
        dict["videoUri"] = videoUri
        dict["userId"] = iconUri
        dict["description"] = descript
        dict["businessId"] = businessId
        dict["length"] = length
        dict["hourlyRate"] = hourlyRate
        
        return dict
    }
}
