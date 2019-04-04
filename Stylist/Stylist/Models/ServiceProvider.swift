//
//  ServiceProvider.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/3/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation
struct ServiceSideUser{
  let userId:String
  let firstName:String
  let lastName:String
  let email:String
  let joinedDate:String
  let gender:String
  let isCertified:String
  let imageURL:String
  let bio:String
  let licenseNumber:String
  let licenseExpiryDate:String
  
  init(userId:String,firstName:String,lastName:String,email:String,joinedDate:String,gender:String,isCertified:String,imageURL:String,bio:String,licenseNumber:String,licenseExpiryDate:String){
    
    self.userId = userId
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.joinedDate = joinedDate
    self.gender = gender
    self.isCertified = isCertified
    self.imageURL = imageURL
    self.bio = bio
    self.licenseNumber = licenseNumber
    self.licenseExpiryDate = licenseExpiryDate
  }
  init(dict:[String:Any]){
    self.userId = dict[ServiceSideUserCollectionKeys.userId] as? String ?? "no user id found"
    self.firstName = dict[ServiceSideUserCollectionKeys.firstName] as? String ?? "no first name found"
    self.lastName = dict[ServiceSideUserCollectionKeys.lastName] as? String ?? "no last name found"
    self.email = dict[ServiceSideUserCollectionKeys.email] as? String ?? "no email found"
    self.joinedDate = dict[ServiceSideUserCollectionKeys.joinedDate] as? String ?? "no joined date found"
    self.gender = dict[ServiceSideUserCollectionKeys.gender] as? String ?? "no gender found"
   self.isCertified =  dict[ServiceSideUserCollectionKeys.isCertified] as? String ?? "no certified data found"
    self.imageURL = dict[ServiceSideUserCollectionKeys.imageURL] as? String ?? "no imageURL found"
    self.bio = dict[ServiceSideUserCollectionKeys.bio] as? String ?? "no bio found"
    self.licenseNumber = dict[ServiceSideUserCollectionKeys.licenseNumber] as? String ?? "no license number found"
    self.licenseExpiryDate = dict[ServiceSideUserCollectionKeys.licenseExpiryDate] as? String ?? "no expiry date found"
  }
}
