//
//  Avalibility.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/3/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

struct Avalibility {
  let userId:String
  let avalibilityId:String
  let dayName:String
  let day:Days
  let createdDate:String
  
  init(userId:String,avalibilityId:String,dayName:String,day:Days,createdDate:String){
    self.userId = userId
    self.avalibilityId = avalibilityId
    self.dayName = dayName
    self.day = day
    self.createdDate = createdDate
  }
  init(dict:[String:Any]){
    
    self.userId = dict[AvalibilityCollectionKeys.userId] as? String ?? "no user found for avalibility"
    self.avalibilityId = dict[AvalibilityCollectionKeys.avalibilityId] as? String ?? "no avalibility id found"
    self.dayName = dict[AvalibilityCollectionKeys.dayName] as? String ?? "no dayName found"
    self.createdDate = dict[AvalibilityCollectionKeys.createdDate] as? String ?? "no created date found"
    self.day = (dict[AvalibilityCollectionKeys.days] as? Days)! 
  }
}
