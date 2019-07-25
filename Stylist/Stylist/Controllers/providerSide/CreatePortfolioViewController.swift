//
//  CreatePortfolioViewController.swift
//  Stylist
//
//  Created by Oniel Rosario on 7/9/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Kingfisher
import Toucan
import FirebaseFirestore

class CreatePortfolioViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        return imagePicker
    }()
    var editToggle = false {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var authService =  AuthService()
    var portfolioImages = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var images = [UIImage]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        setPhotoData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPhotoData()
    }
    
    func setPhotoData() {
        images.removeAll()
        if let currentUser = authService.getCurrentUser() {
            DBService.getPortfolioImages(providerId: currentUser.uid) { (error, cloudImages) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let cloudImages = cloudImages {
                    let _ = cloudImages.images.map {
                        let Downloadedimage = UIImageView()
                        Downloadedimage.kf.setImage(with: URL(string: $0))
                        if let image = Downloadedimage.image {
                            self.images.append(image)
                        }
                    }
                }
            }
        }
    }
    
    init(images: [UIImage]) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func editPortfolioButton(_ sender: CircularButton) {
        editToggle = !editToggle
    }
    
    
    
    @IBAction func BackButton(_ sender: CircularButton) {
        dismiss(animated: true)
    }
    
    
    @IBAction func UploadButton(_ sender: CircularButton) {
        guard images.count <= 5, let currentUser = authService.getCurrentUser() else {
            return
        }
        for image in images {
            guard let resizedImage = Toucan.Resize.resizeImage(image, size: CGSize(width: 300, height: 300)) else { return }
            if let imageData = resizedImage.jpegData(compressionQuality: 1.0) {
                StorageService.postImage(imageData: imageData, imageName: "portfolio/\(currentUser.uid)") { (error, Photolinks) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let photoLinks = Photolinks {
                        self.portfolioImages.append(photoLinks.absoluteString)
                        let id =  DBService.generateDocumentId
                        let newPortforlio = PortfolioImages(documentId: id, images: self.portfolioImages)
                        DBService.upLoadPortfolio(iD: currentUser.uid, images: newPortforlio) { (error) in
                            if let error = error {
                                print(error)
                            } else {
                                self.showAlert(title: nil, message: "Photos have been uploaded", actionTitle: "OK")
                            }
                        }
                    }
                }
            }
        }
    }
}

extension CreatePortfolioViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? CreatePortfolioCollectionViewCell else { return UICollectionViewCell() }
            cell.photoButton.addTarget(self, action: #selector(showImagepicker), for: .touchDragInside)
            cell.photoButton.isEnabled = true
            cell.layer.cornerRadius = cell.layer.frame.height / 2
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell2", for: indexPath) as? CreateSecondCollectionViewCell else { return UICollectionViewCell() }
            let image = images[indexPath.row - 1]
            cell.cellImage.image = image
            if editToggle {
                cell.deletePhotoButton.tag = indexPath.row
                cell.deletePhotoButton.addTarget(self, action: #selector(deletePhotoCellForIndexpath), for: .touchUpInside)
                cell.deletePhotoButton.isHidden = false
            } else {
                cell.deletePhotoButton.isHidden = true
            }
            cell.layer.cornerRadius = 10
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row == 0 else { return }
        showImagepicker()
    }
    
    @objc private func showImagepicker() {
        guard images.count <= 5 else {
            showAlert(title: "TOO MANY PHOTOS", message: "can only upload 6 photos max", actionTitle: "try again")
            return
        }
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc private func deletePhotoCellForIndexpath(button: UIButton ) {
        images.remove(at: button.tag - 1)
    }
}

extension CreatePortfolioViewController: UICollectionViewDelegateFlowLayout {
    
}

extension CreatePortfolioViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            images.append(image)
        }
        dismiss(animated: true)
    }
}

