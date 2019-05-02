//
//  PortfolioDetailViewController.swift
//  Stylist
//
//  Created by Oniel Rosario on 5/1/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class PortfolioDetailViewController: UIViewController {
    @IBOutlet weak var portfolioImage: UIImageView!
    var detailImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        portfolioImage.image = detailImage
    }
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.detailImage = image
    }
    
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
