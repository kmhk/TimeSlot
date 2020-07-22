//
//  ContractCVCell.swift
//  TimeSlot
//
//  Created by com on 7/22/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class ContractCVCell: UICollectionViewCell {
    
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var imgViewAvatar: UIImageView!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var lblPeoples: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblRate: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.tsMain!.cgColor
        
        imgViewAvatar.layer.cornerRadius = imgViewAvatar.frame.width / 2
        imgViewAvatar.layer.borderColor = UIColor.systemBlue.cgColor
        imgViewAvatar.layer.borderWidth = 1.0
        imgViewAvatar.clipsToBounds = true
        
        btnSignUp.layer.cornerRadius = 2
        btnSignUp.clipsToBounds = true
        
        viewTitle.squareGradientView()
    }
    
    func setCellType(_ isCoach: Bool) {
        imgViewAvatar.isHidden = isCoach
        lblOwner.isHidden = isCoach
        btnSignUp.isHidden = isCoach
    }
}
