//
//  ListViewModel.swift
//  TimeSlot
//
//  Created by com on 7/22/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class ListViewModel: NSObject {
    var contracts = [Any]()
    
    func getContracts(id: String) {
        var list = [Any]()
        
        for item in Backend.shared().privateSubmissions {
            if item.userId == id {
                list.append(item)
            }
        }
        
        for item in Backend.shared().groupSubmissions {
            if item.users.contains(id) == true {
                list.append(item)
            }
        }
        
        contracts = list
    }
    
    
    func getContractsOfCoach(id: String) {
        var list = [Any]()
        
        for item in Backend.shared().privateSubmissions {
            if item.businessId == id {
                list.append(item)
            }
        }
        
        for item in Backend.shared().groupSubmissions {
            if item.businessId == id {
                list.append(item)
            }
        }
        
        contracts = list
    }
}
