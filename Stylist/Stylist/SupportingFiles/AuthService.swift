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
  func didCreateServiceProviderNewAccount(_ authservice: AuthService,accountState:AccountState,serviceProvider:ServiceSideUser)
  func didCreateConsumerAcoount(_ authService: AuthService, accountState:AccountState,consumer:StylistsUser)
  
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
  
  public func createNewAccount(email: String, password: String,accountState:AccountState) {
    Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
      if let error = error {
        self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
        return
      } else if let authDataResult = authDataResult {
        // update displayName for auth user
        let request = authDataResult.user.createProfileChangeRequest()

        request.commitChanges(completion: { (error) in
          if let error = error {
            self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
            return
          }
        })
        
        let authUser = authDataResult.user
        guard let email = authUser.email else {
          print("no email found")
          return
        }
        if accountState == .consumer {
          let consumer = StylistsUser(userId: authUser.uid, firstName: nil, lastName: nil, email: email, gender: nil, address: nil, imageURL: nil, joinedDate: Date.getISOTimestamp(),type: "consumer")
          DBService.createConsumerDatabaseAccount(consumer: consumer, completionHandle: { (error) in
            if let error = error {
              self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
            }
            self.authserviceCreateNewAccountDelegate?.didCreateConsumerAcoount(self, accountState: .consumer, consumer: consumer)
          })
        }
        else if accountState == .serviceProvider {
          let serviceProvider = ServiceSideUser(userId: authUser.uid, firstName: nil, lastName: nil, email: email, joinedDate: Date.getISOTimestamp(), gender: nil, isCertified: false, imageURL: nil, bio: nil, licenseNumber: nil, licenseExpiryDate: nil,type: "serviceProvider")
          
          DBService.CreateServiceProvider(serviceProvider: serviceProvider, completionHandler: { (error) in
            if let error = error {
              print("there was an error: \(error.localizedDescription)")
              self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
            }else {
              self.authserviceCreateNewAccountDelegate?.didCreateServiceProviderNewAccount(self, accountState: .serviceProvider, serviceProvider: serviceProvider)
            }
          })

        }
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
