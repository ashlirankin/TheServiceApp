//
//  ServiceDetailViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/5/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Cosmos

class ServiceDetailViewController: UIViewController {
    var appointment: Appointments!
    var status: String?
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userRating: CosmosView!
    @IBOutlet weak var userFullname: UILabel!
    @IBOutlet weak var appointmentStatus: UILabel!
    @IBOutlet weak var userDistance: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var AppointmentCreated: UILabel!
    @IBOutlet weak var todaysDate: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDetailUI()
    }
    
    private func  updateDetailUI() {
        
    }
    
    @IBAction func confirmBookingPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func cancelBookingPressed(_ sender: UIButton) {
    }
    
    
}
