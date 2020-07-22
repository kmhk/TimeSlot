//
//  View.swift
//  TimeSlot
//
//  Created by com on 7/22/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

extension UIView {
    func roundGradientView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = .init(x: 0, y: 0)
        gradientLayer.endPoint = .init(x: 1, y: 0)
        gradientLayer.colors = [UIColor.tsMainDark!.cgColor, UIColor.systemBlue.cgColor]
        gradientLayer.cornerRadius = frame.width / 5
        layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = frame.width / 5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
    }
    
    func squareGradientView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = .init(x: 0, y: 0)
        gradientLayer.endPoint = .init(x: 1, y: 0)
        gradientLayer.colors = [UIColor.tsMainDark!.cgColor, UIColor.systemBlue.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
        
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
    }
}
