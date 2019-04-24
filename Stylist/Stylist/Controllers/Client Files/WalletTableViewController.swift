//
//  WalletTableViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/23/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class WalletTableViewController: UITableViewController {

  @IBOutlet weak var cardHolderName: UITextField!
  
  @IBOutlet weak var cardNumber: UITextField!
  
  @IBOutlet weak var expiryDate: UITextField!
  
  @IBOutlet weak var scc: UITextField!
  
  @IBOutlet weak var addButton: UIButton!
  lazy var cardDisplayCollectionView:UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300), collectionViewLayout: layout)
    collectionView.backgroundColor = #colorLiteral(red: 0.2727998197, green: 0.3222403526, blue: 1, alpha: 1)
    collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
    
    return collectionView
  }()
  
  override func viewDidLoad() {
        super.viewDidLoad()
    setupHeaderView()
      
    }

  @IBAction func addButtonPressed(_ sender: UIButton) {
    
    
  }
  
  
  func setupHeaderView(){
    tableView.tableHeaderView = cardDisplayCollectionView
    cardDisplayCollectionView.delegate = self
    cardDisplayCollectionView.dataSource = self
  }
   

}
extension WalletTableViewController:UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCollectionViewCell else {fatalError("no card cell found")}
   
   return cell
    
   
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row == 0 {
    addButton.isHidden = false
    tableView.reloadData()
    }else {
      addButton.isHidden = true
      tableView.reloadData()
    }
  }
  
}
extension WalletTableViewController:UICollectionViewDelegateFlowLayout
{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 300)
  }
  
}
