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
  
  init(ratingId:String,value:Int,userId:String) {
    self.ratingId = ratingId
    self.value = value
    self.userId = userId
  }
  
  init(dict:[String:Any]) {
    self.ratingId = dict[RatingsCollectionKeys.ratingId] as? String ?? "no rating found"
    self.userId = dict[RatingsCollectionKeys.userId] as? String ?? "no user id found"

    self.value =  dict[RatingsCollectionKeys.value] as? Int ?? 5
  
  }
}
