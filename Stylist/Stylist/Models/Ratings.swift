//
//  Ratings.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/3/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation
struct Ratings{
  let ratingId:String
  let value:Int
  let userId:String
  let raterId:String
  
  init(ratingId:String,value:Int,userId:String,raterId:String) {
    self.ratingId = ratingId
    self.value = value
    self.userId = userId
    self.raterId = raterId
  }
  
  init(dict:[String:Any]) {
    self.ratingId = dict[RatingsCollectionKeys.ratingId] as? String ?? "no rating found"
    self.userId = dict[RatingsCollectionKeys.userId] as? String ?? "no user id found"

    self.value =  dict[RatingsCollectionKeys.value] as? Int ?? 5
  
    self.raterId = dict[RatingsCollectionKeys.raterId] as? String ?? "no raterId found"
  }
}
