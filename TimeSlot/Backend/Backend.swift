//
//  Backend.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


typealias FDFinishedHandler = (Error?) -> ()

enum UserType: String {
    case personal = "personal"
    case coach = "coach"
    case child = "child"
}


// MARK: -
@objc protocol BackendDelegate: AnyObject {
    @objc optional func finishedLoadUser()
    @objc optional func finishedBusiness()
    @objc optional func finishedLoadSchedule()
    @objc optional func finishedSubmission()
    @objc optional func finishedContract()
    @objc optional func finishedUnavailable()
}


// MARK: -
var backendObj = Backend()

class Backend: NSObject {
    static let adultRef = Database.database().reference(withPath: "adult")
    static let providerRef = Database.database().reference(withPath: "business")
    static let childRef = Database.database().reference(withPath: "child")
    static let groupContractRef = Database.database().reference(withPath: "groupContract")
    static let groupSubmissionRef = Database.database().reference(withPath: "groupSubmission")
    static let privateContractRef = Database.database().reference(withPath: "privateContract")
    static let privateSubmissionRef = Database.database().reference(withPath: "privateSubmission")
    static let unavilableRef = Database.database().reference(withPath: "unavailable")
    static let scheduleRef = Database.database().reference(withPath: "schedule")
    static let userRef = Database.database().reference(withPath: "user")
    
    var user: FDUser?
    var business: FDBusiness?
    var personal: FDPersonal?
    var users = [FDUser]()
    var personals = [FDPersonal]()
    var businesses = [FDBusiness]()
    var childs = [FDChild]()
    var schedules = [FDSchedule]()
    var privateContracts = [FDPrivateContract]()
    var privateSubmissions = [FDPrivateSubmission]()
    var groupContracts = [FDGroupContract]()
    var groupSubmissions = [FDGroupSubmission]()
    var unavailables = [FDUnavailable]()
    
    var delegate: BackendDelegate?
    
    
    static func shared() -> Backend {
        return backendObj
    }
    
    
    static func loginUser(email: String, pwd: String, finished: FDFinishedHandler!) {
        Auth.auth().signIn(withEmail: email, password: pwd) { (auth, error) in
            guard error == nil else { finished(error); return }
            guard let auth = auth else { finished(NSError(domain: "", code: 0xFF, userInfo: nil)); return }
            
            loadUser(id: auth.user.uid, finished: finished)
        }
    }
    
    
    static func loadUser(id: String, finished: FDFinishedHandler!) {
        userRef.child(id).observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value else { finished(NSError(domain: "", code: 0xFF, userInfo: nil)); return }
            
            shared().user = FDUser(value as! [String: Any])
            
            if let delegate = shared().delegate {
                delegate.finishedLoadUser?()
            }
            
            loadAllData(finished: finished)
        }
    }
    
    
    static func loadAllData(finished: FDFinishedHandler!) {
        loadBusinesses { (error) in
            guard error == nil else { finished(error); return }
            loadPersonals { (error) in
                guard error == nil else { finished(error); return }
                loadChilds { (error) in
                    guard error == nil else { finished(error); return }
                    loadUsers { (error) in
                        guard error == nil else { finished(error); return }
                        loadSchedules { (error) in
                            guard error == nil else { finished(error); return }
                            loadPrivateContract { (error) in
                                guard error == nil else { finished(error); return }
                                loadPrivateSubmission { (error) in
                                    guard error == nil else { finished(error); return }
                                    loadGroupContract { (error) in
                                        guard error == nil else { finished(error); return }
                                        loadGroupSubmission { (error) in
                                            guard error == nil else { finished(error); return }
                                            loadUnavailable { (error) in
                                                guard error == nil else { finished(error); return }
                                                finished(nil)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    static func loadPersonals(finished: FDFinishedHandler!) {
        adultRef.observeSingleEvent(of: .value) { (snap) in
            var list = [FDPersonal]()
            for item in snap.children {
                if let val = (item as! DataSnapshot).value {
                    let personal = FDPersonal(val as! [String: Any])
                    list.append(personal)
                    
                    if personal.uid == shared().user?.uid {
                        shared().personal = personal
                    }
                }
            }
            shared().personals = list
            finished(nil)
        }
    }
    
    
    static func loadBusinesses(finished: FDFinishedHandler!) {
        providerRef.observeSingleEvent(of: .value) { (snap) in
            var list = [FDBusiness]()
            for item in snap.children {
                if let val = (item as! DataSnapshot).value {
                    let business = FDBusiness(val as! [String: Any])
                    list.append(business)
                    
                    if business.uid == shared().user?.uid {
                        shared().business = business
                    }
                }
            }
            shared().businesses = list
            
            if let delegate = shared().delegate {
                delegate.finishedBusiness?()
            }
            
            finished(nil)
        }
    }
    
    
    static func getBusiness(_ id: String) -> FDBusiness? {
        for item in shared().businesses {
            if item.uid == id {
                return item
            }
        }
        
        return nil
    }
    
    
    static func loadChilds(finished: FDFinishedHandler!) {
        childRef.observeSingleEvent(of: .value) { (snap) in
            var childs = [FDChild]()
            for item in snap.children {
                if let val = (item as! DataSnapshot).value {
                    let child = FDChild(val as! [String: Any])
                    childs.append(child)
                }
            }
            shared().childs = childs
            finished(nil)
        }
    }
    
    
    static func loadUsers(finished: FDFinishedHandler!) {
        userRef.observeSingleEvent(of: .value) { (snap) in
            var users = [FDUser]()
            for item in snap.children {
                if let val = (item as! DataSnapshot).value {
                    let user = FDUser(val as! [String: Any])
                    users.append(user)
                }
            }
            shared().users = users
            finished(nil)
        }
    }
    
    
    static func getUser(_ id: String) -> FDPersonal? {
        for item in shared().personals {
            if item.uid == id {
                return item
            }
        }
        
        return nil
    }
    
    
    static func loadSchedules(finished: FDFinishedHandler!) {
        scheduleRef.observeSingleEvent(of: .value) { (snap) in
            var list = [FDSchedule]()
            for item in snap.children {
                if let val = (item as! DataSnapshot).value {
                    let data = FDSchedule(val as! [String: Any])
                    list.append(data)
                }
            }
            shared().schedules = list
            
            if let delegate = shared().delegate {
                delegate.finishedLoadSchedule?()
            }
            
            finished(nil)
        }
    }
    
    
    static func loadPrivateContract(finished: FDFinishedHandler!) {
        privateContractRef.observeSingleEvent(of: .value) { (snap) in
            var list = [FDPrivateContract]()
            for item in snap.children {
                if let val = (item as! DataSnapshot).value {
                    let data = FDPrivateContract(val as! [String: Any])
                    list.append(data)
                }
            }
            shared().privateContracts = list
            finished(nil)
        }
    }
    
    
    static func loadGroupContract(finished: FDFinishedHandler!) {
        groupContractRef.observeSingleEvent(of: .value) { (snap) in
            var list = [FDGroupContract]()
            for item in snap.children {
                if let val = (item as! DataSnapshot).value {
                    let data = FDGroupContract(val as! [String: Any])
                    list.append(data)
                }
            }
            shared().groupContracts = list
            
            if let delegate = shared().delegate {
                delegate.finishedContract?()
            }
            
            finished(nil)
        }
    }
    
    
    static func loadPrivateSubmission(finished: FDFinishedHandler!) {
        privateSubmissionRef.observeSingleEvent(of: .value) { (snap) in
            var list = [FDPrivateSubmission]()
            for item in snap.children {
                if let val = (item as! DataSnapshot).value {
                    let data = FDPrivateSubmission(val as! [String: Any])
                    list.append(data)
                }
            }
            shared().privateSubmissions = list
            finished(nil)
        }
    }
    
    
    static func loadGroupSubmission(finished: FDFinishedHandler!) {
        groupSubmissionRef.observeSingleEvent(of: .value) { (snap) in
            var list = [FDGroupSubmission]()
            for item in snap.children {
                if let val = (item as! DataSnapshot).value {
                    let data = FDGroupSubmission(val as! [String: Any])
                    list.append(data)
                }
            }
            shared().groupSubmissions = list
            
            if let delegate = shared().delegate {
                delegate.finishedSubmission?()
            }
            
            finished(nil)
        }
    }
    
    
    static func loadUnavailable(finished: FDFinishedHandler!) {
        unavilableRef.observeSingleEvent(of: .value) { (snap) in
            var list = [FDUnavailable]()
            for item in snap.children {
                if let val = (item as! DataSnapshot).value {
                    let data = FDUnavailable(val as! [String: Any])
                    list.append(data)
                }
            }
            shared().unavailables = list
            
            if let delegate = shared().delegate {
                delegate.finishedUnavailable?()
            }
            
            finished(nil)
        }
    }
    
}
