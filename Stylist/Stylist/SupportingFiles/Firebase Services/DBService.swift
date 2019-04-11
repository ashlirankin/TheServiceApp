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
  static func CreateServiceProvider(serviceProvider:ServiceSideUser,completionHandler: @escaping (Error?) -> Void){
    firestoreDB.collection(ServiceSideUserCollectionKeys.serviceProvider).document(serviceProvider.userId).setData([ServiceSideUserCollectionKeys.firstName: serviceProvider.firstName
      ?? "" ,
                                                                                                                    ServiceSideUserCollectionKeys.lastName:serviceProvider.lastName ?? "" ,
                                                                                                                    ServiceSideUserCollectionKeys.bio: serviceProvider.bio ?? "" , ServiceSideUserCollectionKeys.email:serviceProvider.email, ServiceSideUserCollectionKeys.gender: serviceProvider.gender ?? "" ,ServiceSideUserCollectionKeys.imageURL:serviceProvider.imageURL ?? "" , ServiceSideUserCollectionKeys.joinedDate:serviceProvider.joinedDate, ServiceSideUserCollectionKeys.licenseExpiryDate:serviceProvider.licenseExpiryDate ?? "" , ServiceSideUserCollectionKeys.licenseNumber:serviceProvider.licenseNumber ?? "" , ServiceSideUserCollectionKeys.isCertified : serviceProvider.isCertified, ServiceSideUserCollectionKeys.userId: serviceProvider.userId ]) { (error) in
      if let error = error {
        print("there was an error:\(error.localizedDescription)")
      }
      print("database user sucessfully created")
    }
  }
  static func createConsumerDatabaseAccount(consumer:StylistsUser,completionHandle: @escaping (Error?) -> Void ){
    
firestoreDB.collection(StylistsUserCollectionKeys.stylistUser).document(consumer.userId).setData([StylistsUserCollectionKeys.userId : consumer.userId, StylistsUserCollectionKeys.firstName: consumer.firstName ?? ""
      ,StylistsUserCollectionKeys.lastName:consumer.lastName ?? "", StylistsUserCollectionKeys.email : consumer.email,StylistsUserCollectionKeys.gender: consumer.gender ?? "", StylistsUserCollectionKeys.imageURL: consumer.imageURL ?? "", StylistsUserCollectionKeys.joinedDate: Date.getISOTimestamp()]) { (error) in
      if let error = error {
        print(" there was an error: \(error.localizedDescription)")
      }
    }
  }
    

  static func getDatabaseUser(userID: String, completionHandler: @escaping (Error?,StylistsUser?)-> Void){
    firestoreDB.collection(StylistsUserCollectionKeys.stylistUser)
        .whereField(StylistsUserCollectionKeys.userId, isEqualTo: userID)
        .getDocuments(completion: { (snapshot, error) in
            if let error = error {
                completionHandler(error, nil)
            } else if let snapshot = snapshot?.documents.first {
                let stylistUser = StylistsUser(dict: snapshot.data())
                completionHandler(nil, stylistUser)
            }
        })
  }
  
 
  static func rateUser(collectionName:String,userId:String,rating:Ratings){
    
    let id = firestoreDB.collection(collectionName).document().documentID
    DBService.firestoreDB.collection(collectionName).document(userId).collection(RatingsCollectionKeys.ratings).addDocument(data: [RatingsCollectionKeys.ratingId:id,
                                                                                                                                   RatingsCollectionKeys.value:rating.value,RatingsCollectionKeys.userId:rating.userId,RatingsCollectionKeys.ratingId:userId]) { (error) in
      if let error = error {
        print("there was an error: uploading your rating:\(error.localizedDescription)")
      }
    }
  }
  
  func retrieveStockServices(qurey:String,collectionName:String,field:String,completion: @escaping(Service?,Error?) -> Void){
    DBService.firestoreDB.collection(collectionName).whereField(field, isEqualTo: qurey).getDocuments { (snapshot, error) in
      if let error = error {
       completion(nil,error)
      }else if let snapshot = snapshot {
        guard let serviceData = snapshot.documents.first else {return}
        let services = Service(dict: serviceData.data())
        completion(services,nil)
        
      }
    }
  }
}




