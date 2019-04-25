//
//  ServiceProfileViewController.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/8/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class ServiceProfileViewController: UIViewController {
    var isSwitched = true
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func switchprofileButton(_ sender: UIButton) {
        isSwitched = !isSwitched
        if isSwitched == false {
          showUserTab()
        }
    }
    
    private func showUserTab() {
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let servicetab = storyboard.instantiateViewController(withIdentifier: "UserTabBarController")
        servicetab.modalTransitionStyle = .crossDissolve
        servicetab.modalPresentationStyle = .overFullScreen
        self.present(servicetab, animated: true)
    }
}
