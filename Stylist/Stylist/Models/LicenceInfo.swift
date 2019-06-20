//
//  LicenceInfo.swift
//  Stylist
//
//  Created by Oniel Rosario on 6/20/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation
import CoreLocation

struct licenseInfo: Codable {
    struct Licence: Codable {
        let license_number: String
        let licensed_state: String
        let license_holder_name: String
        let license_expiration_date: String
        let business_name: String
        struct LicenseLocation: Codable {
            let latitude: String
            let longitude: String
            var coodinate: CLLocationCoordinate2D {
                var locationCoordinate = CLLocationCoordinate2D()
                locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(latitude)!), longitude: CLLocationDegrees(Double(longitude)!))
                return locationCoordinate
            }
        }
        let location: LicenseLocation
    }
    let license: [Licence]
}
