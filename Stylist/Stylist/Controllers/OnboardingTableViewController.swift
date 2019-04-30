//
//  OnboardingTableViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/9/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class OnboardingTableViewController: UITableViewController {

  @IBOutlet weak var profileImage: UIButton!
  @IBOutlet weak var lastNameTextfield: UITextField!
  @IBOutlet weak var firstNameTextfield: UITextField!
  @IBOutlet weak var streetTextfield: UITextField!
  @IBOutlet weak var genderControl: UISegmentedControl!
  @IBOutlet weak var cityTextfield: UITextField!
  @IBOutlet weak var zipcodeTextfield: UITextField!
  @IBOutlet weak var stateTextfield: UITextField!
  
  var postButton: UIBarButtonItem!
  let authService = AuthService()
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
    setDelegates()
    postButton = UIBarButtonItem(title: "Set Up", style: .plain, target: self, action: #selector(setupButtonPressed))
   self.navigationItem.rightBarButtonItem = postButton
    }
  
  override func viewDidLayoutSubviews() {
    profileImage.layer.cornerRadius = profileImage.frame.width/2
    profileImage.layer.masksToBounds = true
    profileImage.layer.borderWidth = 4
  }
  
  private func setDelegates(){
    lastNameTextfield.delegate = self
    firstNameTextfield.delegate = self
    streetTextfield.delegate = self
    cityTextfield.delegate = self
    stateTextfield.delegate = self
    zipcodeTextfield.delegate = self
    
  }
  
  @objc func setupButtonPressed(){
    guard let currentUser = authService.getCurrentUser() else {
      print("no current user found")
      return
    }
    let collectionName = "stylistUser"
  updateUserInformation(collectionName: collectionName, userId: currentUser.uid)
    
  }
  
  func updateUserInformation(collectionName:String,userId:String){
    guard let firstName = firstNameTextfield.text,
      let lastName = lastNameTextfield.text,
      let street = streetTextfield.text,
      let city = cityTextfield.text,
      let state = stateTextfield.text else {
        showAlert(title: "All Fields Required", message: "You must provide all info", actionTitle: "Ok")
        return
        
    }
    DBService.firestoreDB.collection(collectionName).document(userId).setData([StylistsUserCollectionKeys.firstName:firstName,
                                                                                  StylistsUserCollectionKeys.lastName:lastName,
                                                                                  StylistsUserCollectionKeys.city:city,StylistsUserCollectionKeys.state:state,StylistsUserCollectionKeys.street:street]) { (error) in
                                                                                    if let error = error {
                                                                                      print("there was an error updating your information: \(error.localizedDescription)")
                                                                                    }
    }
  }
  @IBAction func addProfileImagePressed(_ sender: UIButton) {
   
    print("add pressed")
    
  }
  
}
extension OnboardingTableViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
