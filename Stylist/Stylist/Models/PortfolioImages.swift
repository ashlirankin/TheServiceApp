//
//  PortfolioImages.swift
//  Stylist
//
//  Created by Ashli Rankin on 5/6/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

struct PortfolioImages {
  let documentId:String
  let images: [String]
  
  init(documentId:String,images:[String]) {
    self.documentId = documentId
    self.images = images
  }
  
  init (dict:[String:Any]){
    self.documentId = dict[PortfolioCollectionKeys.documentId] as? String ?? "no document id found"
    self.images = dict[PortfolioCollectionKeys.images] as? [String] ?? [String]()
  }
}

