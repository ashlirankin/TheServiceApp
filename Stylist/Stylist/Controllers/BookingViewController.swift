//
//  BookingViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/12/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import UserNotifications

class BookingViewController: UITableViewController {
    @IBOutlet weak var availabilityCollectionView: UICollectionView!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var orderSummaryCollectionView: UICollectionView!
    @IBOutlet weak var priceCell: UITableViewCell!
    @IBOutlet weak var bookAppointmentButton: UIButton!
    
    let authService = AuthService()
    let sectionsTitle = ["Services","Available times","Summary"]
    lazy var providerDetailHeader = UserDetailView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 250))
    var rating: Double?
    
    private var providerServices = [ProviderServices](){
        didSet{
            servicesCollectionView.reloadData()
        }
    }
    private var providerAvailability = [Availability](){
        didSet{
            if let availability = returnAvalibility(availability: providerAvailability) {
                todaysAvailability = availability.avalibleHours
            } else {
                todaysAvailability = [String]()
            }
        }
    }
    private var todaysAvailability = [String]() {
        didSet {
            availabilityCollectionView.reloadData()
        }
    }
    var provider: ServiceSideUser? {
        didSet{
            getServices(serviceProviderId: provider?.userId ?? "no user id found")
            getProviderAvailability(providerId: provider?.userId ?? "no provider id found")
        }
    }
    
    var servicesAddedArray = [ProviderServices]()
    var servicesAddedStrings = [String](){
        didSet{
            tableView.reloadData()
            servicesCollectionView.reloadData()
            orderSummaryCollectionView.reloadData()
            localAppointments["services"] = servicesAddedStrings
        }
    }
    
    var price:Int {
        get {
            return servicesAddedArray.map{$0.price}.reduce(0, +)
        }
    }
    var localPrices = [String](){
        didSet{
            localAppointments["prices"] = localPrices
        }
    }
    
    lazy var localAppointments = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewDelegates()
        setupUI()
    }
    
    // MARK: Initial Setup
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
    
    func getServices(serviceProviderId:String){
        DBService.getProviderServices(providerId: serviceProviderId) { (error, services) in
            if let error = error {
                self.showAlert(title: "Error", message: "There was an error retrieving services:\(error.localizedDescription)", actionTitle:  "Ok")
            }
            else if let services = services {
                self.providerServices = services
            }
        }
    }
    
    func getProviderAvailability(providerId:String) {
        var availability = [Availability]()
        DBService.firestoreDB.collection(ServiceSideUserCollectionKeys.serviceProvider)
            .document(providerId)
            .collection(AvalibilityCollectionKeys.avalibility)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("there was an error obtaining avalibility:\(error.localizedDescription)")
                }
                else if let snapshot = snapshot {
                    let snapshotDocuments = snapshot.documents
                    snapshotDocuments.forEach {
                        availability.append( Availability(dict: $0.data()) )
                        if availability.count == snapshotDocuments.count { self.providerAvailability = availability }
                    }
                }
        }
    }
    
    func setupUI(){
        tableView.tableHeaderView = providerDetailHeader
        providerDetailHeader.bookingButton.isHidden = true
        providerDetailHeader.ratingsValue.isHidden = true
        providerDetailHeader.ratingsstars.rating = rating ?? 5
        providerDetailHeader.providerPhoto.kf.setImage(with: URL(string: provider?.imageURL ?? "no url found"),placeholder: #imageLiteral(resourceName: "placeholder.png"))
        providerDetailHeader.providerFullname.text = "\(provider?.firstName ?? "no name found") \(provider?.lastName ?? "no name found")"
    }
    
    func setupCollectionViewDelegates(){
        availabilityCollectionView.delegate = self
        availabilityCollectionView.dataSource = self
        servicesCollectionView.dataSource = self
        servicesCollectionView.delegate = self
        orderSummaryCollectionView.delegate = self
        orderSummaryCollectionView.dataSource = self
    }
    
    // MARK: Actions
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        var reducedPrice: Int {
            get {
                return price - servicesAddedArray[sender.tag].price
            }
        }
        priceCell.detailTextLabel?.text = "$\(reducedPrice)"
        servicesAddedArray.remove(at: sender.tag)
        servicesAddedStrings.remove(at: sender.tag)
    }
    
    @IBAction func bookButtonPressed(_ sender: UIButton){
        guard let provider  = provider ,
            let currentUser = authService.getCurrentUser(),
            !servicesAddedStrings.isEmpty else {return}
        let documentId = DBService.generateDocumentId
        localAppointments[AppointmentCollectionKeys.providerId] = provider.userId
        localAppointments[AppointmentCollectionKeys.userId] = currentUser.uid
        localAppointments[AppointmentCollectionKeys.status] = "pending"
        localAppointments[AppointmentCollectionKeys.documentId] = documentId
        
        createBooking(collectionName: AppointmentCollectionKeys.bookedAppointments,
                      providerId: provider.userId,
                      information: localAppointments,
                      userId: currentUser.uid,
                      documentId: documentId)
        setupNotification()
        dismiss(animated: true, completion: nil)
        
        //    guard let paymentController = UIStoryboard(name: "Payments", bundle: nil).instantiateInitialViewController() as? OrderSummaryAndPaymentViewController,
        //    let provider = provider  else {fatalError()}
        //    let navController = UINavigationController(rootViewController: paymentController)
        //    paymentController.modalPresentationStyle = .currentContext
        //    paymentController.modalTransitionStyle = .coverVertical
        //    paymentController.providerId = provider.userId
        //    present(navController, animated: true, completion: nil)
    }
    
    private func createBooking(collectionName:String, providerId:String, information:[String:Any], userId:String, documentId:String) {
        DBService.firestoreDB.collection(collectionName)
            .document(documentId)
            .setData(information) { (error) in
                if let error = error {
                    print("error:\(error.localizedDescription)")
                }
        }
    }
    
    // MARK: Helper Functions
    func returnAvalibility(availability:[Availability]) -> Availability? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let currentDate = dateFormatter.string(from: Date())
        title = currentDate
        let specificAvalibility = availability.first { (avalibility) -> Bool in
            avalibility.currentDate == currentDate
        }
        return specificAvalibility
    }
    
    func returnAppointmentTime(chosenTime:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let currentDate = dateFormatter.string(from: Date())
        return "\(currentDate) \(chosenTime)"
    }
}

// MARK: Setup Tableview
extension BookingViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 0 {
            return servicesAddedArray.count == 0 ? 100 : CGFloat(100 * servicesAddedArray.count)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
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

// MARK: Collection View FlowLayout
extension BookingViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case availabilityCollectionView:
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

// MARK: Collection View Setup
extension BookingViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case availabilityCollectionView:
            if let avalibility =  returnAvalibility(availability: providerAvailability) {
                return avalibility.avalibleHours.count
            }
            return 0
        case servicesCollectionView:
            return providerServices.count
        case orderSummaryCollectionView:
            return servicesAddedArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case availabilityCollectionView:
            guard let cell = availabilityCollectionView.dequeueReusableCell(withReuseIdentifier: "avalibilityCell", for: indexPath) as? AvalibilityCollectionViewCell else {fatalError("no avalibility cell found")}
            let time = todaysAvailability[indexPath.row]
            cell.timeButton.text = time
            cell.disableOnExpiration(availableTimes: time)
            return cell
            
        case servicesCollectionView:
            guard let cell = servicesCollectionView.dequeueReusableCell(withReuseIdentifier: "servicesCell", for: indexPath) as? ServicesCollectionViewCell else {fatalError("no service cell found")}
            let aService = providerServices[indexPath.row]
            cell.serviceNameButton.setTitle(aService.service, for: .normal)
            cell.priceLabel.text = "$\(aService.price)"
            cell.serviceNameButton.tag = indexPath.row
            cell.backgroundColor = servicesAddedStrings.contains(aService.service) ? .lightGray : UIColor(hexString: " 289195")
            return cell
            
        case orderSummaryCollectionView:
            guard let cell = orderSummaryCollectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath) as? OrderSummaryCollectionViewCell else {fatalError("no order cell found")}
            let service = servicesAddedArray[indexPath.row]
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
            let service = providerServices[indexPath.row]
            guard !servicesAddedStrings.contains(service.service) else {
                showAlert(title: "Service Already Added", message: nil, actionTitle: "Ok")
                return
            }
            servicesAddedArray.append(service)
            priceCell.detailTextLabel?.text = "$\(price)"
            servicesAddedStrings.append(service.service)
            localPrices.append(String(service.price))
            
        case availabilityCollectionView:
            localAppointments[AppointmentCollectionKeys.appointmentTime] = returnAppointmentTime(chosenTime: todaysAvailability[indexPath.row])
        
        default:
            return
        }
    }
}
