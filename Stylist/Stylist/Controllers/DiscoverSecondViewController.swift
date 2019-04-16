//
//  DiscoverSecondViewController.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/16/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit


class DiscoverSecondViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var serviceProviders = [ServiceSideUser]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupcollectionView()
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
    
    func setupcollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    @IBAction func filterPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "FilterProviders", bundle: nil)
        let filterVC = storyboard.instantiateViewController(withIdentifier: "FilterProvidersVC") as! FilterProvidersController
        self.present(UINavigationController(rootViewController: filterVC), animated: true, completion: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ProviderDetailController,
            let cell = sender as? DiscoverCollectionViewCell,
            let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        let provider = serviceProviders[indexPath.row]
        destination.provider = provider
    }

}

extension DiscoverSecondViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceProviders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! DiscoverCollectionViewCell
        let provider = serviceProviders[indexPath.row]
        cell.providerFullname.text = "\(provider.firstName ?? "") \(provider.lastName ?? "")"
        cell.providerJobTitle.text = provider.jobTitle
        cell.collectionViewImage.kf.setImage(with: URL(string: provider.imageURL ?? ""), placeholder:#imageLiteral(resourceName: "placeholder.png") )
        switch provider.jobTitle {
        case "Barber":
            cell.providerRating.text = "4.5 / 5"
            cell.providerDistance.text = "2.9 Mi."
        case "Hair Stylist":
            cell.providerRating.text = "5.0 / 5"
            cell.providerDistance.text = "5.0 Mi."
        default:
            cell.providerRating.text = "3.5 / 5"
            cell.providerDistance.text = "3.25 Mi."
        }
        
        return cell
    }
    
    
}
