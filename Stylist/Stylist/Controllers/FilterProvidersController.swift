//
//  FilterProvidersController.swift
//  Stylist
//
//  Created by Jian Ting Li on 4/12/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

enum Profession: String {
    case barber = "Barber"
    case hairdresser = "Hairdresser"
    case makeup = "Makeup Artist"
}

enum Gender: String {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}

class FilterProvidersController: UITableViewController {
    
    
    
    let professions: [Profession] = [.barber, .hairdresser, .makeup]
    let genders: [Gender] = [.male, .female, .other]
    var services = ["Cut", "Shampoo"] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        
        //fetchAllServices()
    }
    
    // change this function
    private func fetchAllServices() {
        var allServices = [String]()
        DBService.getServices { (professionServices, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let professionServices = professionServices {
                for professionService in professionServices {
                    for offerService in professionService.services {
                        allServices.append(offerService)
                    }
                }
                self.services = allServices
            }
        }
    }
    
}

// Mark: Setup TableView
extension FilterProvidersController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return services.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 4 {
            guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") as? ServiceCell else { fatalError("ServiceCell is nil") }
            let currentServiceName = services[indexPath.row]
            serviceCell.ServiceLabel.text = currentServiceName
            return serviceCell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    // Why I need these functions or it will be out of bound and crash?
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 4 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 45
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}
