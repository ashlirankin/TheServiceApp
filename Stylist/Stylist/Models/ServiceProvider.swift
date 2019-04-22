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
  let firstName:String?
  let lastName:String?
  let email:String
  let joinedDate:String
  let gender:String?
  let isCertified:Bool
  let imageURL:String?
  let bio:String?
  let licenseNumber:String?
  let licenseExpiryDate:String?
  let jobTitle:String
  let address:String?
  let city:String?
  let state:String?
  let lat:String?
  let long:String?
  let zip:String?
  let isAvailable: Bool
    init(userId:String,firstName:String?,lastName:String?,email:String,joinedDate:String,gender:String?,isCertified:Bool,imageURL:String?,bio:String?,licenseNumber:String?,licenseExpiryDate:String?,type:String,address:String?,city:String,state:String,lat:String,long:String,zip:String,isAvailable:Bool){
    
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
    self.jobTitle = type
    self.address = address
    self.city = city
    self.state = state
    self.lat = lat
    self.long = long
    self.zip = zip
    self.isAvailable = isAvailable
  }
  init(dict:[String:Any]){
    self.userId = dict[ServiceSideUserCollectionKeys.userId] as? String ?? "no user id found"
    self.firstName = dict[ServiceSideUserCollectionKeys.firstName] as? String ?? "no first name found"
    self.lastName = dict[ServiceSideUserCollectionKeys.lastName] as? String ?? "no last name found"
    self.email = dict[ServiceSideUserCollectionKeys.email] as? String ?? "no email found"
    self.joinedDate = dict[ServiceSideUserCollectionKeys.joinedDate] as? String ?? "no joined date found"
    self.gender = dict[ServiceSideUserCollectionKeys.gender] as? String ?? "no gender found"
   self.isCertified =  dict[ServiceSideUserCollectionKeys.isCertified] as? Bool ?? false
    self.imageURL = dict[ServiceSideUserCollectionKeys.imageURL] as? String ?? "no imageURL found"
    self.bio = dict[ServiceSideUserCollectionKeys.bio] as? String ?? "no bio found"
    self.licenseNumber = dict[ServiceSideUserCollectionKeys.licenseNumber] as? String ?? "no license number found"
    self.licenseExpiryDate = dict[ServiceSideUserCollectionKeys.licenseExpiryDate] as? String ?? "no expiry date found"
    self.jobTitle = dict[ServiceSideUserCollectionKeys.jobTitle] as? String ?? "no type"
    self.address = dict[ServiceSideUserCollectionKeys.address] as? String ?? "no address found"
    self.city = dict[ServiceSideUserCollectionKeys.city] as? String ?? "no city found"
    self.lat = dict[ServiceSideUserCollectionKeys.lat] as? String ?? "no lat found"
    self.long = dict[ServiceSideUserCollectionKeys.long] as? String ?? "no long found"
    self.zip = dict[ServiceSideUserCollectionKeys.zip] as?  String ?? "no zip found"
    self.state = dict[ServiceSideUserCollectionKeys.state] as? String ?? "no state found"
    self.isAvailable = dict[ServiceSideUserCollectionKeys.isAvailable] as? Bool ?? false
  }
}
