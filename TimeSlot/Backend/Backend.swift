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
import FirebaseStorage


typealias FDFinishedHandler = (Error?) -> ()
typealias FDUploadedHandler = (Error?, URL?) -> ()

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
    static let avilableRef = Database.database().reference(withPath: "available")
    static let scheduleRef = Database.database().reference(withPath: "schedule")
    static let userRef = Database.database().reference(withPath: "user")
    
    static var profileImageRef = Storage.storage().reference().child("image").child("user")
    
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
    var availables = [FDAvailable]()
    
    var delegate: BackendDelegate?
    
    
    static func shared() -> Backend {
        return backendObj
    }
    
    
    static func uploadProfileImage(_ id: String, image: UIImage, finished: FDUploadedHandler!) {
        let imgData = image.jpegData(compressionQuality: 1.0)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let dbRef = profileImageRef.child(id + ".jpg")
        dbRef.putData(imgData!, metadata: metaData, completion: { (meta, error) in
            if let error = error {
                print("Profile image uploading error: \(error.localizedDescription)")
                finished(error, nil)
                return
            }
            
            dbRef.downloadURL(completion: { (url, error) in
                finished(error, url)
            })
        })
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
                                                loadAvailable { (error) in
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
    }
    
    
    static func updatePersonal(user: FDPersonal, finished: FDFinishedHandler!) {
        adultRef.child(user.uid).setValue(user.FDdata()) { (error, ref) in
            finished(error)
        }
    }
    
    
    static func submitPersonal(user: FDPersonal, finished: FDFinishedHandler!) {
        adultRef.child(user.uid).setValue(user.FDdata()) { (error, ref) in
            if error == nil {
                shared().personals.append(user)
            }
            
            finished(error)
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
    
    
    static func updateBusiness(user: FDBusiness, finished: FDFinishedHandler!) {
        providerRef.child(user.uid).setValue(user.FDdata()) { (error, ref) in
            finished(error)
        }
    }
    
    
    static func submitBusiness(user: FDBusiness, finished: FDFinishedHandler!) {
        providerRef.child(user.uid).setValue(user.FDdata()) { (error, ref) in
            if error == nil {
                shared().businesses.append(user)
            }
            
            finished(error)
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
    
    
    static func saveBusiness(business: FDBusiness, finished: FDFinishedHandler!) {
        providerRef.child(business.uid).setValue(business.FDdata()) { (error, ref) in
            finished(error)
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
    
    
    static func addChild(name: String, birth: Date, finished: FDFinishedHandler!) {
        guard let uid = childRef.childByAutoId().key else { finished(nil); return }
        let child = FDChild(uid)
        child.username = name
        child.parent = shared().personal!.uid
        child.birthDay = birth
        
        shared().personal!.childIds.append(uid)
        
        childRef.child(uid).setValue(child.FDdata()) { (error, ref) in
            guard error == nil else {
                finished(error)
                return
            }
            
            adultRef.child(shared().personal!.uid).setValue(shared().personal!.FDdata()) { (error, ref) in
                shared().childs.append(child)
                finished(error)
            }
        }
    }
    
    
    static func removeChild(child: FDChild, finished: FDFinishedHandler!) {
        shared().personal!.childIds.removeAll {$0 == child.uid}
        
        adultRef.child(shared().personal!.uid).setValue(shared().personal!.FDdata()) { (error, ref) in
            if error != nil {
                finished(error)
                return
            }
            
            childRef.child(child.uid).setValue(nil) { (error, ref) in
                shared().childs.removeAll {$0.uid == child.uid}
                finished(error)
            }
        }
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
    
    
    static func getChild(_ id: String) -> FDChild? {
        for item in shared().childs {
            if item.uid == id {
                return item
            }
        }
        
        return nil
    }
    
    
    static func submitUser(user: FDUser, pwd: String, finished: FDFinishedHandler!) {
        Auth.auth().createUser(withEmail: user.email, password: pwd) { (auth, error) in
            guard error == nil, auth != nil else { finished(error); return }
            
            user.uid = auth!.user.uid
            userRef.child(user.uid).setValue(user.FDdata()) { (error, ref) in
                if error == nil {
                    shared().users.append(user)
                }
                
                finished(error)
            }
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
    
    
    static func findPrivateContract(_ id: String) -> FDPrivateContract? {
        for item in shared().privateContracts {
            if item.id == id {
                return item
            }
        }
        
        return nil
    }
    
    
    static func submitPrivateContract(contract: FDPrivateContract, finished: FDFinishedHandler!) {
        guard let uid = privateContractRef.childByAutoId().key else { finished(nil); return }
        contract.id = uid
        privateContractRef.child(uid).setValue(contract.FDdata()) { (error, ref) in
            if error == nil {
                shared().privateContracts.append(contract)
            }
            finished(error)
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
    
    
    static func findGroupContract(_ id: String) -> FDGroupContract? {
        for item in shared().groupContracts {
            if item.id == id {
                return item
            }
        }
        
        return nil
    }
    
    
    static func submitGroupContract(contract: FDGroupContract, finished: FDFinishedHandler!) {
        guard let uid = groupContractRef.childByAutoId().key else { finished(nil); return }
        contract.id = uid
        groupContractRef.child(uid).setValue(contract.FDdata()) { (error, ref) in
            if error == nil {
                shared().groupContracts.append(contract)
            }
            finished(error)
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
    
    
    static func submitPrivateSubmission(submission: FDPrivateSubmission, finished: FDFinishedHandler!) {
        guard let uid = privateSubmissionRef.childByAutoId().key else { finished(nil); return }
        submission.id = uid
        privateSubmissionRef.child(uid).setValue(submission.FDdata()) { (error, ref) in
            if error == nil {
                shared().privateSubmissions.append(submission)
            }
            
            finished(error)
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
    
    
    static func getPersonIDofGroupSubmission(groupSubmission: FDGroupSubmission, person: FDPersonal) -> String? {
        guard groupSubmission.users.contains(person.uid) == false else { return person.uid }
        
        for item in person.childIds {
            if groupSubmission.users.contains(item) {
                return item
            }
        }
        
        return nil
    }
    
    
    static func submitGroupSubmission(submission: FDGroupSubmission, finished: FDFinishedHandler!) {
        guard let uid = groupSubmissionRef.childByAutoId().key else { finished(nil); return }
        submission.id = uid
        groupSubmissionRef.child(uid).setValue(submission.FDdata()) { (error, ref) in
            if error == nil {
                shared().groupSubmissions.append(submission)
            }
            
            finished(error)
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
    
    
    static func submitUnavailable(_ submission: FDUnavailable, finished: FDFinishedHandler!) {
        guard let uid = unavilableRef.childByAutoId().key else { finished(nil); return }
        submission.id = uid
        unavilableRef.child(uid).setValue(submission.FDdata()) { (error, ref) in
            if error == nil {
                shared().unavailables.append(submission)
            }
            
            finished(error)
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
    
    
    static func submitAvailable(_ submission: FDAvailable, finished: FDFinishedHandler!) {
        guard let uid = avilableRef.childByAutoId().key else { finished(nil); return }
        submission.id = uid
        avilableRef.child(uid).setValue(submission.FDdata()) { (error, ref) in
            if error == nil {
                shared().availables.append(submission)
            }
            
            finished(error)
        }
    }
    
    
    static func loadAvailable(finished: FDFinishedHandler!) {
        avilableRef.observeSingleEvent(of: .value) { (snap) in
            var list = [FDAvailable]()
            for item in snap.children {
                if let val = (item as! DataSnapshot).value {
                    let data = FDAvailable(val as! [String: Any])
                    list.append(data)
                }
            }
            shared().availables = list
            
            finished(nil)
        }
    }
    
}
