//
//  ProviderServices.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/15/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

struct ProviderServices: Equatable {
  let serviceId: String
  let price:Int
  let service:String
  
  init(serviceId:String,price:Int,service:String){
    self.price = price
    self.service = service
    self.serviceId = serviceId
    
  }
  init(dict:[String:Any]) {
    
    self.price = dict[ServicesCollectionKeys.price] as? Int ?? 0
    
    self.serviceId = dict[ServicesCollectionKeys.serviceId] as? String ?? "no serviceId found"

    self.service = dict[ServicesCollectionKeys.serviceName] as? String ?? "no service Name found"

  }
}
