//
//  LoginViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/5/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  
  
  let authService = AuthService()
  var accountState:AccountState = .serviceProvider
  override func viewDidLoad() {
        super.viewDidLoad()

      authService.authserviceExistingAccountDelegate = self
    }
    
  @IBAction func loginButtonPressed(_ sender: UIButton) {
    guard let email = emailTextField.text,
      let password = passwordTextfield.text else {
        showAlert(title: "All fields required", message: "you must enter your username and password", actionTitle: "OK")
        return}
    
    authService.signInExistingAccount(email: email, password: password)
  
    presentTabbarController()
  }
  
  @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
     
    case 0:
      accountState = .serviceProvider
    case 1:
      accountState = .consumer
    default:
      print("c")
    }
  }
  
  func presentTabbarController(){
    if accountState == .consumer {
      guard let userTabbarController = UIStoryboard.init(name: "User", bundle: nil).instantiateViewController(withIdentifier: "UserTabBarController") as? UITabBarController else {return}
      self.present(userTabbarController, animated: true, completion: nil)
      
    }else if accountState == .serviceProvider{
      
      guard let serviceTabbarController = UIStoryboard.init(name: "ServiceProvider", bundle: nil).instantiateViewController(withIdentifier: "ServiceTabBar") as? UITabBarController else {return}
      present(serviceTabbarController, animated: true, completion: nil)
      
    }
  }
  
 
}
extension LoginViewController:AuthServiceExistingAccountDelegate {
  func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error) {
    showAlert(title: "Sign-In Error", message: "There was an error signing into you account", actionTitle: "TryAgain")
  }
  
  func didSignInToExistingAccount(_ authservice: AuthService, user: User) {

   
  }
  
  
}
