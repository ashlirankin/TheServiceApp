//
//  UserDetailController.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/9/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Kingfisher

class ProviderDetailController: UITableViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    lazy var providerDetailHeader = UserDetailView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
    var provider: ServiceSideUser!
    @IBOutlet weak var collectionView: UICollectionView!
    var buttons = ["Bio", "Portfolio","Availability", "Reviews"] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    lazy var profileBio = ProviderBio(frame: CGRect(x: 0, y: 0, width: view.bounds.width , height: 642.5))
    lazy var portfolioView = PortfolioView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 642.5))
    lazy var availabilityTimes = ProviderAvailability(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 642.5))
    lazy var reviewsTable = ProviderDetailReviews(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 642.5))
    lazy var featureViews = [profileBio, portfolioView, availabilityTimes, reviewsTable]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
     setupScrollviewController(scrollView: scrollView, views: featureViews)
    loadSVFeatures()
        setupProvider()
    }
    
    private func setupProvider() {
        providerDetailHeader.providerFullname.text = "\(provider.firstName ?? "") \(provider.lastName ?? "")"
        providerDetailHeader.providerPhoto.kf.setImage(with: URL(string: provider.imageURL ?? ""), placeholder: #imageLiteral(resourceName: "iconfinder_icon-person-add_211872.png"))
        profileBio.providerBioText.text = provider.bio
    }

    

    private func loadSVFeatures() {
        for (index,view) in featureViews.enumerated() {
            scrollView.addSubview(view)
            view.frame.size.width = self.view.bounds.width
            view.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
        }
    }
    
    private func setupUI() {
        tableView.tableHeaderView = providerDetailHeader
        
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension ProviderDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ProviderDetailCustomCell
        let buttonLabel = buttons[indexPath.row]
        cell.buttonLabel.text = buttonLabel
        return cell
    }
}

extension ProviderDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let view = featureViews[indexPath.row]
       scrollView.scrollRectToVisible(view.frame, animated: true)
        view.frame.size.width = self.view.bounds.width
        view.frame.origin.x = CGFloat(indexPath.row) * self.view.bounds.size.width
    }
    
}
