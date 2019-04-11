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
        
    }

    
    func setupCollectionUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
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
    
}

extension DiscoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceProviders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoveryCell", for: indexPath) as! DiscoverTableViewCell
        
        return cell
    }
    
    
}
