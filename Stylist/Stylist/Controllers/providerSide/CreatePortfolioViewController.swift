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
    var cloudImagesIsEmpy = false
    var portfolioDocumentID = ""
    var editToggle = false {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var authService =  AuthService()
    var portfolioImages = [String]()
    
    var images = [UIImage]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    typealias FileCompletionBlock = () -> Void
    var block: FileCompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
//        setPhotoData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPhotoData()
    }
    
    func setPhotoData() {
        if let currentUser = authService.getCurrentUser() {
            DBService.getPortfolioImages(providerId: currentUser.uid) { (error, cloudImages) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let cloudImages = cloudImages {
                    self.portfolioImages = cloudImages.images
                    self.portfolioDocumentID = cloudImages.documentId
                    self.loadPhotos()
                }
            }
        }
    }
    
    private func loadPhotos() {
        for url in portfolioImages {
            let Downloadedimage = UIImageView()
            Downloadedimage.kf.setImage(with: URL(string: url))
            if let image = Downloadedimage.image {
                self.images.append(image)
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
        if portfolioImages.isEmpty {
            startUploading(id: currentUser.uid) {
                        self.setPhotoData()
                        self.showAlert(title: nil, message: "Photos have been uploaded", actionTitle: "OK")
            }
        } else {
            update(id: currentUser.uid)
        }
        
    }
    
    func startUploading(id: String, completion: @escaping FileCompletionBlock) {
        if images.count == 0 {
            completion()
            return
        }
        block = completion
        uploadImage(forIndex: 0, id: id)
    }
    
    func uploadImage(forIndex index:Int, id: String) {
       if index < images.count {
           /// Perform uploading
            let image = images[index]
            guard let resizedImage = Toucan.Resize.resizeImage(image, size: CGSize(width: 300, height: 300)) else { return }
            if let imageData = resizedImage.jpegData(compressionQuality: 1.0) {
                StorageService.uploadPortfolio(data: imageData, fileName: "portfolio/\(id)\(index)") { (url) in
                    if let url = url {
                      self.portfolioImages.append(url)
                        DBService.upLoadPortfolio(iD: id, images: self.portfolioImages, completionHandler: { (error) in
                            if let error = error {
                                print(error)
                            }
                            self.uploadImage(forIndex: index + 1, id: id)
                        })
                        }
                    }
                }
        return
        }
        if block != nil {
            block!()
        }
    }
    
    private func update(id: String) {
        DBService.updatePortfolio(id: id, imagesID: self.portfolioDocumentID, imagesLinks: self.portfolioImages) { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.setPhotoData()
                self.showAlert(title: nil, message: "Photos have been updated", actionTitle: "OK")
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
                cell.deletePhotoButton.tag = indexPath.row - 1
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
        images.remove(at: button.tag)
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

