//
//  ServiceBioView.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/8/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class ServiceBioView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var ServiceBio: UITextView!
    @IBOutlet weak var ServiceEditBioButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func  commonInit() {
        Bundle.main.loadNibNamed("ProfileHeader", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
    }
    
    
}
