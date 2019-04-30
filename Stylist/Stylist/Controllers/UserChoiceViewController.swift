//
//  UserChoiceViewController.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/23/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class UserChoiceViewController: UIViewController {
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var providerButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func showUserTab() {
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let servicetab = storyboard.instantiateViewController(withIdentifier: "UserTabBarController")
        servicetab.modalTransitionStyle = .crossDissolve
        servicetab.modalPresentationStyle = .overFullScreen
        self.present(servicetab, animated: true)
        UserDefaults.standard.set("User", forKey: "UserType")
        UserDefaults.standard.set("UserTabBarController", forKey: "VC")
    }
    
    private func showProviderTab() {
        let storyboard = UIStoryboard(name: "ServiceProvider", bundle: nil)
        let providertab = storyboard.instantiateViewController(withIdentifier: "ServiceTabBar")
        providertab.modalTransitionStyle = .crossDissolve
        providertab.modalPresentationStyle = .overFullScreen
        self.present(providertab, animated: true)
            UserDefaults.standard.set("ServiceProvider", forKey: "UserType")
         UserDefaults.standard.set("ServiceTabBar", forKey: "VC")
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender == userButton {
            showUserTab()
        } else {
            showProviderTab()
        }
    }
}
