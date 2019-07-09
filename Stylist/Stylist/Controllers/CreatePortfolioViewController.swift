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


class CreatePortfolioViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
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
        if images.isEmpty {
            return 1
        } else {
            return 1 + images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row >= 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? CreatePortfolioCollectionViewCell else { return UICollectionViewCell() }
            let image = images[indexPath.row]
            cell.photoButton.setImage(image, for: .normal)
            cell.photoButton.isEnabled = false
            return cell
        } else  {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? CreatePortfolioCollectionViewCell else { return UICollectionViewCell() }
            cell.photoButton.isEnabled = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
           let cell = collectionView.cellForItem(at: indexPath) as? CreatePortfolioCollectionViewCell
            cell?.photoButton.addTarget(self, action: #selector(showImagepicker), for: .touchDragInside)
        }
    }
    
    @objc private func showImagepicker() {
        if imagePicker.
      present(imagePicker, animated: true)
    }
    
    
}

extension CreatePortfolioViewController: UICollectionViewDelegateFlowLayout {
    
}

extension CreatePortfolioViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
}
