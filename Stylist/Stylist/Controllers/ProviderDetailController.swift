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
import FirebaseFirestore
import Cosmos

enum FavoriteButtonState: String {
    case favorite
    case unfavorite
}

class ProviderDetailController: UITableViewController {
    var isFavorite: Bool!
    var favoriteId: String?
    let authservice = AuthService()
    var reviewsListener: ListenerRegistration!
    
    @IBOutlet weak var scrollViews: UIScrollView!
    lazy var providerDetailHeader = UserDetailView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 350))
  
    var provider: ServiceSideUser! {
        didSet{
            getPortfolioImages(provider: provider)
        }
    }
    var rating: Double?
    let sectionInset = UIEdgeInsets(top: 10.0,
                                    left: 10.0,
                                    bottom: 400.0,
                                    right: 20.0)
    @IBOutlet weak var collectionView: UICollectionView!
  var buttons = ["Bio","Portfolio","Reviews"] {
        didSet {
            self.collectionView.reloadData()
        }
    }
  var portfolioImages = [String]() {
    didSet{
      print("the number of images are:\(portfolioImages.count)")
      
     portfolioView.portfolioCollectionView.reloadData()
    }
  }
    lazy var profileBio = ProviderBio(frame: CGRect(x: 0, y: 0, width: view.bounds.width , height: 642.5))
    lazy var portfolioView = PortfolioView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 642.5))
    lazy var reviewCollectionView = ReviewCollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 642.5))
    lazy var featureViews = [profileBio, portfolioView, reviewCollectionView]
    var reviews = [Reviews]() {
        didSet {
            DispatchQueue.main.async {
              self.reviewCollectionView.ReviewCV.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        scrollViews.delegate = self
        setupScrollviewController(scrollView: scrollViews, views: featureViews)
        loadSVFeatures()
        setupProvider()
        setFavoriteState()
        reviewCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 700, right: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
  
  func getPortfolioImages(provider:ServiceSideUser){
    DBService.getPortfolioImages(providerId: provider.userId) { [weak self] (error, images) in
      if let error = error {
        self?.showAlert(title: "Error", message: "There was an error getting images:\(error.localizedDescription) ", actionTitle: "Try Again")
      }else if let images = images {
        self?.portfolioImages = images.images
        
      }
    }
    
  }
  
    func setFavoriteState(){
        switch isFavorite {
        case true:
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "icons8-heart-outline-filled-50")
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        default:
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "icons8-love-50")
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func checkForDuplicates(id: String, provider: ServiceSideUser, completionHandler: @escaping(Error?, Bool) -> Void) {
        guard let currentUser = authservice.getCurrentUser() else  {
            return
        }
        DBService.firestoreDB.collection(StylistsUserCollectionKeys.stylistUser)
            .document(currentUser.uid)
            .collection("userFavorites")
            .whereField("userId", isEqualTo: provider.userId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completionHandler(error, false)
                } else if let snapshot = snapshot {
                    if snapshot.documents.count > 0 {
                        completionHandler(nil, true)
                    } else {
                        completionHandler(nil, false)
                    }
                }
        }
    }
    
    @IBAction func FavoriteButtonPressed(_ sender: UIBarButtonItem) {
        switch isFavorite {
        case true:
            deleteFavorite()
            navigationItem.rightBarButtonItem?.image = UIImage(named: "icons8-love-50")
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        default:
            setToFavorites()
            navigationItem.rightBarButtonItem?.image = UIImage(named: "icons8-heart-outline-filled-50")
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
           isFavorite = !isFavorite
    }
    
    @objc private func deleteFavorite() {
        guard let currentUser = authservice.getCurrentUser(), let favoriteId = favoriteId else  {
            return
        }
        DBService.removeFromFavorites(id: currentUser.uid, favoirteId: favoriteId, provider: self.provider) { (error, success) in
            if let error = error {
                print(error.localizedDescription)
            } else if success {
                self.showAlert(title: "", message: "Unfavorited", actionTitle: "OK")
            }
        }
    }
    
    @objc private func setToFavorites() {
        guard let currentUser = authservice.getCurrentUser() else  {
            return
        }
        let documentRef = DBService.generateDocumentId
        DBService.addToFavorites(id: currentUser.uid, prodider: self.provider, documentID: documentRef) { (error) in
            if let error = error {
                print(error)
            } else  {
                self.showAlert(title: "", message: "Favorited", actionTitle: "OK")
            }
        }
    }
    
    private func setupProvider() {
        providerDetailHeader.providerFullname.text = "\(provider.firstName ?? "") \(provider.lastName ?? "")"
        providerDetailHeader.providerFullname.font = UIFont.boldSystemFont(ofSize: 20)
        providerDetailHeader.providerPhoto.kf.setImage(with: URL(string: provider.imageURL ?? ""), placeholder: #imageLiteral(resourceName: "iconfinder_icon-person-add_211872.png"))
        profileBio.providerBioText.text = provider.bio
        if let rating = rating {
            providerDetailHeader.ratingsValue.text = String(format: "%.1f", rating)
            providerDetailHeader.ratingsstars.rating = rating 
        } else {
            providerDetailHeader.ratingsValue.text = "5.0"
            providerDetailHeader.ratingsstars.rating = 5.0
        }
        setupProviderPortfolio()
        setupReviews()
    }
    
    private func   setupProviderPortfolio() {
        portfolioView.portfolioCollectionView.delegate = self
        portfolioView.portfolioCollectionView.dataSource = self
    }
    
    private func setupReviews() {
        reviewsListener = DBService.firestoreDB.collection(ServiceSideUserCollectionKeys.serviceProvider).document(provider.userId)
            .collection(ReviewsCollectionKeys.reviews)
            .addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print(error)
                } else if let snapshot = snapshot {
                    let reviews = snapshot.documents.map{ Reviews(dict: $0.data()) }
                    let sortedReviews = reviews.sorted(by: { (date1, date2) -> Bool in
                        return date1.createdDate.date() > date2.createdDate.date()
                    })
                    self.reviews = sortedReviews
                }
            })
    }
    
    private func loadSVFeatures() {
        for (index,view) in featureViews.enumerated() {
            var contentRect = CGRect.zero
            contentRect = contentRect.union(view.frame)
//            scrollView.delegate = self
            scrollViews.contentSize = contentRect.size
            scrollViews.contentSize.height = view.bounds.height
            scrollViews.backgroundColor = #colorLiteral(red: 0.1619916558, green: 0.224360168, blue: 0.3768204153, alpha: 1)
            scrollViews.addSubview(view)
            scrollViews.contentInsetAdjustmentBehavior = .never
            view.frame.size.width = self.view.bounds.width
            view.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
            
        }
    }
    
    private func setupUI() {
        providerDetailHeader.bookingButton.layer.cornerRadius = 10
        providerDetailHeader.bookingButton.applyGradient(colours: [#colorLiteral(red: 0, green: 0.8280656934, blue: 0.4128242433, alpha: 1),#colorLiteral(red: 0, green: 0.7692238092, blue: 0.7459099889, alpha: 1),#colorLiteral(red: 0.1344156861, green: 0.5513137579, blue: 0.8950611353, alpha: 1)])
        tableView.tableHeaderView = providerDetailHeader
        providerDetailHeader.bookingButton.addTarget(self, action: #selector(bookButtonPressed), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        reviewCollectionView.ReviewCV.delegate = self
        reviewCollectionView.ReviewCV.dataSource = self
    }
    
    @objc func bookButtonPressed(){
        guard let currentUser = authservice.getCurrentUser() else {
            return
        }
        if currentUser.uid == provider.userId {
            self.showAlert(title: nil, message: "You can't book yourself!", actionTitle: "OK")
            return
        }
        guard let bookingController = UIStoryboard(name: "BookService", bundle: nil).instantiateViewController(withIdentifier: "BookingController") as? BookingViewController else {return}
        guard let provider = provider else {return}
        bookingController.rating = rating ?? 5.0
        bookingController.provider = provider
        let bookingNavController = UINavigationController(rootViewController: bookingController)
        self.present(bookingNavController, animated: true, completion: nil)
    }
}

extension ProviderDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return buttons.count
        } else if collectionView == reviewCollectionView.ReviewCV {
            return reviews.count
        } else if collectionView == portfolioView.portfolioCollectionView{
            return portfolioImages.count
        }
        else{
          return 10
      }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ProviderDetailCustomCell
            let buttonLabel = buttons[indexPath.row]
            cell.buttonLabel.text = buttonLabel
            return cell
            
            
        } else if collectionView == reviewCollectionView.ReviewCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
            let review = reviews[indexPath.row]
            cell.reviewCollectionCellLabel.text = review.description
            cell.ratingCosmos.rating = review.value
            return cell
        } else {
            let portfolioCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortfolioCell", for: indexPath) as! PortfolioCollectionViewCell
            portfolioCell.portfolioImage.isUserInteractionEnabled = true
           let image = portfolioImages[indexPath.row]
            portfolioCell.portfolioImage.kf.setImage(with: URL(string: image),placeholder:#imageLiteral(resourceName: "placeholder") )
            portfolioCell.portfolioImage.layer.cornerRadius = 10
            portfolioCell.delegate = self
            return portfolioCell
        }
    }
    
    
}

extension ProviderDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 120, height: 40)
        } else if collectionView == reviewCollectionView.ReviewCV {
            return CGSize(width: 414, height: 90)
        } else {
            return CGSize(width: 350, height: 350)
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
        if collectionView == portfolioView.portfolioCollectionView {
            let portfolioCell = collectionView.cellForItem(at: indexPath) as! PortfolioCollectionViewCell
            guard let image = portfolioCell.portfolioImage.image else  {
                return
            }
            let storyboard = UIStoryboard.init(name: "User", bundle: nil)
            let portfolioVC = storyboard.instantiateViewController(withIdentifier: "PortfolioDetailVC") as! PortfolioDetailViewController
            portfolioVC.detailImage = image
            self.present(portfolioVC, animated: true, completion: nil)
        } else if collectionView == reviewCollectionView.ReviewCV {
            collectionView.allowsSelection = false
        } else {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ProviderDetailCustomCell
            cell.isSelected = true
            var contentRect = CGRect.zero
            let view = featureViews[indexPath.row]
            contentRect = contentRect.union(view.frame)
             scrollViews.contentSize = contentRect.size
            scrollViews.contentSize.height = view.bounds.height
            scrollViews.scrollRectToVisible(view.frame, animated: true)
            view.frame.size.width = self.view.bounds.width
            view.frame.origin.x = CGFloat(indexPath.row) * self.view.bounds.size.width
        }
        
    }
}

extension ProviderDetailController: PortfolioImageDelegate {
    func presentImage(image: UIImage) {
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let portfolioVC = storyboard.instantiateViewController(withIdentifier: "PortfolioDetailVC") as! PortfolioDetailViewController
        portfolioVC.detailImage = image
        self.present(portfolioVC, animated: true, completion: nil)
    }
}


extension ProviderDetailController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView)
        if scrollView == reviewCollectionView.ReviewCV {
            if tableView.contentOffset.y >= 327 {
            print("hello")
            scrollView.isScrollEnabled = false
            scrollViews.isScrollEnabled = false
            scrollView.bounces = false
            scrollView.gestureRecognizers = tableView.gestureRecognizers
            tableView.isScrollEnabled = true
        } else {
            scrollView.isScrollEnabled = true
            scrollView.bounces = true
//            tableView.isScrollEnabled = false
        }
    }
        
        
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if scrollView == reviewCollectionView.ReviewCV {
            tableView.scrollsToTop = true
        }
    }
    
}
