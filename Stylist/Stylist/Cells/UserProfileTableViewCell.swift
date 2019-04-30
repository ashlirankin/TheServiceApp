//
//  UserProfileTableViewCell.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/15/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Cosmos

class UserProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var providerProfileImage: CircularImageView!
    @IBOutlet weak var providerRating: CosmosView!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerService: UILabel!
    
    public func configuredCell(provider: ServiceSideUser, appointment: Appointments) {
        setupProviderRating(providerId: provider.userId)
        backgroundColor = #colorLiteral(red: 0.2462786138, green: 0.3436814547, blue: 0.5806058645, alpha: 1)
        providerName.text = "\(provider.firstName ?? "") \(provider.lastName ?? "")"
        providerService.text = provider.jobTitle
        dateAndTimeLabel.text = appointment.appointmentTime
        if let imageURL = provider.imageURL {
            providerProfileImage.kf.indicatorType = .activity
            providerProfileImage.kf.setImage(with: URL(string: imageURL), placeholder: #imageLiteral(resourceName: "placeholder.png"))
        }
    }
    
    private func setupProviderRating(providerId: String) {
        providerRating.settings.updateOnTouch = false
        providerRating.settings.fillMode = .half
        DBService.getReviews(provider: providerId) { (error, ratings) in
            if let error = error {
                print("Get Ratings Error: \(error.localizedDescription)")
                self.providerRating.rating = 0
            } else if let ratings = ratings {
                var sum: Double = 0
                for rating in ratings {
                    sum += rating.value
                }
                self.providerRating.rating = sum
            }
        }
    }
}
