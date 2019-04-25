//
//  Service.swift
//  FirebaseTests
//
//  Created by Ashli Rankin on 4/11/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

struct Service {
  let jobTitle:String
  let services: [String]
  
  init(jobTitle:String,services:[String]){
    
    self.jobTitle = jobTitle
    self.services = services
  }
  
  init(dict: [String:Any]) {
    self.jobTitle = dict[ServicesCollectionKeys.jobTitle] as? String ?? "no services found"
    self.services = dict[ServicesCollectionKeys.services] as? [String] ?? [String]()
  }
}
