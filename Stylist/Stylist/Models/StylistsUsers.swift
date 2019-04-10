//
//  StylistsUsers.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/3/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

struct StylistsUser {
  let userId:String
  let firstName: String?
  let lastName:String?
  let email:String
  let gender:String?
  let imageURL:String?
  let joinedDate:String
  let street:String?
  let city:String?
  let state:String?
  let zip:String?

    
    public var fullName: String {
        return ((firstName ?? "") + " " + (lastName ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension StylistsUser {
  init(dict:[String:Any]){
    self.userId = dict[StylistsUserCollectionKeys.userId] as? String ?? "no user id found"
    self.firstName = dict[StylistsUserCollectionKeys.firstName] as? String ?? "no first Name found"
    self.lastName = dict[StylistsUserCollectionKeys.lastName] as? String ?? "no last name found"
    self.email = dict[StylistsUserCollectionKeys.email] as? String ?? "no user id found"
    self.gender =  dict[StylistsUserCollectionKeys.gender] as? String ?? "no gender found"
    self.imageURL = dict[StylistsUserCollectionKeys.imageURL] as? String ?? "no imageURL found"
    self.joinedDate = dict[StylistsUserCollectionKeys.joinedDate] as? String ?? "no joined date found"
    self.street = dict[StylistsUserCollectionKeys.street] as? String ?? "no street found"
    self.city = dict[StylistsUserCollectionKeys.city] as? String ?? "no city found"
    self.state = dict[StylistsUserCollectionKeys.state] as? String ?? "no state found"
    self.zip = dict[StylistsUserCollectionKeys.zip] as? String ?? "no zip found"
  }
}
