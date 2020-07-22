//
//  BorderdView.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

@IBDesignable
open class BorderdView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    required public init(coder: NSCoder) {
        super.init(coder: coder)!
        
        layer.borderWidth = 1.0
        layer.cornerRadius = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1.0
        layer.cornerRadius = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
