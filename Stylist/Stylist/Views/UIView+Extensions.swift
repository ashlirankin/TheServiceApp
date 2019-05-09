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
}
