//
//  UserCVCell.swift
//  TimeSlot
//
//  Created by com on 7/22/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class UserCVCell: UICollectionViewCell {
    @IBOutlet weak var imgViewAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPin: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnWaiting: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgViewAvatar.layer.cornerRadius = imgViewAvatar.frame.width / 2
        imgViewAvatar.clipsToBounds = true
        
        btnAdd.layer.cornerRadius = btnAdd.frame.width / 2
        btnAdd.layer.borderColor = btnAdd.tintColor.cgColor
        btnAdd.layer.borderWidth = 1
        btnAdd.clipsToBounds = true
        
        btnWaiting.layer.cornerRadius = btnWaiting.frame.width / 2
        btnWaiting.layer.borderColor = btnWaiting.tintColor.cgColor
        btnWaiting.layer.borderWidth = 1
        btnWaiting.clipsToBounds = true
        
        btnAccept.layer.cornerRadius = btnAccept.frame.width / 2
        btnAccept.layer.borderColor = btnAccept.tintColor.cgColor
        btnAccept.layer.borderWidth = 1
        btnAccept.clipsToBounds = true
        
        btnClose.layer.cornerRadius = btnClose.frame.width / 2
        btnClose.layer.borderColor = btnClose.tintColor.cgColor
        btnClose.layer.borderWidth = 1
        btnClose.clipsToBounds = true
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        layer.addSublayer(bottomBorder)
    }
    
    
    func showInfo(_ data: Any) {
        btnAdd.isHidden = true
        btnWaiting.isHidden = true
        btnAccept.isHidden = true
        btnClose.isHidden = true
        
        if let item = data as? FDBusiness {
            imgPin.image = UIImage(systemName: "hand.thumbsup")
            lblLocation.text = item.service
            imgViewAvatar.sd_setImage(with: URL(fileURLWithPath: item.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            lblName.text = item.username
            
            if item.followers.contains(Backend.shared().user!.uid) {
                btnClose.isHidden = false
                btnClose.frame = CGRect(x: frame.width - 40, y: 17, width: 30, height: 30)
                
            } else if item.pendingIDs.contains(Backend.shared().user!.uid) {
                btnWaiting.isHidden = false
                btnWaiting.frame = CGRect(x: frame.width - 40, y: 17, width: 30, height: 30)
                
            } else {
                btnAdd.isHidden = false
                btnAdd.frame = CGRect(x: frame.width - 40, y: 17, width: 30, height: 30)
            }
            
        } else if let item = data as? FDPersonal {
            imgPin.image = UIImage(systemName: "mappin.and.ellipse")
            lblLocation.text = item.location
            imgViewAvatar.sd_setImage(with: URL(fileURLWithPath: item.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            lblName.text = item.username
            
            let me = Backend.shared().business!
            if me.followers.contains(item.uid) {
                btnClose.isHidden = false
                btnClose.frame = CGRect(x: frame.width - 40, y: 17, width: 30, height: 30)
                
            } else if me.pendingIDs.contains(item.uid) {
                btnClose.isHidden = false
                btnClose.frame = CGRect(x: frame.width - 40, y: 17, width: 30, height: 30)
                
                btnAccept.isHidden = false
                btnAccept.frame = CGRect(x: frame.width - 80, y: 17, width: 30, height: 30)
            }
        }
    }
}
