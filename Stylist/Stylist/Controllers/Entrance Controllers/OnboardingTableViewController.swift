//
//  OnboardingTableViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/9/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Toucan

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
  let storageService = StorageService.self
  var imagePickerController: UIImagePickerController!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    setDelegates()
    postButton = UIBarButtonItem(title: "Set Up", style: .plain, target: self, action: #selector(setupButtonPressed))
   self.navigationItem.rightBarButtonItem = postButton
    setUpImagePickerController()
    }
  
  override func viewDidLayoutSubviews() {
    profileImage.layer.cornerRadius = profileImage.frame.width/2
    profileImage.layer.masksToBounds = true
    profileImage.layer.borderWidth = 4
  }
  
  private func setUpImagePickerController(){
    imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
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
    postButton.isEnabled = false
  
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
    let field = [StylistsUserCollectionKeys.firstName:firstName,
                 StylistsUserCollectionKeys.lastName:lastName,
                 StylistsUserCollectionKeys.city:city,StylistsUserCollectionKeys.state:state,StylistsUserCollectionKeys.street:street]
    
    updateUserfield(collectionName: collectionName, userId: userId, field: field)

  }
  
  private func presentTabbarController(){
    guard let tabbarController = UIStoryboard.init(name: "User", bundle: nil).instantiateViewController(withIdentifier: "UserTabBarController") as? UITabBarController else {return}
    present(tabbarController, animated: true, completion: nil)
  }
  
  private func showImagePickerController(){
    self.present(imagePickerController, animated: true, completion: nil)
  }
  
  private func setUpActionSheet(){
    let actionSheet = UIAlertController(title: "Change Profile Image", message: "How would you like to change your profile image", preferredStyle: .actionSheet)
    
    let cameraAction = UIAlertAction(title: "Camera", style: .default) { (camera) in
      if !UIImagePickerController.isSourceTypeAvailable(.camera){
        camera.isEnabled = false
      }
      self.showImagePickerController()
    }
    
    let photoGalleryAction = UIAlertAction(title: "Photo Gallery", style: .default) { (photoGallery) in
      self.showImagePickerController()
    }
    
    actionSheet.addAction(cameraAction)
    actionSheet.addAction(photoGalleryAction)
    
    
    self.present(actionSheet, animated: true, completion: nil)
    
  }
  
  
  @IBAction func addProfileImagePressed(_ sender: UIButton) {
   setUpActionSheet()
    
  }
  
  private func updateUserfield(collectionName:String,userId:String,field:[String:Any]){
DBService.firestoreDB.collection(collectionName).document(userId).updateData(field) { (error) in
      if let error = error {
        self.showAlert(title: "Error", message: "there was an error trying to update your field:\(error.localizedDescription)", actionTitle: "Try Again")
      }else{
        self.presentTabbarController()
        
      }
      
    }
  }
  @IBAction func genderControlPressed(_ sender: UISegmentedControl) {
    guard let currentUser = authService.getCurrentUser() else {return}
    if sender.selectedSegmentIndex == 0 {
      
      let field = [StylistsUserCollectionKeys.gender:"male"]
      updateUserfield(collectionName: StylistsUserCollectionKeys.stylistUser, userId: currentUser.uid, field:field)
      
    }else if sender.selectedSegmentIndex == 1 {
      let field = [StylistsUserCollectionKeys.gender:"female"]
      updateUserfield(collectionName: StylistsUserCollectionKeys.stylistUser, userId: currentUser.uid, field:field)
     
    }
  }
}

extension OnboardingTableViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
extension OnboardingTableViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage , let currentUser = authService.getCurrentUser() else {return}
    
    let resizedImage = Toucan(image: image).resize(CGSize(width: 500, height: 500)).image
    
    guard let imageData = resizedImage?.jpegData(compressionQuality: 0.5) else {return}
    
    storageService.postImage(imageData: imageData, imageName: "profileImages/\(currentUser.uid)") { [weak self] (error, url) in
      if let error = error {
        
        self?.showAlert(title: "Error", message: "there was an error updating your profile image:\(error.localizedDescription)", actionTitle: "Try Again")
        
      }else if let url = url {
        let field = [StylistsUserCollectionKeys.imageURL:url.absoluteString]
        self?.updateUserfield(collectionName: StylistsUserCollectionKeys.stylistUser, userId: currentUser.uid, field: field)
      }
      self?.profileImage.setImage(resizedImage, for: .normal)
    }
    
    dismiss(animated: true, completion: nil)
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
}
