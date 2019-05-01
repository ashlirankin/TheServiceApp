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
    var stylistUser: StylistsUser!
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
        updateDetailUI()
        
    }
    
    private func getStylistUser() {
        DBService.getDatabaseUser(userID: appointment.userId) { (error, stylistUser) in
            if let error = error {
                print(error)
            } else if let stylistUser = stylistUser {
                self.userRating.rating = 5
                self.userFullname.text = stylistUser.fullName
                self.appointmentStatus.text = self.appointment.status
                self.userDistance.text = "0.2"
                self.userAddress.text = stylistUser.address ?? "no address"
                self.AppointmentCreated.text = self.appointment.appointmentTime
                self.userImage.kf.setImage(with: URL(string: stylistUser.imageURL ?? "no image"), placeholder: #imageLiteral(resourceName: "placeholder.png"))
                for service in self.appointment.services {
                    self.appointmentServices.text = service
                }
                
            }
        }
    }
    
    
    private func  updateDetailUI() {
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
        updateDetailUI()
    }
    
    
}
