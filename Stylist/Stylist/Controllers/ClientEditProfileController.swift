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
    @IBOutlet weak var nameTextFields: UITextField!
    
    public var stylistUser: StylistsUser!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        if let imageURL = stylistUser.imageURL {
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: URL(string: imageURL), placeholder: #imageLiteral(resourceName: "placeholder.png"))
        }
        nameTextFields.text = stylistUser.fullName
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
        dismiss(animated: true, completion: nil)
        // Lots of Code HERE!!!
        // Update firebase
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
