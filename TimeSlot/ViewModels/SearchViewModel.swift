//
//  SearchViewModel.swift
//  TimeSlot
//
//  Created by com on 7/22/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {
    var users = [Any]()
    
    func getCoaches() {
        users = Backend.shared().businesses
    }
    
    
    func getFollowingUsers(id: String) {
        var list = [Any]()
        guard let coach = Backend.getBusiness(id) else { users = list; return }
        
        for userID in coach.followers {
            if let user = Backend.getUser(userID) {
                list.append(user)
            }
        }
        
        for userID in coach.pendingIDs {
            if let user = Backend.getUser(userID) {
                list.append(user)
            }
        }
        
        users = list
    }
}
