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
import MessageUI

class ClientProfileController: UIViewController {
    @IBOutlet weak var profileImageView: CircularImageView!
    @IBOutlet weak var clientFullNameLabel: UILabel!
    @IBOutlet weak var userRatingView: CosmosView!
    @IBOutlet weak var clientEmail: UILabel!
  
  let authService = AuthService()
    private var stylistUser: StylistsUser? {
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
                self.stylistUser = stylistUser
            }
        }
    }
    
    private func updateUI() {
        guard let user = stylistUser else { return }
        if let imageUrl = user.imageURL {
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: URL(string: imageUrl), placeholder: #imageLiteral(resourceName: "placeholder.png"))
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
            let storyBoard = UIStoryboard(name: "User", bundle: nil)
            guard let destinationVC = storyBoard.instantiateViewController(withIdentifier: "EditProfileVC") as? ClientEditProfileController else {
                fatalError("EditProfileVC is nil")
            }
            destinationVC.modalPresentationStyle = .currentContext
            if let currentUser = self?.stylistUser {
                destinationVC.stylistUser = currentUser
            } else {
                return
            }
            self?.present(UINavigationController(rootViewController: destinationVC), animated: true)
            
            }, { [weak self] supportAction in
                guard MFMailComposeViewController.canSendMail() else {
                    self?.showAlert(title: "This Device Can't send email", message: nil, actionTitle: "Ok")
                    return
                }
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                mailComposer.setToRecipients(["jiantingli@pursuit.org"])
                mailComposer.setSubject("\(self?.stylistUser?.fullName ?? "Guest"): Help Me!")
                mailComposer.setMessageBody("To: Customer Support, \n\n", isHTML: false)
                self?.present(mailComposer, animated: true)
                
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

extension ClientProfileController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            self.showAlert(title: "Error Sending Email", message: error.localizedDescription, actionTitle: "Ok")
            controller.dismiss(animated: true)
        }
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            self.showAlert(title: "Failed to send email", message: nil, actionTitle: "Ok")
        case .saved:
            print("Saved")
        case .sent:
            self.showAlert(title: "Email Sent", message: nil, actionTitle: "Ok")
        }
        controller.dismiss(animated: true)
    }
}
