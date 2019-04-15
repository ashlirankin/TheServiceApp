//
//  FirebaseTests.swift
//  FirebaseTests
//
//  Created by Ashli Rankin on 4/5/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//


import XCTest
@testable import Stylist
import Firebase
import FirebaseAuth

class FirebaseTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    FirebaseApp.configure()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testcreateAuthUser(){
    let email = "jianting@gmail.com"
    let password = "123456"
    let exp = expectation(description: "create user account")
    
    Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
      if let error = error {
        XCTFail("an error occured: \(error.localizedDescription)")
      }
      else if let  authDataResult = authDataResult{
        XCTAssertEqual(authDataResult.user.email, email, "email should be the same")
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testcreateADatabaseUser(){
    let exp = expectation(description: "create a firebase auth user")
    
    guard let authUser = Auth.auth().currentUser else {
      XCTFail("no auth user was found")
      return
    }
    
    print("logged user email is \(authUser.email ?? "no email")")
    print("user uid is \(authUser.uid)")
    
    DBService.firestoreDB.collection("testCollection")
      .document(authUser.uid)
      .setData(["firstName" : "Ashli"]) { (error) in
        if let error = error {
          XCTFail("failed create test db user: \(error.localizedDescription)")
        }
        exp.fulfill()
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testToCreateCollection(){
   
    enum AccountType {
      case serviceProvider
      case consumer
    }
  
  
  guard let currentUser =  Auth.auth().currentUser else {
      XCTFail("no current user found")
      return
    }
    let accountState:AccountType = .serviceProvider
  let exp = expectation(description: "create a user collection")
    
    if accountState == .consumer {
      DBService.firestoreDB.collection("consumer").document(currentUser.uid)
        .setData(["firstName": "Matty",
                  "lastName":"Rankin",
                  "accountType":"consumer",
          "userId":currentUser.uid]) { (error) in
                    if let error = error {
                      XCTFail("there was an error updating user: \(error.localizedDescription)")
                    }
                    
      }
      exp.fulfill()
      wait(for: [exp], timeout: 3.0)
    }
    if accountState == .serviceProvider{
      
      DBService.firestoreDB.collection("serviceProvider").document(currentUser.uid)
        .setData(["firstName": "Ashli",
                  "lastName":"Rankin",
                  "accountType":"serviceProvider",
                  "provider":currentUser.uid]) { (error) in
                    
                    if let error = error {
                      XCTFail("there was an error updating user: \(error.localizedDescription)")
                    }
      }
      exp.fulfill()
      wait(for: [exp], timeout: 3.0)
    }
  }
  
  func testCreateCurrentDateCollection(){
    let currentDay = "Monday"
    let serviceProviderId = "2WJwGOzfxDgBiBMbdj95fIelmFV2"
    let exp = expectation(description: "create date avalibility")
    DBService.firestoreDB.collection("serviceProvider").document(serviceProviderId).collection("avalibility").addDocument(data: ["date" : currentDay]) { (error) in
      if let error = error {
        XCTFail("could not create avalibility:\(error.localizedDescription)")
      }
      exp.fulfill()
      
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testCreateAnAvalibility(){
    
    let serviceProviderId = "wuqEsmjA1COFlz9BaFS86QWHBSl2"
    let avalibleHours = ["8:00am","9:00am","11:00pm","12:00pm","4:00pm","6:00pm","8:00pm"]
    let currentDate = "Friday"
    let exp = expectation(description: "creating the hours that provider is avalible")
   
    DBService.firestoreDB.collection("serviceProvider")
      .document(serviceProviderId).collection("avalibility").addDocument(data: ["avalibleHours" : avalibleHours,"currentDate":currentDate]) { (error) in
        if let error = error {
          XCTFail("could not update your avalible hours:\(error.localizedDescription)")
        }
        exp.fulfill()
    }
    
    wait(for: [exp], timeout: 3.0)
    
  }
  
  func testCreateReview(){
    let reviewDescription = """
We arrived at Laguna Hotel yesterday, hotel is the wrong word more like Laguna Nursing home. The rooms were very dated and you could not open the en-suite door without hitting the TV on the wall.
    
    Breakfast was an experience, sausages/orange juice were very cheap and not nice, I have never seen fried bread orange before little worrying!! I would not recommend anyone to stay at this hotel unless they’re over 80!!”
"""
    
    let rate = 1
    let serviceProviderId = "2WJwGOzfxDgBiBMbdj95fIelmFV2"

    let exp = expectation(description: "create a rating of service provider")
    
    DBService.firestoreDB.collection("serviceProvider").document(serviceProviderId).collection("reviews").addDocument(data: [ReviewsCollectionKeys.description : reviewDescription,ReviewsCollectionKeys.ratingId:String(rate)]) { (error) in
      if let error = error {
        XCTFail("there was an error posting you review:\(error.localizedDescription)")
      }
  exp.fulfill()
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testCreateStockCategories(){
    let collectionName = "stockServices"
    let exp = expectation(description: "create stock ")
    DBService.firestoreDB.collection(collectionName).addDocument(data: ["jobTitle":"Makeup Artist"]) { (error) in
      if let error = error {
        XCTFail("could not create service:\(error.localizedDescription)")
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testAddingStockServices(){
    let stockService = ["Cuts", "Relaxers", "Perms", "Colors", "Shampoo", "Conditioning", "Curling", "Reconstructing", "Weaving", "Waving","Manicures", "Pedicures", "Polish", "Sculptured nails","European facials", "Body waxing", "Massage"]
    let serviceId = "HHsx5njomzEVFDmkmlNN"
    let exp = expectation(description: "set stock services offered")
    DBService.firestoreDB.collection("stockServices").document(serviceId).updateData(["services" : stockService]) { (error) in
      if let error = error {
        XCTFail("could not update services:\(error.localizedDescription)")
      }
      exp.fulfill()
      
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  
  func testQureyForBarber(){
    let jobTitle = "Barber"
    let exp = expectation(description: "get data of barber")
    
    DBService.firestoreDB.collection("stockServices").whereField("jobTitle", isEqualTo: jobTitle).getDocuments { (snapshot, error) in
      if let error = error {
        XCTFail("failed to get job title:\(error.localizedDescription)")
      }else if let snapshot = snapshot {
        if snapshot.documents.isEmpty{
          XCTFail("no results found")
        }
        exp.fulfill()
          
        }
      }
    wait(for: [exp], timeout: 3.0)
    }
  }

  




