//
//  LeaveReviewNotification.swift
//  Stylist
//
//  Created by Oniel Rosario on 5/9/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Cosmos

class LeaveReviewNotification: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var cancelButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 236, height: 380))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LeaveReviewNotification", owner: self, options: nil)
        addSubview(contentView)
        cancelButton.addTarget(self, action: #selector(dismissPressed), for: .touchUpInside)
    }
    
    @objc func dismissPressed() {
        self.removeFromSuperview()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else  { return }
////        guard touch.view != self || self.subviews.contains(touch.view!) else { return }
//        
//    }
    
}
