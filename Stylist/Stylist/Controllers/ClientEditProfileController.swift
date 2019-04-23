//
//  ClientEditProfileController.swift
//  Stylist
//
//  Created by Jian Ting Li on 4/10/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Toucan

class ClientEditProfileController: UITableViewController {
    
    @IBOutlet weak var profileImageView: CircularImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    public var stylistUser: StylistsUser!
    
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        setupUI()
    }
    
    private func setupUI() {
        if let imageURL = stylistUser.imageURL {
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: URL(string: imageURL), placeholder: #imageLiteral(resourceName: "placeholder.png"))
        }
        firstNameTextField.text = stylistUser.firstName ?? ""
        lastNameTextField.text = stylistUser.lastName ?? ""
    }
    
    @IBAction func changeProfilePicButtonPressed(_ sender: UIButton) {
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
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        guard let imageData = selectedImage?.jpegData(compressionQuality: 1.0),
            let firstName = firstNameTextField.text, !firstName.isEmpty,
            let lastName = lastNameTextField.text, !lastName.isEmpty,
            let currentUser = AuthService().getCurrentUser() else {
                showAlert(title: "Missing Fields", message: "A photo and full name is required", actionTitle: "ok")
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
        }
        
        StorageService.postImage(imageData: imageData, imageName: "“profileImages/\(currentUser.uid)”") { [weak self] (error, imageURL) in
            if let error = error {
                self?.showAlert(title: "Error Saving Photo", message: error.localizedDescription, actionTitle: "Ok")
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                
            } else if let imageURL = imageURL {
                let request = currentUser.createProfileChangeRequest()
                request.photoURL = imageURL
                request.commitChanges(completion: { [weak self] (error) in
                    if let error = error {
                        self?.showAlert(title: "Error Saving Account Info", message: error.localizedDescription, actionTitle: "Ok")
                    }
                })
                DBService.firestoreDB
                    .collection(StylistsUserCollectionKeys.stylistUser)
                    .document(currentUser.uid)
                    .updateData([StylistsUserCollectionKeys.firstName : firstName,
                                 StylistsUserCollectionKeys.lastName : lastName,
                                 StylistsUserCollectionKeys.imageURL : imageURL.absoluteString
                        ], completion: { [weak self] (error) in
                            if let error = error {
                                self?.showAlert(title: "Error Saving Account Info", message: error.localizedDescription, actionTitle: "Ok")
                            }
                    })
                self?.dismiss(animated: true)
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension ClientEditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        dismiss(animated: true)
    }
}

extension ClientEditProfileController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
