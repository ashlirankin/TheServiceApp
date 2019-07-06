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
    
    
    init(userID: String, date: String, documentID: String, licenceNumber: String, licenceState: String, licenseHolderName: String, licenseExpiration: String, businessName: String, licenceAddress: String) {
        self.userID = userID
        self.date = date
        self.documentID = documentID
        self.licenceNumber = licenceNumber
        self.licenceState = licenceState
        self.licenceHolderName = licenseHolderName
        self.licenceExpiration = licenseExpiration
        self.businessName = businessName
        self.licenceAddress = licenceAddress
    }
    
    init(dict: [String: Any]) {
        self.userID = dict["userId"] as? String ?? "no userID"
        self.date = dict["date"] as? String ?? "no date dadded"
        self.documentID = dict["documentID"] as? String ?? "no ID added"
        self.licenceNumber = dict["licenceNumber"] as? String ?? "no license added"
        self.licenceState = dict["licenceState"] as? String ?? "no licence state were added"
        self.licenceHolderName = dict["licenceHolderName"] as? String ?? "no licence holder name exists"
        self.licenceExpiration = dict["licenceExpiration"] as? String ?? "no licence expiration date added"
        self.businessName = dict["businessName"] as? String ?? "no business name were added"
        self.licenceAddress = dict["licenseAddress"] as? String ?? "no address found"
    }

}
