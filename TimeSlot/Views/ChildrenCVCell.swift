//
//  ChildrenCVCell.swift
//  TimeSlot
//
//  Created by com on 7/22/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import SDWebImage

class ChildrenCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imgViewAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgViewAvatar.layer.cornerRadius = imgViewAvatar.frame.width / 2
        imgViewAvatar.clipsToBounds = true
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        layer.addSublayer(bottomBorder)
    }
    
    
    func showInfo(_ data: FDChild) {
        imgViewAvatar.sd_setImage(with: URL(fileURLWithPath: data.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
        lblName.text = data.username
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        lblBirthday.text = "Birth: " + formatter.string(from: data.birthDay!)
    }
    
}
