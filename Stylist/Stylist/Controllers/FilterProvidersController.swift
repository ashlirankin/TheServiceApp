//
//  FilterProvidersController.swift
//  Stylist
//
//  Created by Jian Ting Li on 4/12/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class FilterProvidersController: UITableViewController {
    
    // variable of services

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 5
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") as? ServiceCell else { fatalError("ServiceCell is nil") }
            serviceCell.configureCell()
            serviceCell.ServiceLabel.text = "Service \(indexPath.row)"
            return serviceCell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    // Why I need these functions or it will be out of bound and crash?
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 2 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 45
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}
