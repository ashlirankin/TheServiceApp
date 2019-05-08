//
//  Avalibility.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/3/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

struct Availability {
  let userId:String
  let avalibilityId:String
  let currentDate:String
  let avalibleHours: [String]

  
  init(userId:String,avalibilityId:String,currentDate:String,avalibleHours:[String]){
    self.userId = userId
    self.avalibilityId = avalibilityId
    self.avalibleHours = avalibleHours
    self.currentDate = currentDate
  }
  init(dict:[String:Any]){
    
    self.userId = dict[AvalibilityCollectionKeys.userId] as? String ?? "no user found for avalibility"
    self.avalibilityId = dict[AvalibilityCollectionKeys.avalibility] as? String ?? "no avalibility id found"
   self.avalibleHours = dict["avalibleHours"] as? [String] ?? [String]()
    self.currentDate =  dict["currentDate"] as? String ?? "no current date found"
  }
}
