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
    
    @IBOutlet weak var profileImageButton: CircularButton!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var streetTextfield: UITextField!
    @IBOutlet weak var genderControl: UISegmentedControl!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var zipcodeTextfield: UITextField!
    @IBOutlet weak var stateTextfield: UITextField!
    
    var postButton: UIBarButtonItem!
    let authService = AuthService()
    var gender = "male"
    var selectedImage: UIImage?
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        postButton = UIBarButtonItem(title: "Set Up", style: .plain, target: self, action: #selector(setupButtonPressed))
        self.navigationItem.rightBarButtonItem = postButton
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
        updateUserInformation(collectionName: StylistsUserCollectionKeys.stylistUser, userId: currentUser.uid)
    }
    
    func updateUserInformation(collectionName:String,userId:String){
        guard let currentUser = AuthService().getCurrentUser() else {
            showAlert(title: "No logged User", message: nil, actionTitle: "Ok")
            return
        }
        guard let imageData = selectedImage?.jpegData(compressionQuality: 1.0),
            let firstName = firstNameTextfield.text,
            let lastName = lastNameTextfield.text,
            let street = streetTextfield.text,
            let city = cityTextfield.text,
            let state = stateTextfield.text else {
                showAlert(title: "All Fields Required", message: "You must provide all info", actionTitle: "Ok")
                return
        }
        
        StorageService.postImage(imageData: imageData, imageName: "“profileImages/\(currentUser.uid)”") { [weak self] (error, imageURL) in
            if let error = error {
                self?.showAlert(title: "Error Saving Profile Image", message: error.localizedDescription, actionTitle: "Ok")
            } else if let imageURL = imageURL {
                let request = currentUser.createProfileChangeRequest()
                request.photoURL = imageURL
                request.commitChanges(completion: { [weak self] (error) in
                    if let error = error {
                        self?.showAlert(title: "Error Saving Account Info", message: error.localizedDescription, actionTitle: "Ok")
                    }
                })
                
                DBService.firestoreDB.collection(collectionName)
                    .document(userId)
                    .updateData([StylistsUserCollectionKeys.firstName : firstName,
                                 StylistsUserCollectionKeys.lastName : lastName,
                                 StylistsUserCollectionKeys.city : city,
                                 StylistsUserCollectionKeys.street : street,
                                 StylistsUserCollectionKeys.state : state,
                                 StylistsUserCollectionKeys.gender : self?.gender,
                                 StylistsUserCollectionKeys.imageURL : imageURL.absoluteString
                    ]) { (error) in
                        if let error = error {
                            self?.showAlert(title: "Error Updating Info", message: error.localizedDescription, actionTitle: "Ok")
                        } else {
                            let storyboard = UIStoryboard(name: "User", bundle: nil)
                            let initialTab = storyboard.instantiateViewController(withIdentifier: "UserTabBarController")
                            self?.present(initialTab, animated: true)
                        }
                }
            }
        }
    }
    
    @IBAction func addProfileImagePressed(_ sender: UIButton) {
        let actionTitles = UIImagePickerController.isSourceTypeAvailable(.camera) ? ["Photo Library", "Camera"] : ["Photo Library"]
        
        showActionSheet(title: nil, message: nil, actionTitles: actionTitles, handlers: [{ [unowned self] photoLibraryAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
            }, { cameraAction  in
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true)
            }
            ])
    }
    
    @IBAction func genderSegmentedControl(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0:
            gender = "male"
        case 1:
            gender = "female"
        default:
            break
        }
    }
    
}

extension OnboardingTableViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension OnboardingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            showAlert(title: "Image Not Available", message: nil, actionTitle: "OK")
            return
        }
        let size = CGSize(width: 500, height: 500)
        let resizedImage = Toucan.Resize.resizeImage(originalImage, size: size)
        selectedImage = resizedImage
        profileImageButton.setImage(resizedImage, for: .normal)
        dismiss(animated: true)
    }
}
