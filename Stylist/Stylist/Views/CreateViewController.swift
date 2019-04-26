//
//  CreateViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/5/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class CreateViewController: BaseViewController {

  @IBOutlet weak var emailTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  @IBOutlet weak var accountTypeControl: UISegmentedControl!
  
 
  let authService = AuthService()
  
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
   authService.createNewAccount(email: email, password: password)
  
   
  }
  
  @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
    
  }
  
  private func presentOnboardingScreen(){
     let onbordingScreen = UIStoryboard(name: "Entrance", bundle: nil).instantiateViewController(withIdentifier: "OnboardingTableViewController")
    let navigationController = UINavigationController(rootViewController: onbordingScreen)
    
    navigationController.navigationBar.barTintColor = .clear
    navigationController.navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
    navigationController.navigationBar.isTranslucent = true
    navigationController.navigationBar.shadowImage = UIImage()
    self.present(navigationController, animated: true, completion: nil)
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
  
  
  func didCreateConsumerAcoount(_ authService: AuthService, consumer: StylistsUser) {
  showAlert(title: "Account Sucessfully  Created", message: "you sucessfully created your account", actionTitle: "Ok")
    presentOnboardingScreen()
    
  }
  
  
}
