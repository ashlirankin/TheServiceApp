//
//  LocalCustomNotification.swift
//  Stylist
//
//  Created by Oniel Rosario on 5/6/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class LocalCustomNotification: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var providerImage: CircularImageView!
    @IBOutlet weak var providerFullname: UILabel!
    @IBOutlet weak var serviceDescription: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 292, height: 201))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
      commonInit()
    }
    
    func  commonInit() {
        Bundle.main.loadNibNamed("LocalCustomNotification", owner: self, options: nil)
        addSubview(contentView)
        
    }
    
  

}
