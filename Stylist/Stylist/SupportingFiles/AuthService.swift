//
//  AuthService.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/8/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol AuthServiceCreateNewAccountDelegate: AnyObject {
  func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error)
  func didCreateConsumerAcoount(_ authService: AuthService,consumer:StylistsUser)
  
}

protocol AuthServiceExistingAccountDelegate: AnyObject {
  func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error)
  func didSignInToExistingAccount(_ authservice: AuthService, user: User)
}
protocol AuthServiceSignOutDelegate: AnyObject {
  func didSignOutWithError(_ authservice: AuthService, error: Error)
  func didSignOut(_ authservice: AuthService)
}

final class AuthService {
  weak var authserviceCreateNewAccountDelegate: AuthServiceCreateNewAccountDelegate?
  weak var authserviceExistingAccountDelegate: AuthServiceExistingAccountDelegate?
  weak var authserviceSignOutDelegate: AuthServiceSignOutDelegate?
  
  public func createNewAccount(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
      if let error = error {
        self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
        return
      } else if let authDataResult = authDataResult {
        let newUser = StylistsUser(userId: authDataResult.user.uid,
                                   firstName: nil,
                                   lastName: nil,
                                   email: authDataResult.user.email!,
                                   gender: nil,
                                   address: nil,
                                   imageURL: nil,
                                   joinedDate: Date.getISOTimestamp(),
                                   street: nil,
                                   city: nil,
                                   state: nil,
                                   zip: nil)
        DBService.createConsumerDatabaseAccount(consumer: newUser, completionHandler: { (error) in
            if let error = error {
                self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
            } else {
                self.authserviceCreateNewAccountDelegate?.didCreateConsumerAcoount(self, consumer: newUser)
            }
        })
        
      }
    }
  }
  public func signInExistingAccount(email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
      if let error = error {
        self.authserviceExistingAccountDelegate?.didRecieveErrorSigningToExistingAccount(self, error: error)
      } else if let authDataResult = authDataResult {
        self.authserviceExistingAccountDelegate?.didSignInToExistingAccount(self, user: authDataResult.user)
      }
    }
  }
  
  public func getCurrentUser() -> User? {
    return Auth.auth().currentUser
  }

  public func signOut(){
    do {
      try Auth.auth().signOut()
      authserviceSignOutDelegate?.didSignOut(self)
    } catch {
      authserviceSignOutDelegate?.didSignOutWithError(self, error: error)
    }
    
  }
}
