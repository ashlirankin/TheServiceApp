//
//  UIView+Extensions.swift
//  Stylist
//
//  Created by Oniel Rosario on 5/7/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation
import UIKit


public extension UIView {
    func fadeOut(withDuration duration: TimeInterval = 7.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.cornerRadius = 10
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0)
       gradient.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
