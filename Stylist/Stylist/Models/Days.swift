//
//  Days.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/3/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

struct Days{
  let dayId:String
  let userId:String
  let avalibleHours:[String]
  
  init(dayId:String,userId:String,avalibleHours:[String]){
    self.avalibleHours = avalibleHours
    self.dayId = dayId
    self.userId = userId
  }
  init(dict:[String:Any]){
    self.avalibleHours = dict[DaysCollectionKeys.avalibliehours] as? [String] ?? [String]()
    self.dayId = dict[DaysCollectionKeys.daysId] as? String ?? "dayId not found"
    self.userId = dict[DaysCollectionKeys.userId] as? String ?? "no user id found"
  }
}
