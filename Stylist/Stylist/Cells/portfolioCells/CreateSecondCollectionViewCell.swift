//
//  CreateSecondCollectionViewCell.swift
//  Stylist
//
//  Created by Oniel Rosario on 7/10/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class CreateSecondCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var deletePhotoButton: CircularButton!
    
    
    func setupCell(image: UIImage, tag: Int, target: Selector, sender: CreatePortfolioViewController, toggle: Bool) {
        cellImage.image = image
        deletePhotoButton.tag = tag
        deletePhotoButton.addTarget(sender, action: target, for: .touchUpInside)
        deletePhotoButton.isHidden = toggle ? false : true
        layer.cornerRadius = 10
    }
}
