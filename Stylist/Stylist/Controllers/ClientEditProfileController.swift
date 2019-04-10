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
    
    private lazy var imagePickerView: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func changeProfilePicButtonPressed(_ sender: UIButton) {
//        var actionTitles = [String]()
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            actionTitles = ["Photo Library", "Camera"]
//        } else {
//            actionTitles = ["Photo Library"]
//        }
//        showActionSheet(title: nil, message: nil, actionTitles: actionTitles, handlers: [{ [unowned self] photoLibraryAction in
//            self.imagePickerController.sourceType = .photoLibrary
//            self.present(self.imagePickerController, animated: true)
//
//            }, { cameraAction in
//                self.imagePickerController.sourceType = .camera
//                self.present(self.imagePickerController, animated: true)
//            }
//            ])
        // set titles
        // check if camera is available
        // check action sheet
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
//        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
//            print("original image not available")
//            return
//        }
//        let size = CGSize(width: 500, height: 500)
//        let resizedImage = Toucan.Resize.resizeImage(originalImage, size: size)
//        switch imageEditingState {
//        case .profileImageEditing?:
//            selectedProfileImage = resizedImage
//            profileImageButton.setImage(resizedImage, for: .normal)
//        case .coverImageEditing?:
//            selectedCoverImage = resizedImage
//            profileCoverImageButton.setImage(resizedImage, for: .normal)
//        default:
//            break
//        }
//        dismiss(animated: true)
    }
}
