//
//  DiscoverSecondViewController.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/16/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Firebase

class DiscoverSecondViewController: UIViewController {
    let authservice = AuthService()
    @IBOutlet weak var collectionView: UICollectionView!
    var serviceProviders = [ServiceSideUser]()
    var favorites = [ServiceSideUser]()
    var allServices = [ServiceSideUser]() {
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
            self.getFavorites()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    func getFavorites() {
        guard let currentUser = authservice.getCurrentUser() else {
            return
        }
        DBService.getFavorites(id: currentUser.uid) { (favorites, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let favorites = favorites {
                self.favorites = favorites
                for favorite in self.favorites {
                    self.serviceProviders.removeAll(where: { (serviceProvider) -> Bool in
                        serviceProvider.userId == favorite.userId
                    })
                }
                self.allServices = self.favorites + self.serviceProviders
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
        return allServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! DiscoverCollectionViewCell
        let provider = allServices[indexPath.row]
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
        cell.goldStar.isHidden = true
        for favorite in favorites {
            if favorite.userId == provider.userId {
                cell.goldStar.isHidden = false
                break
            } else {
                cell.goldStar.isHidden = true
            }
        }
        
        return cell
    }
    
    
}
