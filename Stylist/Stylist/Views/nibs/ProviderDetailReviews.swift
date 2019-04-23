//
//  ProviderDetailReviews.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/10/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class ProviderDetailReviews: UIView {
    @IBOutlet var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()

    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ProviderDetailReviews", owner: self, options: nil)
        addSubview(tableView)
    }

    
}
