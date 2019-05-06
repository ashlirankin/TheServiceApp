//
//  ProviderBio.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/10/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class ProviderBio: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var providerBioText: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func  commonInit() {
        Bundle.main.loadNibNamed("ProviderDetailBio", owner: self, options: nil)
        providerBioText.isEditable = false
        addSubview(contentView)
        contentView.frame = bounds
    }

    
}
