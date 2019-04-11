//
//  ClientViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/5/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos

class ClientProfileController: UIViewController {
    @IBOutlet weak var profileImageView: CircularImageView!
    @IBOutlet weak var clientFullNameLabel: UILabel!
    @IBOutlet weak var userRatingView: CosmosView!
    @IBOutlet weak var clientEmail: UILabel!
  
  let authService = AuthService()
    private var user: StylistsUser? {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      authService.authserviceSignOutDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
        guard let currentUser = AuthService().getCurrentUser() else {
            showAlert(title: "No User Login", message: nil, actionTitle: "Ok")
            return
        }
        DBService.getDatabaseUser(userID: currentUser.uid) { (error, stylistUser) in
                        if let error = error {
                self.showAlert(title: "Error fetching account info", message: error.localizedDescription, actionTitle: "OK")
            } else if let stylistUser = stylistUser {
                self.user = stylistUser
            }
        }
    }
    
    private func updateUI() {
        guard let user = user else { return }
        if let imageUrl = user.imageURL {
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: URL(string: imageUrl))
        }
        clientFullNameLabel.text = user.fullName
        clientEmail.text = user.email
        // TODO: Set rating here also (Incomplete)
        setStylistUserRating()
    }
    
    private func setStylistUserRating() {
        userRatingView.settings.updateOnTouch = false
        userRatingView.settings.fillMode = .precise
        userRatingView.rating = 5
    }

    @IBAction func moreOptionsButtonPressed(_ sender: UIButton) {
        let actionTitles = ["Edit Profile", "Support", "Sign Out"]
        
        showActionSheet(title: "Menu", message: nil, actionTitles: actionTitles, handlers: [ { [weak self] editProfileAction in
            
            }, { [weak self] supportAction in
                
            }, { [weak self] signOutAction in
              self?.authService.signOut()
              self?.presentLoginViewController()
            }
            ])
    }
  
  private func presentLoginViewController(){
    let window = (UIApplication.shared.delegate  as! AppDelegate).window
    guard let loginViewController = UIStoryboard(name: "Entrance", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController else {return}
    loginViewController.modalPresentationStyle = .fullScreen
    loginViewController.modalTransitionStyle = .coverVertical
    window?.rootViewController = loginViewController
    window?.makeKeyAndVisible()
  }
}
extension ClientProfileController:AuthServiceSignOutDelegate{
  func didSignOutWithError(_ authservice: AuthService, error: Error) {
    showAlert(title: "Unable to SignOut", message: "There was an error signing you out:\(error.localizedDescription)", actionTitle: "Try Again")
  }
  
  func didSignOut(_ authservice: AuthService) {
   showAlert(title: "Sucess", message: "Sucessfully signed out", actionTitle: "OK")
  }
  
  
}
