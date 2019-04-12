//
//  UserDetailView.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/9/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Cosmos


class UserDetailView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bookingButton: UIButton!
    
    @IBOutlet weak var providerPhoto: UIImageView!
    @IBOutlet weak var providerFullname: UILabel!
    @IBOutlet weak var ratingsstars: CosmosView!
    @IBOutlet weak var ratingsValue: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        commonInit()

    }
    
    func  commonInit() {
        Bundle.main.loadNibNamed("UserDetailHeader", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
    }

    
}
