//
//  UserDetailController.swift
//  Stylist
//
//  Created by Oniel Rosario on 4/9/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase


class ProviderDetailController: UITableViewController {
    let authservice = AuthService()
    @IBOutlet weak var scrollView: UIScrollView!
    lazy var providerDetailHeader = UserDetailView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
    var provider: ServiceSideUser!
    let sectionInset = UIEdgeInsets(top: -200.0,
                                    left: 20.0,
                                    bottom: 400.0,
                                    right: 20.0)
    @IBOutlet weak var collectionView: UICollectionView!
    var buttons = ["Bio", "Portfolio", "Reviews"] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    lazy var profileBio = ProviderBio(frame: CGRect(x: 0, y: 0, width: view.bounds.width , height: 642.5))
    lazy var portfolioView = PortfolioView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 642.5))
    lazy var availabilityTimes = ProviderAvailability(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 642.5))
    lazy var reviewsTable = ProviderDetailReviews(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 642.5))
    lazy var featureViews = [profileBio, portfolioView, reviewsTable]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupScrollviewController(scrollView: scrollView, views: featureViews)
        loadSVFeatures()
        setupProvider()
    }
    
    func checkForDuplicates(id: String, provider: ServiceSideUser) -> Bool {
        guard let currentUser = authservice.getCurrentUser() else  {
            return false
        }
        DBService.firestoreDB.collection(StylistsUserCollectionKeys.stylistUser)
            .document(currentUser.uid)
            .collection("userFavorites")
            .whereField("providerId", isEqualTo: provider.userId)
        return true
    }
    
    @IBAction func AddToFavorite(_ sender: UIBarButtonItem) {
        guard let currentUser = authservice.getCurrentUser() else  {
            return
        }
        DBService.addToFavorites(id: currentUser.uid, prodider: provider) { (error) in
            if let error = error {
                print(error)
            }
            if self.checkForDuplicates(id: currentUser.uid, provider: self.provider) {
                self.showAlert(title: "", message: "Provider already favorited", actionTitle: "OK")
                return
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Added to Favorites", actionTitle: "OK")
                }
            }
        }
    }
    
    
    private func setupProvider() {
        providerDetailHeader.providerFullname.text = "\(provider.firstName ?? "") \(provider.lastName ?? "")"
        providerDetailHeader.providerPhoto.kf.setImage(with: URL(string: provider.imageURL ?? ""), placeholder: #imageLiteral(resourceName: "iconfinder_icon-person-add_211872.png"))
        profileBio.providerBioText.text = provider.bio
        switch provider.jobTitle {
        case "Barber":
            providerDetailHeader.ratingsValue.text = "4.5"
        case "Hair Stylist":
            providerDetailHeader.ratingsValue.text = "5.0"
        default:
            providerDetailHeader.ratingsValue.text = "3.5"
        }
        setupProviderPortfolio()
    }
    
    private func setupProviderPortfolio() {
        portfolioView.portfolioCollectionView.delegate = self
        portfolioView.portfolioCollectionView.dataSource = self
    }
    
    
    
    private func loadSVFeatures() {
        for (index,view) in featureViews.enumerated() {
            scrollView.addSubview(view)
            view.frame.size.width = self.view.bounds.width
            view.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
        }
    }
    
    private func setupUI() {
        tableView.tableHeaderView = providerDetailHeader
        providerDetailHeader.bookingButton.addTarget(self, action: #selector(bookButtonPressed), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    @objc func bookButtonPressed(){
        guard let bookingController = UIStoryboard(name: "BookService", bundle: nil).instantiateViewController(withIdentifier: "BookingController") as? BookingViewController else {return}
        guard let provider = provider else {return}
        bookingController.provider = provider
        let bookingNavController = UINavigationController(rootViewController: bookingController)
        self.present(bookingNavController, animated: true, completion: nil)
    }
}

extension ProviderDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return buttons.count
        } else {
            switch provider.jobTitle {
            case "Barber":
                return 4
            case "Hair Stylist":
                return 9
            default:
                return 10
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ProviderDetailCustomCell
            let buttonLabel = buttons[indexPath.row]
            cell.buttonLabel.text = buttonLabel
            return cell
        } else {
            let portfolioCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortfolioCell", for: indexPath) as! PortfolioCollectionViewCell
            switch provider.jobTitle {
            case "Barber":
                portfolioCell.protoflioImage.image = UIImage(named: "barber\(indexPath.row)")
            case "Hair Stylist":
                portfolioCell.protoflioImage.image = UIImage(named: "hairstyle\(indexPath.row)")
            default:
                portfolioCell.protoflioImage.image = UIImage(named: "makeup\(indexPath.row)")
            }
            return portfolioCell
        }
    }
}

extension ProviderDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 120, height: 40)
        } else {
            return CGSize(width: UIScreen.main.bounds.width / 2, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == portfolioView.portfolioCollectionView {
            return sectionInset
        } else {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let view = featureViews[indexPath.row]
        scrollView.scrollRectToVisible(view.frame, animated: true)
        view.frame.size.width = self.view.bounds.width
        view.frame.origin.x = CGFloat(indexPath.row) * self.view.bounds.size.width
    }
}
