//
//  UIViewController+Navigations.swift
//  Stylist
//
//  Created by Jian Ting Li on 4/10/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func showLoginView() {
        if let _ = storyboard?.instantiateViewController(withIdentifier: "UserTabBarController") as? UserTabBarController {
            dismiss(animated: true)
            let loginViewStoryboard = UIStoryboard(name: "Entrance", bundle: nil)
            if let loginController = loginViewStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {
                (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = loginController
            } else {
                dismiss(animated: true)
            }
        }
    }
    
}
