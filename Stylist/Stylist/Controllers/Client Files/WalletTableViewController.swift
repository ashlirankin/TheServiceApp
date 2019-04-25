//
//  WalletTableViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/23/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
// Appointment Details
// Taxes
// Payment button

class WalletTableViewController: UITableViewController {

  @IBOutlet weak var cardHolderName: UITextField!
  @IBOutlet weak var cardNumber: UITextField!
  @IBOutlet weak var expiryDate: UITextField!
  @IBOutlet weak var cardHolderNameLabel: UILabel!
  @IBOutlet weak var cardNumberLabel: UILabel!
  @IBOutlet weak var expiryLabel: UILabel!
  
  let authService = AuthService()
  var paymentMethods = [WalletModel](){
    didSet{
      tableView.reloadData()
      cardDisplayCollectionView.reloadData()
    }
  }
  
  lazy var cardDisplayCollectionView:UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300), collectionViewLayout: layout)
    collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
    
    return collectionView
  }()
  
  override func viewDidLoad() {
        super.viewDidLoad()
    setupHeaderView()
    setUpNavbar()
    getUserPaymentMethods()
    }
  
  @IBAction func changeCardPressed(_ sender: UIButton) {
    
    
  }
  
  @IBAction func cancelButtonPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  func setupHeaderView(){
    tableView.tableHeaderView = cardDisplayCollectionView
    cardDisplayCollectionView.delegate = self
    cardDisplayCollectionView.dataSource = self
  }
   
  func setUpNavbar (){
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style:.plain, target: self, action: #selector(backButtonPressed))
  }
  
  @objc func backButtonPressed(){
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    let addPaymentController = UIStoryboard(name: "Payments", bundle: nil).instantiateViewController(withIdentifier: "PaymentsViewController")
    let addNav = UINavigationController(rootViewController: addPaymentController)
    addPaymentController.modalTransitionStyle = .coverVertical
    addPaymentController.modalPresentationStyle = .overCurrentContext
    
    present(addNav, animated: true, completion: nil)
    
  }
  func getUserPaymentMethods(){
    
    guard let currentUserId = authService.getCurrentUser()?.uid else {return}
    
DBService.firestoreDB.collection(StylistsUserCollectionKeys.stylistUser).document(currentUserId).collection("wallet").addSnapshotListener { [weak self] (snapshot, error) in
      if let error = error {
        self?.showAlert(title: "Error", message: "There was an error obtaining your payment information: \(error.localizedDescription)", actionTitle: "Try Again")
        
      }else if let snapshot = snapshot {
        self?.paymentMethods.removeAll()
        snapshot.documents.forEach{
        let cardData = WalletModel(dict: $0.data())
        self?.paymentMethods.append(cardData)
        }
      }
    }
    
  }
  func isPaymentEmpty(paymentArray:[WalletModel],cell:CardCollectionViewCell) -> Bool{
    if paymentMethods.isEmpty{
      cell.cardImage.setImage(#imageLiteral(resourceName: "add-icon-filled.png"), for: .normal)
      cardHolderName.isHidden = true
      cardNumberLabel.isHidden = true
      cardHolderNameLabel.isHidden = true
      expiryDate.isHidden = true
      cardNumber.isHidden = true
      expiryDate.isHidden = true
      return true
    }else {
      
      cardHolderName.isHidden = false
      cardNumberLabel.isHidden = false
      cardHolderNameLabel.isHidden = false
      expiryDate.isHidden = false
      cardNumber.isHidden = false
      expiryDate.isHidden = false
      
      return false
      
    }
  }
  func getCardImage(cardType:String) -> UIImage? {
    switch cardType{
    case "Amex":
      return #imageLiteral(resourceName: "credit-card")
    case "ApplePay":
      return #imageLiteral(resourceName: "apple.png")
    case "Discover":
      return #imageLiteral(resourceName: "discover")
    case "MasterCard":
      return #imageLiteral(resourceName: "shop (1)")
    case "UnionPay":
      return #imageLiteral(resourceName: "pay")
    case "Visa":
      return #imageLiteral(resourceName: "charge")
    default:
      return #imageLiteral(resourceName: "card")
    }
  }
}
extension WalletTableViewController:UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if paymentMethods.isEmpty {
      return 1
    }else{
      return paymentMethods.count
    }
   
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCollectionViewCell else {fatalError("no card cell found")}
    if isPaymentEmpty(paymentArray: paymentMethods, cell: cell){
      
      
      
    }else{
    let cardInfo = paymentMethods[indexPath.row]
     cell.cardImage.setImage(getCardImage(cardType: cardInfo.cardType), for: .normal)
      
     cardHolderName.isUserInteractionEnabled = false
      cardNumber.isUserInteractionEnabled = false
      expiryDate.isUserInteractionEnabled = false
      
      cardHolderName.text = cardInfo.cardHolderName
      cardNumber.text = cardInfo.cardNumber
      expiryDate.text = cardInfo.cardExpiryDate
      cell.cardImage.isUserInteractionEnabled = false
    }
    
    
   return cell
    
   
  }
}
extension WalletTableViewController:UICollectionViewDelegateFlowLayout
{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 300)
  }
  
}
