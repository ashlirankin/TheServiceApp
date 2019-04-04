//
//  StylistsUsers.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/3/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

struct StylistsUser{
  let userId:String
  let firstName: String
  let lastName:String
  let email:String
  let gender:String
  let address:String
  let imageURL:String
  
  init(userId:String,firstName:String,lastName:String,email:String,gender:String,address:String,imageURL:String){
    self.userId = userId
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.gender = gender
    self.address = address
    self.imageURL = imageURL
  }
  init(dict:[String:Any]){
    self.userId = dict[StylistsUserCollectionKeys.userId] as? String ?? "no user id found"
    self.firstName = dict[StylistsUserCollectionKeys.firstName] as? String ?? "no first Name found"
    self.lastName = dict[StylistsUserCollectionKeys.lastName] as? String ?? "no last name found"
    self.email = dict[StylistsUserCollectionKeys.email] as? String ?? "no user id found"
    self.gender =  dict[StylistsUserCollectionKeys.gender] as? String ?? "no gender found"
    self.address = dict[StylistsUserCollectionKeys.address] as? String ?? "no user id found"
    self.imageURL = dict[StylistsUserCollectionKeys.imageURL] as? String ?? "no imageURL found"
  }
}
