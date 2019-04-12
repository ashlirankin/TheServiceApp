//
//  DiscoverViewController.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/10/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase


class DiscoverViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var providersCategory = ["Hair Dresser", "Barber", "MUA"] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var serviceProviders = [ServiceSideUser]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    setupCollectionUI()
        setupTableView()
        getServices()
        
    }
    
    func  getServices() {
        DBService.getProviders { (services, error) in
            if let error = error {
                print(error)
            } else if let services = services {
                self.serviceProviders = services
            }
        }
    }

    
    func setupCollectionUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
      
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ProviderDetailController, let indexpath = tableView.indexPathForSelectedRow else {
            return
        }
        let provider = serviceProviders[indexpath.row]
         destination.provider = provider
    }


}

extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return providersCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoveryCollectionCell", for: indexPath) as! DiscoveryCollectionViewCell
        let providerCategory = providersCategory[indexPath.row]
        cell.label.text = providerCategory
        return cell
    }
    
    
}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 127, height: 34)
    }
}

extension DiscoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension DiscoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceProviders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoveryCell", for: indexPath) as! DiscoverTableViewCell
        let provider = serviceProviders[indexPath.row]
        cell.providerName.text = "\(provider.firstName ?? "") \(provider.lastName ?? "")"
        cell.ProviderCategory.text = provider.jobTitle
        cell.ProviderPic.kf.setImage(with: URL(string: provider.imageURL ?? ""), placeholder:#imageLiteral(resourceName: "placeholder.png") )
        switch provider.jobTitle {
        case "Barber":
            cell.providerRating.text = "4.5"
            cell.providerDistance.text = "2.9 Mi."
        case "Hair Stylist":
            cell.providerRating.text = "5.0"
             cell.providerDistance.text = "5.0 Mi."
        default:
            cell.providerRating.text = "3.5"
             cell.providerDistance.text = "3.25 Mi."
        }
        return cell
    }
    
    
}
