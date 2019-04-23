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
    
    let defaults = UserDefaults.standard
    var availableNow = false
    var genderFilter = [String : String]()
    var professionFilter = [String : String]()
    var maxAveragePriceFilter = 1000
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
        callUserDefaults()
        getServices()
    }
    
    private func callUserDefaults() {
        availableNow = defaults.object(forKey: UserDefaultsKeys.availableNow) as? Bool ?? false
        genderFilter = defaults.object(forKey: UserDefaultsKeys.genderFilter) as? [String : String] ?? [String : String]()
        professionFilter = defaults.object(forKey: UserDefaultsKeys.professionFilter) as? [String : String] ?? [String : String]()
        maxAveragePriceFilter = defaults.object(forKey: UserDefaultsKeys.maxPriceFilter) as? Int ?? 1000
        servicesFilter = defaults.object(forKey: UserDefaultsKeys.servicesFilter) as? [String: String] ?? [String : String]()
    }
    
    
    private func checkFilters() {
        var serviceProviders = self.serviceProviders
        var filterTasksComplete = 0 {
            didSet {
                print(filterTasksComplete)
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
        cell.configureCell(provider: provider, favorites: favorites)
        return cell
    }
    
    
}
