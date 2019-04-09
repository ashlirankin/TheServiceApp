//
//  UserDetailController.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/9/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class ProviderDetailController: UITableViewController {
    lazy var providerDetailHeader = UserDetailView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
    @IBOutlet weak var collectionView: UICollectionView!
    
    var buttons = ["hair Dresser", "barber","MUA"] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
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
    
}
