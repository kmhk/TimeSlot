//
//  ListDetailClientCell.swift
//  TimeSlot
//
//  Created by com on 7/29/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import SDWebImage

class ListDetailClientCell: UITableViewCell {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var btnCall: UIButton!

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
        
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }

    func showInfo(_ data: Any) {
        if let item = data as? FDPrivateSubmission {
            guard let owner = Backend.getBusiness(item.businessId) else { return }
            //guard let user = Backend.getUser(item.userId) else { return }
            //guard let contract = Backend.findPrivateContract(item.contractId) else { return }
            
            lblName.text = owner.username
            lblRole.text = owner.service.uppercased() + " COACH"
            
            imgAvatar.sd_setImage(with: URL(string: owner.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            imgAvatar.layer.cornerRadius = imgAvatar.frame.width / 2
            imgAvatar.clipsToBounds = true
            
        } else if let item = data as? FDGroupSubmission {
            guard let owner = Backend.getBusiness(item.businessId) else { return }
            //guard let user = Backend.getUser(item.userId) else { return }
            //guard let contract = Backend.findGroupContract(item.contractId) else { return }
            
            lblName.text = owner.username
            lblRole.text = owner.service.uppercased() + " COACH"
            
            imgAvatar.sd_setImage(with: URL(string: owner.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            imgAvatar.layer.cornerRadius = imgAvatar.frame.width / 2
            imgAvatar.clipsToBounds = true
        }
    }

}
