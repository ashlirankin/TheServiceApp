//
//  PaymentsViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/22/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class PaymentsViewController: UITableViewController {
 
  @IBOutlet weak var creditCardNumberTextfield: UITextField!
  @IBOutlet weak var expirationDateTextfield: UITextField!
  @IBOutlet weak var nameTextfield: UITextField!

  
  let authService = AuthService()
  var localPayment = [String:Any]()
  var amountDue = Int()
  let cardArray = ["ApplePay":#imageLiteral(resourceName: "apple.png"),"MasterCard":#imageLiteral(resourceName: "shop (1).png"),"Visa":#imageLiteral(resourceName: "charge.png"),"Amex":#imageLiteral(resourceName: "credit-card.png"),"Discover":#imageLiteral(resourceName: "discover.png"),"UnionPay":#imageLiteral(resourceName: "pay.png")]
  
  lazy var cardDisplayCollectionView:UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 350), collectionViewLayout: layout)
    collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    collectionView.isPagingEnabled = true
    collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
    return collectionView
  }()
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backButtonPressed))
    setDelegates()
    }
  
  func setDelegates(){
    creditCardNumberTextfield.delegate = self
    expirationDateTextfield.delegate = self
    cardDisplayCollectionView.dataSource = self
    cardDisplayCollectionView.delegate = self
    nameTextfield.delegate = self
    
    tableView.tableHeaderView = cardDisplayCollectionView
    
    
  }
  @objc func backButtonPressed(){
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func confirmButtonPressed(_ sender: UIBarButtonItem ) {
    guard let cardNumber = creditCardNumberTextfield.text,
    let currentUserId = authService.getCurrentUser()?.uid,
    let cardHolderName = nameTextfield.text,
    let expiryDate = expirationDateTextfield.text else {
      showAlert(title: "All fields Required", message: "All fields are required", actionTitle: "Ok")
      return
    }
    let documentId = DBService.generateDocumentId
    localPayment = ["cardNumber":cardNumber,
                    "cardHolderName":cardHolderName,
                    "userId":currentUserId,
                    "documentId":documentId,
                    "cardExpiryDate":expiryDate
    ]
    
    DBService.createUserWallet(userId: currentUserId, information: localPayment, documentId: documentId) { [weak self] (error) in
      if let error = error {
        self?.showAlert(title: "Error", message: "Could not save payment information: \(error.localizedDescription)", actionTitle: "TryAgain")
      }
    }
    dismiss(animated: true, completion: nil)
  }
  
  func getCardName(cardImage:[String:UIImage],indexPath:IndexPath,selectedImage:UIImage) -> String{
    var cardName = ""
    for (key,value) in cardImage {
      if value == selectedImage{
        cardName = key
      }
    }
    return cardName
  }

}
extension PaymentsViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    textField.resignFirstResponder()
    return true
  }
}
extension PaymentsViewController:UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cardArray.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCollectionViewCell else {fatalError(" no card cell found")}
      let cardImage = Array(cardArray.values)[indexPath.row]
      cell.cardImage.setImage(cardImage, for: .normal)
      cell.cardImage.tag = indexPath.row
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else {return}
    let image = Array(cardArray.values)[cell.cardImage.tag]
    let chosenCardName = getCardName(cardImage: cardArray, indexPath: indexPath, selectedImage: image)
    localPayment["cardType"] = chosenCardName
    
  }
}
extension PaymentsViewController:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   return CGSize(width: view.frame.width, height: 250)
  }
}
