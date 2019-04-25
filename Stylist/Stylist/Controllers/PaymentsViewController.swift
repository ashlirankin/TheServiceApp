//
//  PaymentsViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/22/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class PaymentsViewController: UIViewController {
  @IBOutlet weak var priceInfoLabel: UILabel!
  @IBOutlet weak var creditCardNumberTextfield: UITextField!
  @IBOutlet weak var expirationDateTextfield: UITextField!
  @IBOutlet weak var nameTextfield: UITextField!
  @IBOutlet weak var confirmButton: UIButton!
  let authService = AuthService()
  
  var amountDue = Int()
  
  override func viewDidLoad() {
        super.viewDidLoad()

    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backButtonPressed))
    setDelegates()
    }
  
  func setDelegates(){
    creditCardNumberTextfield.delegate = self
    expirationDateTextfield.delegate = self
    nameTextfield.delegate = self
    
    
  }
  @objc func backButtonPressed(){
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func confirmButtonPressed(_ sender: UIButton) {
    guard let cardNumber = creditCardNumberTextfield.text,
    let currentUserId = authService.getCurrentUser()?.uid,
    let cardHolderName = nameTextfield.text,
    let expiryDate = expirationDateTextfield.text else {
      showAlert(title: "All fields Required", message: "All fields are required", actionTitle: "Ok")
      return
    }
    let documentId = DBService.generateDocumentId
    
    let information = ["cardNumber":cardNumber,"cardHolderName":cardHolderName,"userId":currentUserId,"documentId":documentId,"cardExpiryDate":expiryDate]
    
    DBService.createUserWallet(userId: currentUserId, information: information, documentId: documentId) { [weak self] (error) in
      if let error = error {
        self?.showAlert(title: "Error", message: "Could not save payment information: \(error.localizedDescription)", actionTitle: "TryAgain")
      }
    }
    dismiss(animated: true, completion: nil)
  }
  
  

}
extension PaymentsViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    textField.resignFirstResponder()
    return true
  }
}
