//
//  DiscoverCollectionViewCell.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/16/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionViewImage: UIImageView!
    @IBOutlet weak var providerFullname: UILabel!
    @IBOutlet weak var providerJobTitle: UILabel!
    @IBOutlet weak var providerRating: UILabel!
    @IBOutlet weak var providerDistance: UILabel!
    @IBOutlet weak var goldStar: UIImageView!
 
    public func configureCell(provider: ServiceSideUser, favorites: [ServiceSideUser], rating: Double) {
        collectionViewImage.layer.cornerRadius = 10
        providerRating.text = String(format: "%.1f", rating)
        providerFullname.text = "\(provider.firstName ?? "") \(provider.lastName ?? "")"
        providerJobTitle.text = provider.jobTitle
        collectionViewImage.kf.setImage(with: URL(string: provider.imageURL ?? ""), placeholder:#imageLiteral(resourceName: "placeholder.png") )
        switch provider.jobTitle {
        case "Barber":
            providerDistance.text = "2.9 Mi."
        case "Hair Stylist":
            providerDistance.text = "5.0 Mi."
        default:
            providerDistance.text = "3.25 Mi."
        }
        goldStar.isHidden = true
        favorites.forEach { (favoriteProvider) in
            if favoriteProvider.userId == provider.userId { goldStar.isHidden = false }
        }
    }
}
