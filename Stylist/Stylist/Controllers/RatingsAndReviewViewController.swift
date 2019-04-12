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
    
    var settings = CosmosSettings()
    
    var userRating: Double?
    var userReview = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cosmosView.settings.fillMode = .half
        cosmosView.rating = 0
        
        cosmosView.didFinishTouchingCosmos = { captureRating in
            self.userRating = captureRating
            print("userRating: \(self.userRating)")
            
        }

    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        guard let reviewText = reviewTextView.text, !reviewText.isEmpty,
            let userRating = userRating else {
                showAlert(title: "Missing fields", message: "All fields are required", actionTitle: "Ok")
                return
        }
        // send rating to firebase
        // send review to firebase
    }
    
    

    

}
