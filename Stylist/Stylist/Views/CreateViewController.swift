//
//  CreateViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/5/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

  @IBOutlet weak var emailTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  @IBOutlet weak var accountTypeControl: UISegmentedControl!
  
  
  let authService = AuthService()
  var accountState:AccountState = .serviceProvider
  
  override func viewDidLoad() {
        super.viewDidLoad()
    authService.authserviceCreateNewAccountDelegate = self
  
    }
    
  @IBAction func createProfilePressed(_ sender: UIButton) {
    guard let email = emailTextfield.text,
    let password =  passwordTextfield.text else {
      showAlert(title: "Field Required", message: "you must enter your email and password", actionTitle: "Ok")
      return
    }
   authService.createNewAccount(email: email, password: password, accountState: accountState)
  
    if accountState == . consumer {
      guard let consumerInterface = UIStoryboard.init(name: "User", bundle: nil).instantiateViewController(withIdentifier: "UserTabBarController") as? UITabBarController else {fatalError()}
      self.present(consumerInterface, animated: true, completion: nil)
    }else if accountState == .serviceProvider {
      guard let serviceProviderInterface = UIStoryboard.init(name: "ServiceProvider", bundle: nil).instantiateViewController(withIdentifier: "ServiceTabBar") as? UITabBarController else {fatalError()}
      self.present(serviceProviderInterface, animated: true, completion: nil)
    }
  }
  
  @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex{
    case 0:
     self.accountState = .serviceProvider
    case 1:
      self.accountState = .consumer
    default:
      print("c")
    }
  }
}
extension CreateViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
    
  }
  
}
extension CreateViewController:AuthServiceCreateNewAccountDelegate{
  func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
    showAlert(title: "Error", message: "There was an error creating your account", actionTitle: "Ok")
  }
  
  func didCreateServiceProviderNewAccount(_ authservice: AuthService, accountState: AccountState, serviceProvider: ServiceSideUser) {
   showAlert(title: "Account Sucessfully  Created", message: "you sucessfully created you service provider account", actionTitle: "Ok")
  }
  
  func didCreateConsumerAcoount(_ authService: AuthService, accountState: AccountState, consumer: StylistsUser) {
  showAlert(title: "Account Sucessfully  Created", message: "you sucessfully created your account", actionTitle: "Ok")
  }
  
  
}
