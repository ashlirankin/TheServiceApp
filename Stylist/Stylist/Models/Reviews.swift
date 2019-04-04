//
//  Reviews.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/3/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation
struct Reviews {
  let reviewerId:String
  let rating:Ratings
  let description:String
  let createdDate:String
  
  init(reviewerId:String,rating:Ratings,description:String,createdDate:String){
    self.reviewerId = reviewerId
    self.rating = rating
    self.description = description
    self.createdDate = createdDate
  }
  init(dict:[String:Any]) {
    self.rating = (dict[ReviewsCollectionKeys.ratings] as? Ratings)!
    self.reviewerId = dict[ReviewsCollectionKeys.reviewerId] as? String ?? "no reviewer id found"
    self.description = dict[ReviewsCollectionKeys.description] as? String ?? "no description found"
    self.createdDate = dict[ReviewsCollectionKeys.createdDate] as? String ?? "no created date found"
    
  }
}
