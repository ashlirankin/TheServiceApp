//
//  RatingsAndReviewViewController.swift
//  Stylist
//
//  Created by Jabeen's MacBook on 4/9/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Cosmos

class RatingsAndReviewViewController: UIViewController {

    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    
    var reviews: Reviews!
    
    var userRating = 4.5
    override func viewDidLoad() {
        super.viewDidLoad()
        cosmosView.settings.fillMode = .half
        cosmosView.rating = userRating
        
        cosmosView.didFinishTouchingCosmos = { captureRating in
            self.userRating = captureRating
            print("userRating: \(self.userRating)")
            
        }

    }
    

    

}
