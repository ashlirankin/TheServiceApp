//
//  ServiceProfileViewController.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/8/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class ServiceProfileViewController: UIViewController {
    @IBOutlet weak var profileScrollView: UIScrollView!
    lazy var profileBio = ServiceBioView(frame: CGRect(x: 0, y: 0, width: view.bounds.width , height: 350))
    lazy var portfolioView = PortfolioView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 350))
    lazy var featureViews = [profileBio, portfolioView]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     setupScrollView()
    }
    
    private func setupScrollView() {
        profileScrollView.isPagingEnabled = true
        profileScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureViews.count), height: 300)
        profileScrollView.showsHorizontalScrollIndicator = false
        loadSVFeatures()
    }
    
    private func loadSVFeatures() {
        for (index,view) in featureViews.enumerated() {
            profileScrollView.addSubview(view)
            view.frame.size.width = self.view.bounds.width
            view.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
        }
    }


}
