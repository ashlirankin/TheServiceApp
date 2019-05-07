//
//  ServiceDetailViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/5/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class ServiceDetailViewController: UIViewController {
    var appointment: Appointments!
    var status: String?
    var provider: ServiceSideUser?
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userRating: CosmosView!
    @IBOutlet weak var appointmentServices: UILabel!
    @IBOutlet weak var userFullname: UILabel!
    @IBOutlet weak var appointmentStatus: UILabel!
    @IBOutlet weak var userDistance: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var AppointmentCreated: UILabel!
    @IBOutlet weak var todaysDate: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var ratingsStar = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        getStylistUser()
        todaysDate.isHidden = true
         checkOnCurrentAppointment()
    }
    private func checkOnCurrentAppointment() {
        if let status = self.status {
            if status == "completed" {
                self.appointmentStatus.textColor = .gray
                self.cancelButton.isHidden = true
            } else if status == "inProgress" {
                self.appointmentStatus.textColor = .green
                self.appointmentStatus.text = "In progress"
            } else if status == "pending" {
                self.appointmentStatus.textColor = .orange
            } else {
                self.appointmentStatus.textColor = .red
                 self.cancelButton.isHidden = true
            }
        }
    }
    
    private func getStylistUser() {
        if let provider = provider {
            setupProviderRating(provider: provider)
            userFullname.text = provider.fullName
            appointmentStatus.text = appointment.status
            userDistance.text = "0.2 Miles Away"
            userAddress.text =  "85B Allen St, New York, NY 10002"
            AppointmentCreated.text = appointment.appointmentTime
            userImage.kf.setImage(with: URL(string: provider.imageURL ?? "No Image"), placeholder: #imageLiteral(resourceName: "placeholder.png"))
            completeButton.isHidden = true
            confirmButton.isHidden = true
            for service in appointment.services {
                appointmentServices.text = service
            }
        } else {
            updateDetailUI()
            DBService.getDatabaseUser(userID: appointment.userId) { (error, stylistUser) in
                if let error = error {
                    print(error)
                } else if let stylistUser = stylistUser {
                    self.userRating.rating = 5
                    self.userFullname.text = stylistUser.fullName
                    switch self.appointment.status {
                    case "inProgress":
                        self.appointmentStatus.text = "In progress"
                    default:
                         self.appointmentStatus.text = self.appointment.status
                    }
                    self.userDistance.text = "0.2 Miles Away"
                    self.userAddress.text = stylistUser.address ?? "85B Allen St, New York, NY 10002"
                    self.AppointmentCreated.text = self.appointment.appointmentTime
                    self.userImage.kf.setImage(with: URL(string: stylistUser.imageURL ?? "No Image"), placeholder: #imageLiteral(resourceName: "placeholder.png"))
                    for service in self.appointment.services {
                        self.appointmentServices.text = service
                    }
                    }
                }
            }
        }
    
    
    private func setupProviderRating(provider: ServiceSideUser) {
        userRating.settings.updateOnTouch = false
        userRating.settings.fillMode = .half
        DBService.getReviews(provider: provider) { (reviews, error) in
            if let error = error {
                print("Get Ratings Error: \(error.localizedDescription)")
                self.userRating.rating = 0
            } else if let reviews = reviews {
                let allRatings = reviews.map{ $0.value }
                if allRatings.count > 0 {
                    let averageRating = allRatings.reduce(0, +) / Double(allRatings.count)
                    self.userRating.rating = averageRating
                } else {
                    self.userRating.rating = 0
                }
            }
        }
    }
    
    
    private func  updateDetailUI() {
        userRating.settings.updateOnTouch = false
        switch appointment.status {
        case "inProgress":
            appointmentStatus.textColor = .green
            confirmButton.backgroundColor = .gray
            confirmButton.setTitle("confirmed", for: .normal)
            confirmButton.isEnabled = false
            completeButton.isHidden = false
        case "canceled":
            appointmentStatus.textColor = .red
            cancelButton.backgroundColor = .gray
            cancelButton.isEnabled = false
            cancelButton.setTitle("canceled", for: .normal)
            confirmButton.backgroundColor = .gray
            confirmButton.isEnabled = false
            completeButton.isHidden = true
        case "completed":
            appointmentStatus.textColor = .gray
            cancelButton.isEnabled = false
            cancelButton.backgroundColor = .gray
            confirmButton.isEnabled = false
            confirmButton.backgroundColor = .gray
            completeButton.setTitle("completed", for: .normal)
            completeButton.backgroundColor = .gray
            completeButton.isHidden = false
            completeButton.isEnabled = false
        default:
            completeButton.isHidden = true
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    @IBAction func confirmBookingPressed(_ sender: UIButton) {
        DBService.updateAppointment(appointmentID: appointment.documentId, status: AppointmentStatus.inProgress.rawValue)
        dismiss(animated: true)
        updateDetailUI()
    }
    
    @IBAction func cancelBookingPressed(_ sender: UIButton) {
        DBService.updateAppointment(appointmentID: appointment.documentId, status: AppointmentStatus.canceled.rawValue)
        dismiss(animated: true)
        updateDetailUI()
    }
    
    
    @IBAction func completeAppointment(_ sender: UIButton) {
        DBService.updateAppointment(appointmentID: appointment.documentId, status: AppointmentStatus.completed.rawValue)
        dismiss(animated: true)
        updateDetailUI()
    }
    
    
}
