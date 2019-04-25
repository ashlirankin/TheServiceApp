//
//  ReviewCollectionView.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/25/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class ReviewCollectionView: UICollectionView {
    @IBOutlet var ReviewCV: UICollectionView!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let newLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        newLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        super.init(frame: frame, collectionViewLayout: newLayout)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ReviewsCollectionView", owner: self, options: nil)
        addSubview(ReviewCV)
        ReviewCV.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
//        ReviewCV.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
    }

    
   
}
