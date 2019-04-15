//
//  BookingViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/12/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

enum CurrentaDate {
  case Monday
  case Tuesday
  case Wednesday
  case Thursday
  case Friday
}
class BookingViewController: UITableViewController {

  @IBOutlet weak var avalibilityCollectionView: UICollectionView!
  @IBOutlet weak var servicesCollectionView: UICollectionView!
  
  @IBOutlet weak var serviceSummary: UITableView!
  
  lazy var providerDetailHeader = UserDetailView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 250))
  private var providerServices = [ProviderServices](){
    didSet{
      servicesCollectionView.reloadData()
    
    }
  }
  private var providerAvalibility = [Avalibility](){
    didSet{
      avalibilityCollectionView.reloadData()
    }
  }
  var provider: ServiceSideUser?{
    didSet{
      getServices(serviceProviderId: provider?.userId ?? "no user id found")
      getProviderAvalibility(providerId: provider?.userId ?? "no provider id found")
    }
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    setupCollectionViewDelegates()
    setUpUi()
    
    }
  
  func getServices(serviceProviderId:String){

DBService.firestoreDB.collection(ServiceSideUserCollectionKeys.serviceProvider).document(serviceProviderId).collection(ServicesCollectionKeys.subCollectionName).getDocuments { (snapshot, error) in
      if let error = error {
        print("there was an error line 46: \(error.localizedDescription)")
      }
      else if let snapshot = snapshot{
        snapshot.documents.forEach{
          let serviceData = ProviderServices(dict: $0.data())
          self.providerServices.append(serviceData)
        }
      }
    }
  }
  
  func getProviderAvalibility(providerId:String){
    DBService.firestoreDB.collection(ServiceSideUserCollectionKeys.serviceProvider).document(providerId).collection(AvalibilityCollectionKeys.avalibility).getDocuments { (snapshot, error) in
      if let error = error {
        print("there was an error obtaining avalibility:\(error.localizedDescription)")
      }
      else if let snapshot = snapshot{
        snapshot.documents.forEach{
          let avalibilityData = Avalibility(dict: $0.data())
          self.providerAvalibility.append(avalibilityData)
        }
      }
    }
  }
  
  func setUpUi(){
    tableView.tableHeaderView = providerDetailHeader
    providerDetailHeader.bookingButton.isHidden = true
    providerDetailHeader.ratingsValue.isHidden = true
    providerDetailHeader.providerPhoto.kf.setImage(with: URL(string: provider?.imageURL ?? "no url found"),placeholder: #imageLiteral(resourceName: "placeholder.png"))
  }
  func setupCollectionViewDelegates(){
    avalibilityCollectionView.delegate = self
    avalibilityCollectionView.dataSource = self
    servicesCollectionView.dataSource = self
    servicesCollectionView.delegate = self
  }
  
  
   
  @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
}
extension BookingViewController:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
    case avalibilityCollectionView:
      return CGSize(width: 150, height: 100)
    case servicesCollectionView:
      return CGSize(width: 150, height: 100)
    default:
      return CGSize(width: 200, height: 200)
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch tableView {
    case serviceSummary:
      guard let cell = serviceSummary.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) as? OrderSummaryTableViewCell else {fatalError("no summary cell found")}
      
      return cell
    default:
      
    return UITableViewCell()
      
    }
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView {
    case serviceSummary:
      return 4
    default:
      return 1
    }
  }
}
extension BookingViewController:UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
      
    case avalibilityCollectionView:
      return providerAvalibility.count
    case servicesCollectionView:
      return providerServices.count
    default:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch collectionView {
    case avalibilityCollectionView:
    
      guard let cell = avalibilityCollectionView.dequeueReusableCell(withReuseIdentifier: "avalibilityCell", for: indexPath) as? AvalibilityCollectionViewCell else {fatalError("no avalibility cell found")}
    
      cell.timeButton.tag = indexPath.row
      
      cell.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
      return cell
    case servicesCollectionView:
      let aService = providerServices[indexPath.row]
      guard let cell = servicesCollectionView.dequeueReusableCell(withReuseIdentifier: "servicesCell", for: indexPath) as? ServicesCollectionViewCell else {fatalError("no service cell found")}
      cell.serviceNameButton.setTitle(aService.service, for: .normal)
      cell.priceLabel.text = "$\(aService.price)"
      cell.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
      cell.serviceNameButton.tag = indexPath.row
      return cell
    default:
      fatalError("no collection view cell found")
    }
  }
}
