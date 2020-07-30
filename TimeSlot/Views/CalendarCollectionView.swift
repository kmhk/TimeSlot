//
//  CalendarCollectionView.swift
//  TimeSlot
//
//  Created by com on 7/28/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class CalendarCollectionView: JZLongPressWeekView {

    override func registerViewClasses() {
        super.registerViewClasses()

        self.collectionView.register(UINib(nibName: "CalendarCVCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCVCell")
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCVCell", for: indexPath) as? CalendarCVCell,
            let event = getCurrentEvent(with: indexPath) as? AllDayEvent {
            cell.configureCell(event: event)
            return cell
        }
        preconditionFailure("LongPressEventCell and AllDayEvent should be casted")
    }

//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == JZSupplementaryViewKinds.allDayHeader {
//            guard let alldayHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath) as? JZAllDayHeader else {
//                preconditionFailure("SupplementaryView should be JZAllDayHeader")
//            }
//            let date = flowLayout.dateForColumnHeader(at: indexPath)
//            let events = allDayEventsBySection[date]
//            let views = getAllDayHeaderViews(allDayEvents: events as? [AllDayEvent] ?? [])
//            alldayHeader.updateView(views: views)
//            return alldayHeader
//        }
//        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
//    }

    private func getAllDayHeaderViews(allDayEvents: [AllDayEvent]) -> [UIView] {
        var allDayViews = [UIView]()
        for event in allDayEvents {
            if let view = UINib(nibName: "CalendarCVCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CalendarCVCell {
                view.configureCell(event: event, isAllDay: true)
                allDayViews.append(view)
            }
        }
        return allDayViews
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedEvent = getCurrentEvent(with: indexPath) as? AllDayEvent {
            print("\(selectedEvent.title)")
        }
    }


}
