//
//  UserDefaultsKeys.swift
//  Stylist
//
//  Created by Jian Ting Li on 4/17/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

struct UserDefaultsKeys {
    static let defaults = UserDefaults.standard
    
    static let availableNow = "AvailableNow"
    static let genderFilter = "GenderFilter"
    static let professionFilter = "ProfessionFilter"
    static let maxPriceFilter = "PriceRangeFilter"
    static let servicesFilter = "ServicesFilter"
    
    static func wipeUserDefaults() {
        defaults.set(false, forKey: availableNow)
        defaults.set([String: String](), forKey: genderFilter)
        defaults.set([String: String](), forKey: professionFilter)
        defaults.set(1000, forKey: maxPriceFilter)
        defaults.set([String: String](), forKey: servicesFilter)
    }
}

