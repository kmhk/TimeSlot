//
//  HomeViewModel.swift
//  TimeSlot
//
//  Created by com on 7/22/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    var myContracts = [Any]()
    
    func getMyContracts() {
        var list = [Any]()
        
        for item in Backend.shared().privateContracts {
            if item.businessId == Backend.shared().user!.uid {
                list.append(item)
            }
        }
        
        for item in Backend.shared().groupContracts {
            if item.businessId == Backend.shared().user!.uid {
                list.append(item)
            }
        }
        
        myContracts = list
    }
    
    
    func getContractsOfMyCoach() {
        var list = [Any]()
        
        for item in Backend.shared().privateContracts {
            if let coach = getBusiness(item.businessId), coach.followers.contains(Backend.shared().user!.uid) == true {
                list.append(item)
            }
        }
        
        for item in Backend.shared().groupContracts {
            if let coach = getBusiness(item.businessId), coach.followers.contains(Backend.shared().user!.uid) == true {
                list.append(item)
            }
        }
        
        myContracts = list
    }
    
    
    func getBusiness(_ id: String) -> FDBusiness? {
        for item in Backend.shared().businesses {
            if item.uid == id {
                return item
            }
        }
        
        return nil
    }
    
}
