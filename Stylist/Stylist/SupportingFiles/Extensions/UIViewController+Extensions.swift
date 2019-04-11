//
//  UIView+Extensions.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/10/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public func setupScrollviewController(scrollView: UIScrollView, views: [UIView]) {
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(views.count), height: 300)
        scrollView.showsHorizontalScrollIndicator = false
    }
}
