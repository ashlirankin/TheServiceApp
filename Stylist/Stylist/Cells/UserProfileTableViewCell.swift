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
    @IBOutlet weak var appointmentStatusButton: UIButton!
    
    public func configuredCell(provider: ServiceSideUser, appointment: Appointments) {
        setAppointmentTime(appointment: appointment)
        setAppointmentStatusUI(appointment: appointment)
        setupProviderRating(provider: provider)
        backgroundColor = #colorLiteral(red: 0.2462786138, green: 0.3436814547, blue: 0.5806058645, alpha: 1)
        providerName.text = "\(provider.firstName ?? "") \(provider.lastName ?? "")"
        providerService.text = provider.jobTitle
        if let imageURL = provider.imageURL {
            providerProfileImage.kf.indicatorType = .activity
            providerProfileImage.kf.setImage(with: URL(string: imageURL), placeholder: #imageLiteral(resourceName: "placeholder.png"))
        }
    }
    
    private func setupProviderRating(provider: ServiceSideUser) {
        providerRating.settings.updateOnTouch = false
        providerRating.settings.fillMode = .half

        DBService.getReviews(provider: provider) { (reviews, error) in
            if let error = error {
                print("Get Ratings Error: \(error.localizedDescription)")
                self.providerRating.rating = 0
            } else if let reviews = reviews {
                let allRatings = reviews.map{ $0.value }
                if allRatings.count > 0 {
                    let averageRating = allRatings.reduce(0, +) / Double(allRatings.count)
                    self.providerRating.rating = averageRating
                } else {
                    self.providerRating.rating = 0
                }
            }
        }
    }
    
    private func setAppointmentStatusUI(appointment: Appointments) {
        switch  appointment.status {
        case "pending":
            appointmentStatusButton.setImage(UIImage(named: "orange_circle"), for: .normal)
        case "inProgress":
            appointmentStatusButton.setImage(UIImage(named: "green_circle"), for: .normal)
        case "completed":
            appointmentStatusButton.setImage(UIImage(named: "check_circle"), for: .normal)
        case "canceled":
            appointmentStatusButton.setImage(UIImage(named: "cancel_circle"), for: .normal)
        default:
            appointmentStatusButton.isHidden = true
        }
    }
    
    private func setAppointmentTime(appointment: Appointments) {
        let convertToDateFormatter = DateFormatter()
        convertToDateFormatter.dateFormat = "EEEE, MMM d, yyyy h:mm a"
        let date = convertToDateFormatter.date(from: appointment.appointmentTime)
        guard let safeDate = date else {
            dateAndTimeLabel.text = "No Date"
            return
        }
        if appointment.status == "completed" || appointment.status == "canceled" {
            let pastDateFormatter = DateFormatter()
            pastDateFormatter.dateFormat = "MMM d, yyyy"
            dateAndTimeLabel.text = pastDateFormatter.string(from: safeDate)
        } else {
            let upcomingDateFormatter = DateFormatter()
            upcomingDateFormatter.dateFormat = "h:mm a"
            dateAndTimeLabel.text = upcomingDateFormatter.string(from: safeDate)
        }
    }
}
