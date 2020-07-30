//
//  CalendarViewModel.swift
//  TimeSlot
//
//  Created by com on 7/27/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import JZCalendarWeekView

// MARK: -
class AllDayEvent: JZAllDayEvent {

    var location: String
    var title: String
    
    init(id: String, title: String, startDate: Date, endDate: Date, location: String, isAllDay: Bool) {
        self.location = location
        self.title = title

        // If you want to have you custom uid, you can set the parent class's id with your uid or UUID().uuidString (In this case, we just use the base class id)
        super.init(id: id, startDate: startDate, endDate: endDate, isAllDay: isAllDay)
    }

    override func copy(with zone: NSZone?) -> Any {
        return AllDayEvent(id: id, title: title, startDate: startDate, endDate: endDate, location: location, isAllDay: isAllDay)
    }
}


// MARK: -
class CalendarViewModel: NSObject {
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
}
