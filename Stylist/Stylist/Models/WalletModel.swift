//
//  WalletModel.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/23/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

struct WalletModel {
  
  let cardExpiryDate:String
  let cardHolderName:String
  let cardNumber:String
  let cardType:String
  let documentId:String
  let userId:String
  
    
  
  init(dict:[String:Any]){
    
    self.cardExpiryDate = dict["cardExpiryDate"] as? String ?? "no expiry date found"
    self.cardHolderName = dict["cardHolderName"] as?   String ?? "no cardHolder name found"
    self.cardNumber = dict["cardNumber"] as? String ?? "no card number found"
    self.cardType = dict["cardType"] as? String ?? "no card Type found"
    self.documentId = dict["documentId"] as? String ?? "no document Id found"
    self.userId = dict["userId"] as?   String ?? "no user id found"
  
  }
}
