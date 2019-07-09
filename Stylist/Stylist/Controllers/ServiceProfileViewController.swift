//
//  ServiceProfileViewController.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/8/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Firebase

class ServiceProfileViewController: UIViewController {
    @IBOutlet weak var providerImage: CircularImageView!
    @IBOutlet weak var providerName: UILabel!
    var stylistUser: StylistsUser?{
        didSet{
            updateUI()
        }
    }
    
    var isSwitched = true
    let authservice = AuthService()
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            guard let viewControllers = navigationController?.viewControllers,
                let index = viewControllers.firstIndex(of: self) else { return }
            navigationController?.viewControllers.remove(at: index)
    }
    
    private func  updateUI() {
        guard let currentUser = stylistUser else  { return }
        DBService.getProvider(consumer:currentUser) { (error, provider) in
            if let error = error {
                print(error)
            } else if let provider = provider {
                self.providerImage.kf.setImage(with: URL(string: provider.imageURL ?? "no image found"), placeholder: #imageLiteral(resourceName: "placeholder.png"))
                self.providerName.text = "\(provider.firstName ?? "no name") \(provider.lastName ?? "no last name")"
            }
        }
    }
    
    func getUser(){
        guard let currentUser = authservice.getCurrentUser() else {return}
        DBService.getDatabaseUser(userID: currentUser.uid) { [weak self] (error, user) in
            if let error = error {
                self?.showAlert(title: "Error", message: "There was an error getting the user:\(error.localizedDescription) ", actionTitle: "Try Aagain")
                
            } else if let user = user {
                self?.stylistUser = user
            }
        }
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
        self.present(servicetab, animated: true) {
            let appdeletgate = (UIApplication.shared.delegate) as! AppDelegate
            appdeletgate.window?.rootViewController = servicetab
            self.navigationController?.removeFromParent()
        }
    }
}
