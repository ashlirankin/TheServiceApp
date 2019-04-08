//
//  PortfolioView.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/8/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class PortfolioView: UIView {
    lazy var portfolioCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
         let cv = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        cv.isScrollEnabled = true
        cv.backgroundColor = .red
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
        commonInit()
        
    }
    
    private func commonInit() {
        addSubview(portfolioCollectionView)
    }
  
}
