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
    let email = "allooo@gmail.com"
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
}
  




