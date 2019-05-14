//
//  CollectionViewCell.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/25/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Cosmos

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var reviewCollectionCellLabel: UILabel!
    @IBOutlet weak var ratingCosmos: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
