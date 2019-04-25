//
//  AppointmentCell.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/24/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Cosmos

class AppointmentCell: UITableViewCell {

    @IBOutlet weak var AppointmentImage: UIImageView!
    @IBOutlet weak var appointmentTime: UILabel!
    @IBOutlet weak var clientServices: UILabel!
    @IBOutlet weak var clientDistance: UILabel!
    @IBOutlet weak var clientRatings: CosmosView!
    @IBOutlet weak var clientName: UILabel!
}
