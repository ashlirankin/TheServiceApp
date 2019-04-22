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
    
  @IBOutlet weak var promptLabel: UILabel!
  
  @IBOutlet weak var tipLabelPrompt: UILabel!
  
  @IBOutlet weak var tipCollectionView: UICollectionView!
  
  @IBOutlet weak var orderTableView: UITableView!
  
  var stylist: ServiceSideUser?
    var settings = CosmosSettings()
    private var authService = (UIApplication.shared.delegate as! AppDelegate).authService
    
    
    var userRating: Double?
    var userReview = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCosmos()
        configureTextView()
        
        //DBService.
    }
    
    private func configureTextView() {
        reviewTextView.delegate = self
        reviewTextView.textColor = .lightGray
        reviewTextView.text = "Leave a Review!"
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
        var networkCallCount = 0 {
            didSet {
                if networkCallCount == 2 {
                    navigationItem.rightBarButtonItem?.isEnabled = true
                    dismiss(animated: true)
                }
            }
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        guard let reviewText = reviewTextView.text, !reviewText.isEmpty,
            let userRating = userRating else {
                showAlert(title: "Missing fields", message: "All fields are required", actionTitle: "Ok")
                return
        }
    
        guard let loggedInUser = authService.getCurrentUser()?.uid else {
            showAlert(title: "No Logged User", message: nil , actionTitle: "Ok")
            navigationItem.rightBarButtonItem?.isEnabled = true 
            return
        }
        
        let databaseUserId = "4UathYHKvyXZV739xBD9FaJFH2D2"
        
        let rating = Ratings(ratingId: "", value: userRating , userId: databaseUserId, raterId: loggedInUser)
        DBService.postProviderRating(ratings: rating) { (error) in
            if let error = error {
                self.showAlert(title: "Network Error", message: "There was an error sending the rating to firebase \(error.localizedDescription)", actionTitle: "Ok")
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            networkCallCount += 1
        }

        let review = Reviews(reviewerId: databaseUserId, description: reviewTextView.text, createdDate: Date.getISOTimestamp(), ratingId: "", value: userRating, reviewId: "", reviewStylist: "4UathYHKvyXZV739xBD9FaJFH2D2")
        
        DBService.postProviderReview(stylistReviewed: stylist, review: review) { (error) in
            if let error = error {
                self.showAlert(title: "Network Error", message: "There was an error sending the review to firebase \(error.localizedDescription)", actionTitle: "Ok")
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            networkCallCount += 1
        }
        
    }

}

extension RatingsAndReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Leave a Review!" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
        textView.text = "Leave a Review!"
            textView.textColor = .lightGray
        } else {
            reviewTextView.text = textView.text
        }
    }



}
