//
//  UnavailableCVCell.swift
//  TimeSlot
//
//  Created by com on 7/22/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class UnavailableCVCell: UICollectionViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lblDate.layer.cornerRadius = 5
        lblDate.layer.borderColor = UIColor.tsMainBlue!.cgColor
        lblDate.textColor = UIColor.tsMainBlue!
        lblDate.layer.borderWidth = 1.0
        lblDate.clipsToBounds = true
        lblDate.backgroundColor = UIColor.white
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        layer.addSublayer(bottomBorder)
    }
    
    
    func showData(_ data: FDUnavailable) {
        let formater = DateFormatter()
        formater.dateFormat = "dd\nE"
        lblDate.text = formater.string(from: data.start!)
        
        formater.dateFormat = "HH:mm"
        lblTime.text = formater.string(from: data.startTime!) + " - " + formater.string(from: data.end!)
        
        lblDay.text = getDay(data)
        
        lblTitle.text = data.title
        lblNote.text = data.note
    }
    
    
    private func getDay(_ data: FDUnavailable) -> String {
        var str = ""
        
        str += (data.monday == true ? "Mon" : "")
        str += (str.count > 0 ? ", " : "")
        str += (data.tuesday == true ? "Tue" : "")
        str += (str.count > 0 ? ", " : "")
        str += (data.wednesday == true ? "Wed" : "")
        str += (str.count > 0 ? ", " : "")
        str += (data.thursday == true ? "Thr" : "")
        str += (str.count > 0 ? ", " : "")
        str += (data.friday == true ? "Fri" : "")
        str += (str.count > 0 ? ", " : "")
        str += (data.saturday == true ? "Sat" : "")
        str += (str.count > 0 ? ", " : "")
        str += (data.sunday == true ? "Sun" : "")
        
        return str
    }
}
