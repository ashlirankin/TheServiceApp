//
//  DiscoverSecondViewController.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/16/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class DiscoverSecondViewController: UIViewController {
    let authservice = AuthService()
    @IBOutlet weak var collectionView: UICollectionView!
    var listener: ListenerRegistration!
    var serviceProviders = [ServiceSideUser]()
    var favorites = [ServiceSideUser]()
    var allServices = [ServiceSideUser]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    let defaults = UserDefaults.standard
    var availableNow = false
    var genderFilter = [String : String]()
    var professionFilter = [String : String]()
    var maxPriceFilter = 1000
    var servicesFilter = [String : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultsKeys.wipeUserDefaults()
        setupcollectionView()
    }
    
    func  getServices() {
   DBService.getProviders { (services, error) in
            if let error = error {
                print(error)
            } else if let services = services {
                self.serviceProviders = services
                self.checkFilters()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listener = DBService.firestoreDB.collection(ServiceSideUserCollectionKeys.serviceProvider)
            .addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print(error)
                } else if snapshot != nil {
                  self.getServices()
                }
            })
        callUserDefaults()
        getServices()
    }
    
    private func callUserDefaults() {
        availableNow = defaults.object(forKey: UserDefaultsKeys.availableNow) as? Bool ?? false
        genderFilter = defaults.object(forKey: UserDefaultsKeys.genderFilter) as? [String : String] ?? [String : String]()
        professionFilter = defaults.object(forKey: UserDefaultsKeys.professionFilter) as? [String : String] ?? [String : String]()
        maxPriceFilter = defaults.object(forKey: UserDefaultsKeys.maxPriceFilter) as? Int ?? 1000
        servicesFilter = defaults.object(forKey: UserDefaultsKeys.servicesFilter) as? [String: String] ?? [String : String]()
    }
    
    private func checkFilters() {
        var serviceProviders = self.serviceProviders
        var filterTasksComplete = 0 {
            didSet {
                if filterTasksComplete == 1 {
                    self.serviceProviders = serviceProviders
                    getFavorites()
                }
            }
        }
        if availableNow {
            serviceProviders = serviceProviders.filter { (provider) -> Bool in
                if provider.isAvailable { return true }
                return false
            }
            filterTasksComplete += 1
        } else { filterTasksComplete += 1 }
        
        if !genderFilter.isEmpty {
            
        }
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
        let provider = allServices[indexPath.row]
        
        

        let isFavoirte = cell.goldStar.isHidden ? false : true
        destination.isFavorite = isFavoirte
        destination.provider = provider
        
        let index = favorites.firstIndex { provider.userId == $0.userId }
        if let foundIndex = index {
            let favorite = favorites[foundIndex]
            let favoritedId = favorite.favoriteId
            destination.favoriteId = favoritedId
        }
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
