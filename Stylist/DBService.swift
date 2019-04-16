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
            ,StylistsUserCollectionKeys.lastName:consumer.lastName ?? "" , StylistsUserCollectionKeys.address: consumer.address ?? "", StylistsUserCollectionKeys.email : consumer.email,StylistsUserCollectionKeys.gender: consumer.gender ?? "", StylistsUserCollectionKeys.imageURL: consumer.imageURL ?? "", StylistsUserCollectionKeys.joinedDate: Date.getISOTimestamp()]) { (error) in
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
    
    static func getProviders(completionHandler: @escaping([ServiceSideUser]?, Error?) -> Void) {
        DBService.firestoreDB.collection(ServiceSideUserCollectionKeys.serviceProvider)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completionHandler(nil, error)
                } else if let snapshot = snapshot {
                    completionHandler(snapshot.documents.map{ServiceSideUser(dict: $0.data())}, nil)
                }
        }
    }
    
    
    static func postProviderRating(ratings: Ratings, completionHandler: @escaping (Error?) -> Void) {
        
        let rateId = firestoreDB.collection(ServiceSideUserCollectionKeys.serviceProvider)
            .document(ratings.userId)
            .collection(RatingsCollectionKeys.ratings).document().documentID
        
        
        firestoreDB.collection(ServiceSideUserCollectionKeys.serviceProvider)
            .document(ratings.userId)
            .collection(RatingsCollectionKeys.ratings)
            .document().setData([
                        RatingsCollectionKeys.ratingId : rateId,
                        RatingsCollectionKeys.value: ratings.value,
                        RatingsCollectionKeys.raterId: ratings.raterId,
                        RatingsCollectionKeys.userId: ratings.userId

            ]) { (error) in
                if let error = error {
                    completionHandler(error)
                    print("there was an error with the postProviderRating: \(error.localizedDescription)")
                } else {
                    completionHandler(nil)
                    print("rating posted successfully to reference: \(ratings.ratingId)")
                }
        }
    }
    
    static func postProviderReview(reviews: Reviews, completionHandler: @escaping (Error?) -> Void) {
        
        let reviewId = firestoreDB.collection(ServiceSideUserCollectionKeys.serviceProvider)
            .document(reviews.reviewStylist)
            .collection(ReviewsCollectionKeys.reviews).document().documentID
        
        firestoreDB.collection(ServiceSideUserCollectionKeys.serviceProvider)
        .document(reviews.reviewerId)
        .collection(ReviewsCollectionKeys.reviews)
        .document().setData([
            ReviewsCollectionKeys.reviewerId  : reviews.reviewerId,
            ReviewsCollectionKeys.createdDate : reviews.createdDate,
            ReviewsCollectionKeys.description : reviews.description,
            ReviewsCollectionKeys.ratingId : reviews.ratingId,
            ReviewsCollectionKeys.value : reviews.value,
            ReviewsCollectionKeys.reviewId : reviewId,
            ReviewsCollectionKeys.reviewStylist : reviews.reviewStylist
        ]) { (error) in
            if let error = error {
                completionHandler(error)
                print("there was an error with the postProviderReview: \(error.localizedDescription)")
            } else {
                completionHandler(nil)
                print("review posted successfully to rating reference: \(reviews.ratingId)")
            }
        }
    }
    
    static func getServices(completionHandler: @escaping ([Service]?, Error?) -> Void) {
        firestoreDB.collection("stockServices")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completionHandler(nil, error)
                } else {
                    let services = snapshot?.documents.map { Service(dict: $0.data()) }
                    completionHandler(services, nil)
                }
        }
    }
    
    static func addToFavorites(id: String,prodider: ServiceSideUser, completionHandler: @escaping(Error?) -> Void) {
        firestoreDB.collection(StylistsUserCollectionKeys.stylistUser)
        .document(id)
        .collection("userFavorites")
        .addDocument(data: ["providerId" : prodider.userId,
                            "createdAt" : Date.getISOTimestamp(),
        ]) { (error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }
}



