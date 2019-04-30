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
    @IBOutlet weak var ProfileCellImage: UIImageView!
    @IBOutlet weak var bookingsRatings: CosmosView!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerService: UILabel!
}
