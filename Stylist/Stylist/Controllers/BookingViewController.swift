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
  @IBOutlet weak var orderSummaryCollectionView: UICollectionView!
  
  @IBOutlet weak var priceCell: UITableViewCell!
  
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
  
  var servicesArray = [ProviderServices](){
    didSet{
      orderSummaryCollectionView.reloadData()
      tableView.reloadData()
    }
  }
  
  var currentDate:CurrentaDate = .Tuesday
  
  lazy var price = servicesArray.map{$0.price}.reduce(0, +)
  
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
    orderSummaryCollectionView.delegate = self
    orderSummaryCollectionView.dataSource = self
  }
  
  
   
  @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  @IBAction func cancelButtonPressed(_ sender: UIButton) {
    
    
  }
  
  
  
}
extension BookingViewController:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
    case avalibilityCollectionView:
      return CGSize(width: 150, height: 100)
    case servicesCollectionView:
      return CGSize(width: 150, height: 100)
    case orderSummaryCollectionView:
      return CGSize(width: view.frame.width, height: 100)
    default:
      return CGSize(width: view.frame.width, height: 100)
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
    case orderSummaryCollectionView:
      return servicesArray.count
    default:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch collectionView {
    case avalibilityCollectionView:
      guard let cell = avalibilityCollectionView.dequeueReusableCell(withReuseIdentifier: "avalibilityCell", for: indexPath) as? AvalibilityCollectionViewCell else {fatalError("no avalibility cell found")}
      let avalibility = providerAvalibility[indexPath.row]
      cell.timeButton.setTitle(avalibility.currentDate, for: .normal)
      if currentDate == .Monday {
        avalibility.avalibleHours
      }
      
      
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
    
    case orderSummaryCollectionView:
      guard let cell = orderSummaryCollectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath) as? OrderSummaryCollectionViewCell else {fatalError("no order cell found")}
      let service = servicesArray[indexPath.row]
      cell.orderLabel.text = "\(service.service)"
      cell.priceLabel.text = "$\(service.price)"
      cell.cancelButton.tag =  indexPath.row
      return cell
      
    
    default:
      fatalError("no collection view cell found")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
    case servicesCollectionView:
      
      guard let cell = servicesCollectionView.cellForItem(at: indexPath) as? ServicesCollectionViewCell else{
        print("no service cell found")
        return
      }
     
      
        let service = providerServices[cell.serviceNameButton.tag]
        guard !servicesArray.contains(service) else {

          return
      }
        servicesArray.append(service)
         priceCell.detailTextLabel?.text = "$\(price)"
      
    case avalibilityCollectionView:
      guard let cell = avalibilityCollectionView.cellForItem(at: indexPath) as? AvalibilityCollectionViewCell else {
        print("no avalibility found")
        return
      }
      let avalibility = providerAvalibility[indexPath.row]
      title = avalibility.currentDate
    case orderSummaryCollectionView:
      guard let cell = orderSummaryCollectionView.cellForItem(at: indexPath) as? OrderSummaryCollectionViewCell else {
        print("no order cell found")
        return
      }
      
      if cell.isSelected {
        servicesArray.remove(at: cell.cancelButton.tag)
        orderSummaryCollectionView.reloadData()
      }
     
    
     
    default:
    print("something")
    }
  }
}
