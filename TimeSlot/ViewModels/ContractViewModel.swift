//
//  ContractViewModel.swift
//  TimeSlot
//
//  Created by com on 7/30/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class ContractViewModel: NSObject {
    var events = [Date: [AllDayEvent]]()
    
    func getEventsOfCoach(id: String) {
        var list = [AllDayEvent]()
        
        for item in Backend.shared().groupSubmissions {
            if item.businessId == id, let contract = Backend.findGroupContract(item.contractId) {
                let event = AllDayEvent(id: item.contractId,
                                        title: contract.title,
                                        startDate: item.start!,
                                        endDate: item.end!,
                                        location: "",
                                        isAllDay: false)
                list.append(event)
            }
        }
        
        for item in Backend.shared().privateSubmissions {
            if item.businessId == id, let contract = Backend.findPrivateContract(item.contractId) {
                let event = AllDayEvent(id: item.contractId,
                                        title: contract.title,
                                        startDate: item.start!,
                                        endDate: item.end!,
                                        location: "",
                                        isAllDay: false)
                list.append(event)
            }
        }
        
        events = JZWeekViewHelper.getIntraEventsByDate(originalEvents: list)
    }
    
    
    func getEvents(id: String) {
        var list = [AllDayEvent]()
        
        for item in Backend.shared().groupSubmissions {
            if item.users.contains(id) == true, let contract = Backend.findGroupContract(item.contractId), let owner = Backend.getBusiness(item.businessId) {
                let event = AllDayEvent(id: item.contractId,
                                        title: contract.title,
                                        startDate: item.start!,
                                        endDate: item.end!,
                                        location: "with: Coach \(owner.username)",
                                        isAllDay: false)
                
                if item.getConfirmedStatus(id) != .ok {
                    event.location = "Pending"
                }
                
                list.append(event)
            }
        }
        
        for item in Backend.shared().privateSubmissions {
            if item.userId == id, let contract = Backend.findPrivateContract(item.contractId), let owner = Backend.getBusiness(item.businessId) {
                let event = AllDayEvent(id: item.contractId,
                                        title: contract.title,
                                        startDate: item.start!,
                                        endDate: item.end!,
                                        location: "with: Coach \(owner.username)",
                                        isAllDay: false)
                if item.confirmed != true {
                    event.location = "Pending"
                }
                list.append(event)
            }
        }
        
        events = JZWeekViewHelper.getIntraEventsByDate(originalEvents: list)
    }
    
    
    func addNewEvent(_ id: String, newEvent: AllDayEvent) {
        var list = [AllDayEvent]()
        
        for item in Backend.shared().groupSubmissions {
            if item.users.contains(id) == true, let contract = Backend.findGroupContract(item.contractId), let owner = Backend.getBusiness(item.businessId) {
                let event = AllDayEvent(id: item.contractId,
                                        title: contract.title,
                                        startDate: item.start!,
                                        endDate: item.end!,
                                        location: "with: Coach \(owner.username)",
                                        isAllDay: false)
                
                if item.getConfirmedStatus(id) != .ok {
                    event.location = "Pending"
                }
                
                list.append(event)
            }
        }
        
        for item in Backend.shared().privateSubmissions {
            if item.userId == id, let contract = Backend.findPrivateContract(item.contractId), let owner = Backend.getBusiness(item.businessId) {
                let event = AllDayEvent(id: item.contractId,
                                        title: contract.title,
                                        startDate: item.start!,
                                        endDate: item.end!,
                                        location: "with: Coach \(owner.username)",
                                        isAllDay: false)
                if item.confirmed != true {
                    event.location = "Pending"
                }
                list.append(event)
            }
        }
        
        list.append(newEvent)
        events = JZWeekViewHelper.getIntraEventsByDate(originalEvents: list)
    }
    
    
    func submitSubmission(_ data: Any, finished: FDFinishedHandler!) {
        if let submission = data as? FDPrivateSubmission {
            Backend.submitPrivateSubmission(submission: submission, finished: finished)
            
        } else if let submission = data as? FDGroupSubmission {
            Backend.submitGroupSubmission(submission: submission, finished: finished)
        }
    }
}
