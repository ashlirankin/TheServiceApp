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
    
   
    var stylist: ServiceSideUser!
    var settings = CosmosSettings()
    private var authService = (UIApplication.shared.delegate as! AppDelegate).authService
    
    
    var userRating: Double?
    var userReview = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCosmos()
        reviewTextView.delegate = self
        reviewTextView.textColor = .black
    }
    
    private func setupCosmos() {
        cosmosView.settings.fillMode = .half
        cosmosView.rating = 0
        cosmosView.didFinishTouchingCosmos = { captureRating in
            self.userRating = captureRating
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
    
        guard let loggedInUser = authService.getCurrentUser()?.uid else {
            return
        }

        let rating = Ratings(ratingId: "", value: userRating , userId: stylist.userId, raterId: loggedInUser)
        DBService.postProviderRating(ratings: rating) { (error) in
            if let error = error {
                print("There was an error sending the rating to firebase \(error.localizedDescription)")
            }
        }

        let review = Reviews(reviewerId: loggedInUser, description: userReview, createdDate: Date.getISOTimestamp(), ratingId: "", value: userRating, reviewId: "", reviewStylist: stylist.userId)
            
        DBService.postProviderReview(reviews: review) { (error) in
            if let error = error {
                print("There was an error sending the review to firebase \(error.localizedDescription)")
            }
        }
        
    }

}

extension RatingsAndReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Leave a Review!" {
            textView.text = ""
            textView.textColor = .blue
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "Leave a Review!" {
        textView.text = "Leave a Review!"
            textView.textColor = .lightGray
        }
    }



}
