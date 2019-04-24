//
//  CardCollectionViewCell.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/22/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
  
  lazy var cardImage:UIButton = {
    let Iv = UIButton()
    Iv.setImage(#imageLiteral(resourceName: "stp_card_form_front.png"), for: .normal)
    return Iv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  
  func commonInit(){
    setUpViews()
  }
  
}
extension CardCollectionViewCell{
  
  func setUpViews(){
    cardImageConstraints()
  }
  
  func cardImageConstraints(){
    self.addSubview(cardImage)
    cardImage.translatesAutoresizingMaskIntoConstraints = false
    cardImage.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
    cardImage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
  }
  
  
}
