//
//  Alert+Extensions.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/8/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

extension UIViewController {
  
  public func showAlert(title: String?, message: String?, actionTitle: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: actionTitle, style: .default) { alert in }
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  public func showAlert(title: String?, message: String?,
                        style: UIAlertController.Style,
                        handler: ((UIAlertAction) -> Void)?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
    let okAction = UIAlertAction(title: "Cancel", style: .cancel)
    let customAction = UIAlertAction(title: "Submit", style: .default, handler: handler)
    alertController.addAction(okAction)
    alertController.addAction(customAction)
    present(alertController, animated: true)
  }
  
  public func showDestructionAlert(title: String?, message: String?,
                                   style: UIAlertController.Style,
                                   handler: ((UIAlertAction) -> Void)?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
    let okAction = UIAlertAction(title: "Cancel", style: .cancel)
    let customAction = UIAlertAction(title: "Confirm", style: .destructive, handler: handler)
    alertController.addAction(okAction)
    alertController.addAction(customAction)
    present(alertController, animated: true)
  }
}
