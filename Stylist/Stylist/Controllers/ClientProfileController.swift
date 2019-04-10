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
    
    private var user: StylistsUser? {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            dump(currentUser)
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
        
        showActionSheet(title: "Menu", message: nil, actionTitles: actionTitles, handlers: [ { [unowned self] editProfileAction in
            let storyBoard = UIStoryboard(name: "User", bundle: nil)
            guard let destinationVC = storyBoard.instantiateViewController(withIdentifier: "EditProfileVC") as? ClientEditProfileController else {
                fatalError("EditProfileVC is nil")
            }
            destinationVC.modalPresentationStyle = .currentContext
            if let currentUser = self.user {
                destinationVC.stylistUser = currentUser
            } else {
                return
            }
            self.present(destinationVC, animated: true)
            
            }, { [unowned self] supportAction in
                
            }, { [unowned self] signOutAction in
                AuthService().signOut()
                self.showLoginView()
            }
            ])
    }
}
