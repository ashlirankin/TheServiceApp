//
//  SentForm.swift
//  Stylist
//
//  Created by Oniel Rosario on 7/2/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class SentForm: UIView {
    @IBOutlet var content: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
   private func commonInit() {
    Bundle.main.loadNibNamed("FormSent", owner: self, options: nil)
    addSubview(content)
    }
    
    
}
