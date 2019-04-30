//
//  NoBookingView.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/26/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class NoBookingView: UIView {
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("NoBookingScreen", owner: self, options: nil)
         addSubview(contentView)
    }
}
