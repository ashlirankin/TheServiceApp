//
//  BookingViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/12/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import UserNotifications

enum CurrentaDate:String {
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

    let sectionsTitle = ["Services","Available times","Summary"]
  lazy var providerDetailHeader = UserDetailView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))

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
  let authService = AuthService()
  
 lazy var localAppointments = [String:Any]()
 
  var localServices = [String](){
    didSet{
      localAppointments["services"] = localServices
    }
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    setupCollectionViewDelegates()
    setUpUi()
    }
    
    private func setupNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Appointment Booked!"
        content.subtitle = "We will alert you when \(provider?.firstName ?? "") is on their way!"
        content.sound = UNNotificationSound.default
        content.threadIdentifier = "local-notifcations temp"
        let date = Date(timeIntervalSinceNow: 2)
         let dateComponent = Calendar.current.dateComponents([.year, .month,.day,.hour, .minute, .second, .second, .nanosecond], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest.init(identifier: "content", content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

  


  @IBAction func bookButtonPressed(_ sender: UIButton) {
//
//    guard let provider  = provider ,
//      let currentUser = authService.getCurrentUser(),
//    !localServices.isEmpty else {return}
//    localAppointments["providerId"] = provider.userId
//    localAppointments["userId"] = currentUser.uid
//    createBooking(collectionName: "bookedAppointments", providerId: provider.userId, information: localAppointments, userId: currentUser.uid)
//   setupNotification()
 
    guard let paymentController = UIStoryboard(name: "Payments", bundle: nil).instantiateViewController(withIdentifier: "PaymentsViewController") as? PaymentsViewController else {return}
    let navController = UINavigationController(rootViewController: paymentController)
    paymentController.modalPresentationStyle = .currentContext
    paymentController.modalTransitionStyle = .coverVertical
    paymentController.amountDue = price
    present(navController, animated: true, completion: nil)
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
    servicesArray.remove(at: sender.tag)
    orderSummaryCollectionView.reloadData()
    
  }
  
  private func createBooking(collectionName:String,providerId:String,information:[String:Any],userId:String){
   
    DBService.firestoreDB.collection(collectionName).addDocument(data: information) { (error) in
      if let error = error {
        print("there was an error creating document:\(error.localizedDescription)")
      }
    }
  }
  private func updateBookingInfo(collectionName:String,information:[String:Any],docId:String){
    
    DBService.firestoreDB.collection(collectionName).document(docId).updateData(information) { (error) in
      if let error = error {
        self.showAlert(title: "Error", message: "There was an error updating you information:\(error.localizedDescription)", actionTitle: "Try Again")
      }
    }
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
      if let day = providerAvalibility.first(where: { (avalibility) -> Bool in
        avalibility.currentDate == self.currentDate.rawValue
      }){
        return day.avalibleHours.count
      }
      return 0
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
      
      let avalibleTime = providerAvalibility.first { (avalibility) -> Bool in
        avalibility.currentDate == currentDate.rawValue
      }
      
      title = avalibleTime?.currentDate
      cell.timeButton.tag = indexPath.row
      
      return cell
      
    case servicesCollectionView:
      let aService = providerServices[indexPath.row]
      guard let cell = servicesCollectionView.dequeueReusableCell(withReuseIdentifier: "servicesCell", for: indexPath) as? ServicesCollectionViewCell else {fatalError("no service cell found")}
      cell.serviceNameButton.setTitle(aService.service, for: .normal)
      cell.priceLabel.text = "$\(aService.price)"
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
      guard !servicesArray.contains(service) else {return}
        servicesArray.append(service)
        priceCell.detailTextLabel?.text = "$\(price)"
      
      localServices.append(service.service)
      
    case avalibilityCollectionView:
      guard let cell = avalibilityCollectionView.cellForItem(at: indexPath) as? AvalibilityCollectionViewCell else {
        print("no avalibility found")
        return
      }
      let avalibleTime = providerAvalibility.first { (avalibility) -> Bool in
        avalibility.currentDate == currentDate.rawValue
      }
      cell.isUserInteractionEnabled = true
    
      guard let timeChosen = avalibleTime?.avalibleHours[indexPath.row] else {return}
     
      if cell.isSelected{
        cell.backgroundColor = .lightGray
        cell.isUserInteractionEnabled = false
        
      }else{
        cell.isHidden = true
      }
   localAppointments["avalibility"] = timeChosen
      print(timeChosen)
      
      
    default:
    print("something")
    }
  }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let headerLabel = UILabel(frame: CGRect(x: 30, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Verdana", size: 20)
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.textColor = #colorLiteral(red: 0, green: 0.5772375464, blue: 0.5888287425, alpha: 1)
        headerLabel.sizeToFit()
        view.addSubview(headerLabel)
        return view
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsTitle[section]
    }

}
