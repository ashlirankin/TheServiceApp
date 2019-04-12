//
//  BookingViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/12/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class BookingViewController: UITableViewController {

  @IBOutlet weak var avalibilityCollectionView: UICollectionView!
  @IBOutlet weak var servicesCollectionView: UICollectionView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    setupCollectionViewDelegates()
    }
  
  
  func setupCollectionViewDelegates(){
    avalibilityCollectionView.delegate = self
    avalibilityCollectionView.dataSource = self
    servicesCollectionView.dataSource = self
    servicesCollectionView.delegate = self
  }
  @IBAction func serviceButtonPressed(_ sender: UIButton) {
    
  }
  
  @IBAction func timeButtonPressed(_ sender: UIButton) {
  }
  
   
}
extension BookingViewController:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
    case avalibilityCollectionView:
      return CGSize(width: 100, height: 50)
    case servicesCollectionView:
      return CGSize(width: 100, height: 50)
    default:
      return CGSize(width: 200, height: 200)
    }
  }
}
extension BookingViewController:UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
      
    case avalibilityCollectionView:
      return 9
    case servicesCollectionView:
      return 7
    default:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch collectionView {
    case avalibilityCollectionView:
      guard let cell = avalibilityCollectionView.dequeueReusableCell(withReuseIdentifier: "avalibilityCell", for: indexPath) as? AvalibilityCollectionViewCell else {fatalError("no avalibility cell found")}
      cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
      return cell
    case servicesCollectionView:
      guard let cell = servicesCollectionView.dequeueReusableCell(withReuseIdentifier: "servicesCell", for: indexPath) as? ServicesCollectionViewCell else {fatalError("no service cell found")}
      cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
      return cell
    default:
      fatalError("no collection view cell found")
    }
  }
  
  
}
