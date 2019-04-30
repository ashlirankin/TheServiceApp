//
//  ProfileNoBooking.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/29/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class ProfileNoBooking: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var noBookingLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
          commonInit()
    }

    
    func  commonInit() {
        Bundle.main.loadNibNamed("ProfileNoBooking", owner: self, options: nil)
        addSubview(contentView)
    }
}
