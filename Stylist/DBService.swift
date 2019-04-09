//
//  DBService.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/5/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

final class DBService {
  private init() {}
  
  public static var firestoreDB: Firestore = {
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    return db
  }()
  
  
  static func createConsumerDatabaseAccount(consumer:StylistsUser,completionHandle: @escaping (Error?) -> Void ){
    
firestoreDB.collection(StylistsUserCollectionKeys.stylistUser).document(consumer.userId).setData([StylistsUserCollectionKeys.userId : consumer.userId, StylistsUserCollectionKeys.firstName: consumer.firstName ?? ""
      ,StylistsUserCollectionKeys.lastName:consumer.lastName ?? "" , StylistsUserCollectionKeys.address: consumer.address ?? "", StylistsUserCollectionKeys.email : consumer.email,StylistsUserCollectionKeys.gender: consumer.gender ?? "", StylistsUserCollectionKeys.imageURL: consumer.imageURL ?? "", StylistsUserCollectionKeys.joinedDate: Date.getISOTimestamp()]) { (error) in
      if let error = error {
        print(" there was an error: \(error.localizedDescription)")
      }
      
    }
  }
  static func getDatabaseUser(collectionName:String,user:User, completionHandler: @escaping (Error?,DocumentSnapshot?)-> Void){
    
    firestoreDB.collection(collectionName).document(user.uid).getDocument { (snapshot, error) in
      if let error = error{
        completionHandler(error,nil)
      }
      if let snapshot = snapshot {
        completionHandler(nil,snapshot)
      }
    }
  }
}




