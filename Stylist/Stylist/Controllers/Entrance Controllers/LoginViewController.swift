//
//  LoginViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/5/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: BaseViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  
  let authService = AuthService()
  override func viewDidLoad() {
        super.viewDidLoad()

      authService.authserviceExistingAccountDelegate = self
    createGradientView()
    emailTextField.delegate = self
    passwordTextfield.delegate = self
    }
  

  @IBAction func loginButtonPressed(_ sender: UIButton) {
    guard let email = emailTextField.text,
      let password = passwordTextfield.text else {
        showAlert(title: "All fields required", message: "you must enter your username and password", actionTitle: "OK")
        return}
    
    authService.signInExistingAccount(email: email, password: password)
    
  }
  
  func presentTabbarController(){
   
      guard let userTabbarController = UIStoryboard.init(name: "User", bundle: nil).instantiateViewController(withIdentifier: "UserTabBarController") as? UITabBarController else {return}
      self.present(userTabbarController, animated: true, completion: nil)
    
  }
  
  
 
}
extension LoginViewController:AuthServiceExistingAccountDelegate {
  func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error) {
    showAlert(title: "Sign-In Error", message: "There was an error signing into you account", actionTitle: "TryAgain")
  }
  
  func didSignInToExistingAccount(_ authservice: AuthService, user: User) {

    presentTabbarController()
  }
  
  
}
extension LoginViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    resignFirstResponder()
    return true
    
  }
}
