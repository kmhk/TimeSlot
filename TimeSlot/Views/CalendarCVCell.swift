//
//  CalendarCVCell.swift
//  TimeSlot
//
//  Created by com on 7/28/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class CalendarCVCell: JZLongPressEventCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = UIColor(hex: "#EEF7FF")
    }
    
    func setupBasic() {
        self.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0
        locationLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        //borderView.backgroundColor = UIColor(hex: 0x0899FF)
    }

    func configureCell(event: AllDayEvent, isAllDay: Bool = false) {
        self.event = event
        locationLabel.text = event.location
        titleLabel.text = event.title
        
        if event.location.contains("Pending") {
            contentView.backgroundColor = UIColor.systemBlue
        } else if event.location.contains("Unknown") {
            contentView.backgroundColor = UIColor.tsRedDark
        } else {
            contentView.backgroundColor = UIColor.tsAccentLight
        }

        locationLabel.isHidden = isAllDay
    }

}
