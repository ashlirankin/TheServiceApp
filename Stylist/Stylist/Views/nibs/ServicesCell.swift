//
//  ServicesCell.swift
//  Stylist
//
//  Created by Jian Ting Li on 4/16/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

protocol ServicesCellDelegate: AnyObject {
    func serviceSwitchToggled(serviceSwitch: UISwitch)
}

class ServicesCell: UITableViewCell {
    weak var delegate: ServicesCellDelegate?
    
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceSwitch: UISwitch!
    
    public func configureCell(serviceName: String, indexPath: IndexPath) {
        serviceNameLabel.text = serviceName
        serviceSwitch.tag = indexPath.row
        selectionStyle = .none
    }
    
    @IBAction func serviceSwitchToggled(_ sender: UISwitch) {
        delegate?.serviceSwitchToggled(serviceSwitch: sender)
    }
}
