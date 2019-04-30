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
    @IBOutlet weak var userFullname: UILabel!
    @IBOutlet weak var appointmentStatus: UILabel!
    @IBOutlet weak var userDistance: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var AppointmentCreated: UILabel!
    @IBOutlet weak var todaysDate: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
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
                
            }
        }
    }
    
    
    private func  updateDetailUI() {
        switch appointment.status {
        case "inProgress":
            confirmButton.backgroundColor = .gray
            confirmButton.setTitle("confirmed", for: .normal)
            confirmButton.isEnabled = false
            completeButton.isHidden = false
        case "canceled":
            cancelButton.backgroundColor = .gray
            cancelButton.isEnabled = false
            confirmButton.backgroundColor = .gray
            confirmButton.isEnabled = false
            completeButton.isHidden = true
        case "completed":
            cancelButton.isEnabled = false
            confirmButton.isEnabled = false
            completeButton.setTitle("completed", for: .normal)
            completeButton.backgroundColor = .gray
            completeButton.isHidden = false
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
