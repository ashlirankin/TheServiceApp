//
//  Form.swift
//  Stylist
//
//  Created by Oniel Rosario on 6/28/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation


struct Form {
    let userID: String
    let date: String
    let documentID: String
    let licenceNumber: String
    let licenceState: String
    let licenceHolderName: String
    let licenceExpiration: String
    let businessName: String
    let licenceAddress: String
    
    init(dict: [String: Any]) {
        self.userID = dict["userId"] as? String ?? "no userID"
    }
}
