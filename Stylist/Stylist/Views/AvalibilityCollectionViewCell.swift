//
//  AvalibilityCollectionViewCell.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/12/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class AvalibilityCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var timeButton: UILabel!
  
  override var isSelected: Bool {
    didSet{
      if self.isSelected{
        backgroundColor = .lightGray
      }else{
        backgroundColor = UIColor.init(hexString: "289195")
      }
    }
  }
  
}
