//
//  StylistCollectionKeys.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/3/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

struct ServiceSideUserCollectionKeys{
  let serviceProvider = "serviceProvider"
  let userId = "userId"
  let firstName = "firstName"
  let lastName = "lastName"
  let email = "email"
  let joinedDate = "joinedDate"
  let gender = "gender"
  let isCertified = "isCertified"
  let imageURL = "imageURL"
  let bio = "bio"
  let licenseNumber = "licenseNumber"
  let licenseExpiryDate = "licenseExpiryDate"
}

struct StylistsUserCollectionKeys{
  let stylistUser = "stylistUser"
  let userId = "userId"
  let firstName = "firstName"
  let lastName = "lastName"
  let email = "email"
  let gender = "gender"
  let address = "address"
  let imageURL = "imageURL"
  
}

struct RatingsCollectionKeys {
    let ratings = "ratings"
    let ratingId = "ratingId"
    let value = "value"
    let userId = "userId"
  
}

struct ReviewsCollectionKeys{
  let reviews = "reviews"
  
}

struct AvalibilityCollectionKeys{
  
}
