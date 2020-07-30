//
//  CalendarVC.swift
//  TimeSlot
//
//  Created by com on 7/21/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class CalendarVC: UIViewController {
    
    let viewModel = CalendarViewModel()
    let calendarView = CalendarCollectionView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(calendarView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let titleView = navigationController?.navTitleWithImageAndText(titleText: "Calendar")
        tabBarController?.navigationItem.titleView = titleView
        
        calendarView.frame = view.bounds
        
        guard let man = Backend.shared().user else { return }
        
        if man.type == UserType.coach.rawValue {
            viewModel.getEventsOfCoach(id: man.uid)
            
        } else {
            viewModel.getEvents(id: man.uid)
        }
        
        setupCalendarView()
    }
    
    private func setupCalendarView() {
        calendarView.baseDelegate = self
        
        calendarView.setupCalendar(numOfDays: 3,
                                   setDate: Date(),
                                   allEvents: viewModel.events,
                                   scrollType: .pageScroll,
                                   scrollableRange: (nil, nil))

        // LongPress delegate, datasorce and type setup
        calendarView.longPressDelegate = self
        calendarView.longPressDataSource = self
        calendarView.longPressTypes = [.addNew, .move]

        // Optional
        calendarView.addNewDurationMins = 120
        calendarView.moveTimeMinInterval = 15
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: -
extension CalendarVC: JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        
    }
    
}


// MARK: -
extension CalendarVC: JZLongPressViewDelegate, JZLongPressViewDataSource {
    func weekView(_ weekView: JZLongPressWeekView, viewForAddNewLongPressAt startDate: Date) -> UIView {
        return UIView()
    }
    
}
