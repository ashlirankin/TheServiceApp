//
//  LoginViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/5/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        authService.authserviceExistingAccountDelegate = self
        createGradientView()
        setupTextfields()
        keyboardHandle()
    }
    
    private func setupTextfields() {
        emailTextField.delegate = self
        passwordTextfield.delegate = self
    }
    
    private func keyboardHandle() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func keyboardHandleTap(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextfield.text else {
                showAlert(title: "All fields required", message: "Please enter your email and password", actionTitle: "OK")
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
        showAlert(title: "Sign-In Error", message: error.localizedDescription, actionTitle: "TryAgain")
    }
    
    func didSignInToExistingAccount(_ authservice: AuthService, user: User) {
        presentTabbarController()
    }
}


extension LoginViewController: UITextFieldDelegate {
    @objc func keyBoardWillChange(notification: Notification) {
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -130
        } else {
            view.frame.origin.y = 0
        }
    }
}
