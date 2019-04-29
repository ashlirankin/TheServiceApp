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
  let authService = AuthService()
  
  override func viewDidLoad() {
        super.viewDidLoad()
   authService.authserviceCreateNewAccountDelegate = self
    emailTextfield.delegate = self
    passwordTextfield.delegate = self
    }
    
  @IBAction func createProfilePressed(_ sender: UIButton) {
    guard let email = emailTextfield.text,
    let password =  passwordTextfield.text else {
      showAlert(title: "Field Required", message: "you must enter your email and password", actionTitle: "Ok")
      return
    }
<<<<<<< HEAD
    
   authService.createNewAccount(email: email, password: password)
  }
=======
   authService.createNewAccount(email: email, password: password)
  }
  
  @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
    
  }
  
    private func presentOnboardingScreen(){
        let onbordingScreen = UIStoryboard(name: "Entrance", bundle: nil).instantiateViewController(withIdentifier: "OnboardingTableViewController") as! OnboardingTableViewController
        let navigationController = UINavigationController(rootViewController: onbordingScreen)
        
        navigationController.navigationBar.barTintColor = .clear
        navigationController.navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.shadowImage = UIImage()
        self.present(navigationController, animated: true, completion: nil)
    }
>>>>>>> 5e319b2a998477c79ce61077c27a5c1732fe72ad
}

extension CreateViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
    
  }
  
  
}
extension CreateViewController:AuthServiceCreateNewAccountDelegate{
<<<<<<< HEAD
  func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
    showAlert(title: "Error", message: "There was an error creating your account", actionTitle: "Ok")
  }
  
  
  func presentOnboardingScreen(){
    guard let onbordingScreen = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "UserTabBarController") as? UserTabBarController else {
      print("No tabbar found")
      return
    }
    present(onbordingScreen, animated: true, completion: nil)
  }
  
  func didCreateConsumerAcoount(_ authService: AuthService, consumer: StylistsUser) {
    
    presentOnboardingScreen()
=======
    func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
    }
>>>>>>> 5e319b2a998477c79ce61077c27a5c1732fe72ad
    
    func didCreateConsumerAcoount(_ authService: AuthService, consumer: StylistsUser) {
//        showAlert(title: "Account Sucessfully  Created", message: "you sucessfully created your account", actionTitle: "Ok")
        showAlert(title: "Account Successfully Created", message: "You sucessfully created your account", style: .alert) { (action) in
            self.presentOnboardingScreen()
        }
    }
}
