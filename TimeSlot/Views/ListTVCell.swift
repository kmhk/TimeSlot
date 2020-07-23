//
//  ListTVCell.swift
//  TimeSlot
//
//  Created by com on 7/22/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class ListTVCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblContractType: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgViewAvatar: UIImageView!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var imgViewUser: UIImageView!
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lblDate.layer.cornerRadius = 5
        lblDate.layer.borderColor = UIColor.tsMainBlue!.cgColor
        lblDate.layer.borderWidth = 1
        lblDate.clipsToBounds = true
        
        imgViewAvatar.layer.cornerRadius = imgViewAvatar.frame.width / 2
        imgViewAvatar.layer.borderWidth = 1
        imgViewAvatar.layer.borderColor = UIColor.tsMainBlue!.cgColor
        imgViewAvatar.clipsToBounds = true
        
        imgViewUser.layer.cornerRadius = imgViewAvatar.frame.width / 2
        imgViewUser.layer.borderWidth = 1
        imgViewUser.layer.borderColor = UIColor.tsMainBlue!.cgColor
        imgViewUser.clipsToBounds = true
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        layer.addSublayer(bottomBorder)
    }
    
    
    func showInfo(_ data: Any) {
        if let item = data as? FDPrivateSubmission {
            guard let owner = Backend.getBusiness(item.businessId) else { return }
            guard let user = Backend.getUser(item.userId) else { return }
            
            let formater = DateFormatter()
            formater.dateFormat = "dd\nE"
            lblDate.text = formater.string(from: item.start!)
            
            formater.dateFormat = "HH:mm"
            lblTime.text = formater.string(from: item.start!) + " - " + formater.string(from: item.end!)
            
            lblContractType.text = "Private Lesson"
            lblStatus.text = (item.confirmed == true ? "Confirmed" : "Pending")
            lblStatus.textColor = (item.confirmed == true ? UIColor.green : UIColor.tsAccent)
            
            lblLocation.text = owner.location
            imgViewAvatar.sd_setImage(with: URL(fileURLWithPath: owner.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            lblOwner.text = owner.username
            
            imgViewUser.sd_setImage(with: URL(fileURLWithPath: user.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            
        } else if let item = data as? FDGroupSubmission {
            guard let owner = Backend.getBusiness(item.businessId) else { return }
            guard let user = Backend.getUser(item.users.first!) else { return }
            
            let formater = DateFormatter()
            formater.dateFormat = "dd\nE"
            lblDate.text = formater.string(from: item.start!)
            
            formater.dateFormat = "HH:mm"
            lblTime.text = formater.string(from: item.start!) + " - " + formater.string(from: item.end!)
            
            lblContractType.text = "Group Lesson"
            if let confirmed = item.confirmedMap[user.uid], confirmed == true {
                lblStatus.text = "Confirmed"
                lblStatus.textColor = UIColor.green
            } else {
                lblStatus.text = "Pending"
                lblStatus.textColor = UIColor.tsAccent
            }
            
            lblLocation.text = owner.location
            imgViewAvatar.sd_setImage(with: URL(fileURLWithPath: owner.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            lblOwner.text = owner.username
            
            imgViewUser.sd_setImage(with: URL(fileURLWithPath: user.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
        }
    }

}
