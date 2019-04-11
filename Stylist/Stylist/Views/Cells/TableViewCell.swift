//
//  TableViewCell.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/9/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

  @IBOutlet weak var nameCell: UILabel!  
  @IBOutlet weak var fieldTextField: UITextField!
  

    

  
}
extension TableViewCell:UITextFieldDelegate{
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
  }
}
