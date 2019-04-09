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
  @IBOutlet weak var addressTextfield: UITextField!
  override func viewDidLoad() {
        super.viewDidLoad()
    
    lastNameTextfield.delegate = self
    firstNameTextfield.delegate = self
    addressTextfield.delegate = self
      
    }
  override func viewDidLayoutSubviews() {
    
    profileImage.layer.cornerRadius = profileImage.frame.width/2
    profileImage.layer.masksToBounds = true
  }

  @IBAction func addProfileImagePressed(_ sender: UIButton) {
   
    print("add pressed")
    
  }
  
}
extension OnboardingTableViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
  }
}
