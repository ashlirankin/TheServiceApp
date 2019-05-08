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
    var sortedServiceProviders = [ServiceSideUser]() {
        didSet {
           getReviewsForAllProviders()
        }
    }
    var ratings = [Double]() {
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
    var maxAveragePriceFilter = 1000
    var servicesFilter = [String : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        UserDefaultsKeys.wipeUserDefaults()
        setupListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callUserDefaults()
        getServiceProviders()
    }
    
    // MARK: Initial Setups
    private func getReviewsForAllProviders() {
        var ratings = [Double]() {
            didSet {
                if ratings.count == sortedServiceProviders.count {
                    self.ratings = ratings
                }
            }
        }
        sortedServiceProviders.forEach { (provider) in
            DBService.getReviews(provider: provider, completionHandler: { (reviews, error) in
                if let error = error {
                    ratings.append(5.0)
                    print("Get Ratings Fail: " + error.localizedDescription)
                } else if let reviews = reviews {
                    let allRatingValues = reviews.map { $0.value }
                    if allRatingValues.isEmpty {
                        ratings.append(5.0)
                    } else {
                        let average = allRatingValues.reduce(0, +) / Double(allRatingValues.count)
                        ratings.append(average)
                    }
                }
            })
        }
    }
    
    private func  getServiceProviders() {
        DBService.getProviders { (providers, error) in
            if let error = error {
                print(error)
            } else if let providers = providers {
                self.serviceProviders = providers
                self.checkFilters()
            }
        }
    }
    
    private func setupListener() {
        listener = DBService.firestoreDB.collection(ServiceSideUserCollectionKeys.serviceProvider)
            .addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print(error)
                } else if snapshot != nil {
                    self.getServiceProviders()
                }
            })
    }
    
    private func callUserDefaults() {
        availableNow = defaults.object(forKey: UserDefaultsKeys.availableNow) as? Bool ?? false
        genderFilter = defaults.object(forKey: UserDefaultsKeys.genderFilter) as? [String : String] ?? [String : String]()
        professionFilter = defaults.object(forKey: UserDefaultsKeys.professionFilter) as? [String : String] ?? [String : String]()
        maxAveragePriceFilter = defaults.object(forKey: UserDefaultsKeys.maxPriceFilter) as? Int ?? 1000
        servicesFilter = defaults.object(forKey: UserDefaultsKeys.servicesFilter) as? [String: String] ?? [String : String]()
    }
    
    // MARK: Filters
    private func checkFilters() {
        var serviceProviders = self.serviceProviders
        var filterTasksComplete = 0 {
            didSet {
                if filterTasksComplete == 5 {
                    self.serviceProviders = serviceProviders
                    getFavorites()
                }
            }
        }
        if availableNow {
            serviceProviders = serviceProviders.filter { $0.isAvailable }
        }
        if !genderFilter.isEmpty {
            serviceProviders = serviceProviders.filter {  genderFilter[$0.gender!] != nil }
        }
        if !professionFilter.isEmpty {
            serviceProviders = serviceProviders.filter { professionFilter[$0.jobTitle] != nil }
        }
        filterTasksComplete += 3
        var tempAllProvidersServices = [[ProviderServices]]()
        var allProvidersServicesLeftAfterFilteringPrice = [[ProviderServices]]() {
            didSet {
                // filter by service
                if !servicesFilter.isEmpty {
                    var index = 0
                    serviceProviders = serviceProviders.filter({ (_) -> Bool in
                        let services = allProvidersServicesLeftAfterFilteringPrice[index]
                        index += 1
                        for service in services {
                            if let _ = servicesFilter[service.service] { return true }
                        }
                        return false
                    })
                }
                filterTasksComplete += 1
            }
        }
        var allProvidersServices = [[ProviderServices]]() {
            didSet {
                // filter by price
                var index = 0
                serviceProviders = serviceProviders.filter { (_) -> Bool in
                    let providerAveragePrice = getProviderAverageServicePrice(services: allProvidersServices[index])
                    index += 1
                    if providerAveragePrice <= maxAveragePriceFilter { return true }
                    tempAllProvidersServices.remove(at: index)
                    return false
                }
                filterTasksComplete += 1
                allProvidersServicesLeftAfterFilteringPrice = tempAllProvidersServices
            }
        }
        
        serviceProviders.forEach { (provider) in
            DBService.getProviderServices(providerId: provider.userId, completion: { (error, providerServices) in
                if let error = error {
                    print(error)
                    tempAllProvidersServices.append([ProviderServices]())
                } else if let providerServices = providerServices {
                    tempAllProvidersServices.append(providerServices)
                }
                if tempAllProvidersServices.count == serviceProviders.count {
                    allProvidersServices = tempAllProvidersServices
                }
            })
        }
    }
    private func getProviderAverageServicePrice(services: [ProviderServices]) -> Int {
        var sum = 0
        services.forEach { sum += $0.price }
        return sum / services.count
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
                self.sortedServiceProviders = self.favorites + self.serviceProviders
            }
        }
    }
    
    // MARK: Actions
    @IBAction func filterPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "FilterProviders", bundle: nil)
        let filterVC = storyboard.instantiateViewController(withIdentifier: "FilterProvidersVC") as! FilterProvidersController
        self.present(UINavigationController(rootViewController: filterVC), animated: true, completion: nil)
    }
    
    // MARK: Prepare for Segue (Appointment Detail)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ProviderDetailController,
            let cell = sender as? DiscoverCollectionViewCell,
            let indexPath = collectionView.indexPath(for: cell) else {
                return
        }
        let provider = sortedServiceProviders[indexPath.row]
        let providerRating = ratings[indexPath.row]
        let isFavorite = cell.goldStar.isHidden ? false : true
        destination.rating = providerRating
        destination.isFavorite = isFavorite
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
        return sortedServiceProviders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! DiscoverCollectionViewCell
        let provider = sortedServiceProviders[indexPath.row]
        let providerRating = ratings[indexPath.row]
        cell.configureCell(provider: provider, favorites: favorites, rating: providerRating)
        return cell
    }
    
    
}
