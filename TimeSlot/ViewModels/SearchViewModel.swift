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
    
    
    func addFollowerTo(coachID: String, personID: String, finished: FDFinishedHandler!) {
        for i in 0..<Backend.shared().businesses.count {
            if Backend.shared().businesses[i].uid == coachID {
                if !Backend.shared().businesses[i].followers.contains(personID) {
                    Backend.shared().businesses[i].followers.append(personID)
                }

                if Backend.shared().businesses[i].pendingIDs.contains(personID) {
                    Backend.shared().businesses[i].pendingIDs.removeAll {$0 == personID}
                }

                if Backend.shared().businesses[i].uid == Backend.shared().business!.uid {
                    Backend.shared().business = Backend.shared().businesses[i]
                }

                Backend.saveBusiness(business: Backend.shared().businesses[i], finished: finished)
                return
            }
        }
        
        finished(nil)
    }
    
    
    func requestFollowerTo(coachID: String, personID: String, finished: FDFinishedHandler!) {
        for i in 0..<Backend.shared().businesses.count {
            if Backend.shared().businesses[i].uid == coachID {
                if !Backend.shared().businesses[i].pendingIDs.contains(personID) {
                    Backend.shared().businesses[i].pendingIDs.append(personID)
                }
                
                Backend.saveBusiness(business: Backend.shared().businesses[i], finished: finished)
                return
            }
        }
        
        finished(nil)
    }
    
    
    func cancelRequestFollowFrom(coachID: String, personID: String, finished: FDFinishedHandler!) {
        for i in 0..<Backend.shared().businesses.count {
            if Backend.shared().businesses[i].uid == coachID {
                if Backend.shared().businesses[i].followers.contains(personID) {
                    Backend.shared().businesses[i].followers.removeAll {$0 == personID}
                }
                
                if Backend.shared().businesses[i].pendingIDs.contains(personID) {
                    Backend.shared().businesses[i].pendingIDs.removeAll {$0 == personID}
                }
                
                Backend.saveBusiness(business: Backend.shared().businesses[i], finished: finished)
                return
            }
        }
        
        finished(nil)
    }
}
