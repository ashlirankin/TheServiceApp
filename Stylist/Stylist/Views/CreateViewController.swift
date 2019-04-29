//
//  CreateViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/5/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class CreateViewController: BaseViewController {
<<<<<<< HEAD

  @IBOutlet weak var emailTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  let authService = AuthService()
  
  override func viewDidLoad() {
        super.viewDidLoad()
   authService.authserviceCreateNewAccountDelegate = self
    emailTextfield.delegate = self
    passwordTextfield.delegate = self
=======
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authService.authserviceCreateNewAccountDelegate = self
>>>>>>> 4ca2bd687cda3169766801fe726b7b9c8d440d46
    }
    
    @IBAction func backToLoginButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func createProfilePressed(_ sender: UIButton) {
        guard let email = emailTextfield.text,
            let password =  passwordTextfield.text else {
                showAlert(title: "Field Required", message: "you must enter your email and password", actionTitle: "Ok")
                return
        }
        authService.createNewAccount(email: email, password: password)
    }
<<<<<<< HEAD

   authService.createNewAccount(email: email, password: password)
  }

}

extension CreateViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
    
  }
=======
    
    private func presentOnboardingScreen(){
        let onbordingScreen = UIStoryboard(name: "Entrance", bundle: nil).instantiateViewController(withIdentifier: "OnboardingTableViewController") as! OnboardingTableViewController
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
>>>>>>> 4ca2bd687cda3169766801fe726b7b9c8d440d46
}

extension CreateViewController:AuthServiceCreateNewAccountDelegate{
  func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
       showAlert(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
  }
  
  func presentOnboardingScreen(){
    guard let onbordingScreen = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "UserTabBarController") as? UserTabBarController else {
      print("No tabbar found")
      return
    }
<<<<<<< HEAD
    present(onbordingScreen, animated: true, completion: nil)
  }
  
  func didCreateConsumerAcoount(_ authService: AuthService, consumer: StylistsUser) {
    showAlert(title: "Account Successfully Created", message: "You sucessfully created your account", style: .alert) { (action) in
      self.presentOnboardingScreen()
=======
    
    func didCreateConsumerAcoount(_ authService: AuthService, consumer: StylistsUser) {
        showAlert(title: "Account Successfully Created", message: "You sucessfully created your account", style: .alert) { (action) in
            self.presentOnboardingScreen()
        }
>>>>>>> 4ca2bd687cda3169766801fe726b7b9c8d440d46
    }
}
}
