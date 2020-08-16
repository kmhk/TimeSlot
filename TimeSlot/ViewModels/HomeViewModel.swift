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
    var mySubs = [Any]()
    
    func getContracts(id: String) {
        var list = [Any]()
        
        for item in Backend.shared().privateContracts {
            if item.businessId == id {
                list.append(item)
            }
        }
        
        for item in Backend.shared().groupContracts {
            if item.businessId == id {
                list.append(item)
            }
        }
        
        myContracts = list
    }
    
    
    func getContractsOfCoach(id: String) {
        var list = [Any]()
        
        for item in Backend.shared().privateContracts {
            if let coach = Backend.getBusiness(item.businessId), coach.followers.contains(id) == true {
                list.append(item)
            }
        }
        
        for item in Backend.shared().groupContracts {
            if let coach = Backend.getBusiness(item.businessId), coach.followers.contains(id) == true {
                list.append(item)
            }
        }
        
        myContracts = list
    }
    
    
    func getUnavailables(id: String) {
        var list = [Any]()
        
        if Backend.shared().business!.available_mode == true {
            for item in Backend.shared().availables {
                if item.businessId == id {
                    list.append(item)
                }
            }
            
        } else {
            for item in Backend.shared().unavailables {
                if item.businessId == id {
                    list.append(item)
                }
            }
        }
        
        mySubs = list
    }
    
    
    func getChildrens(id: String) {
        var list = [Any]()
        
        for item in Backend.shared().childs {
            if item.parent == id {
                list.append(item)
            }
        }
        
        mySubs = list
    }
    
    
    func removeChildren(child: FDChild, finished: FDFinishedHandler!) {
        Backend.removeChild(child: child) { (error) in
            if error == nil {
                self.mySubs.removeAll {($0 as! FDChild).uid == child.uid}
            }
            
            finished(error)
        }
    }
    
}
