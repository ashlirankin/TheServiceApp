//
//  CreatePortfolioViewController.swift
//  Stylist
//
//  Created by Oniel Rosario on 7/9/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import DKImagePickerController
import DKCamera
import DKPhotoGallery


class CreatePortfolioViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var pickerController: DKImagePickerController = {
        var newPicker = DKImagePickerController()
        return newPicker
    }()
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        //        imagePicker.sourceType = .both
        imagePicker.delegate = self
        return imagePicker
    }()
    
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
        //        collectionView.delegate = self
        
    }
    
    init(images: [UIImage]) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @IBAction func BackButton(_ sender: CircularButton) {
        dismiss(animated: true)
    }
    
    
    @IBAction func UploadButton(_ sender: CircularButton) {
        print("OMG IS HAPPENING")
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
            cell.layer.cornerRadius = 10
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell2", for: indexPath) as? CreateSecondCollectionViewCell else { return UICollectionViewCell() }
             let image = images[indexPath.row - 1]
            cell.cellImage.image = image
            cell.layer.cornerRadius = 10
            return cell
        }
        
    }
    
    @objc private func showImagepicker() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
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

