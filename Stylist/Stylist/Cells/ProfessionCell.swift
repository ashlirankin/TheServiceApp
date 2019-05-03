//
//  ProfessionCell.swift
//  Stylist
//
//  Created by Jian Ting Li on 4/15/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class ProfessionCell: UICollectionViewCell {
    @IBOutlet weak var professionLabel: UILabel!
    public func configureCell(profession: Profession) {
        professionLabel.text = profession.rawValue
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1
        clipsToBounds = true
        layer.masksToBounds = true
    }
}

