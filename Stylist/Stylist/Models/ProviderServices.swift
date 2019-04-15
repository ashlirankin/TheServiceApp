//
//  ProviderServices.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/15/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

struct ProviderServices{
  let serviceId: String
  let price:String
  let service:String
  
  init(serviceId:String,price:String,service:String){
    self.price = price
    self.service = service
    self.serviceId = serviceId
    
  }
  init(dict:[String:Any]) {
    
    self.price = dict[ServicesCollectionKeys.price] as? String ?? "no price found"
    
    self.serviceId = dict[ServicesCollectionKeys.serviceId] as? String ?? "no serviceId found"

    self.service = dict[ServicesCollectionKeys.serviceName] as? String ?? "no service Name found"

  }
}
