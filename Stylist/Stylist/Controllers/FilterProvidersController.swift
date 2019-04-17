//
//  FilterProvidersController.swift
//  Stylist
//
//  Created by Jian Ting Li on 4/12/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

enum Profession: String, CaseIterable {
    case barber = "Barber"
    case hairdresser = "Hairdresser"
    case makeup = "Makeup Artist"
    
    static func fetchAllProfessions() -> [Profession] {
        var professions = [Profession]()
        for profession in Profession.allCases {
            professions.append(profession)
        }
        return professions
    }
}

enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    
    static func fetchAllGenders() -> [Gender] {
        var genders = [Gender]()
        for gender in Gender.allCases {
            genders.append(gender)
        }
        return genders
    }
}

enum PriceRange: String {
    case low = "Low"
    case high = "Hight"
}

// 5 UserDefaults Settings:
    // Available now
    // Gender (✔️)
    // Profession
    // Price
    // Services (✔️)

// at the main screen reset user defaults in ViewDidLoad
// check user defaults at view will appear
class FilterProvidersController: UITableViewController {
    
    @IBOutlet weak var professionCollectionView: UICollectionView!
    
    let allGenders = Gender.fetchAllGenders()
    var allProfessions = Profession.fetchAllProfessions()
    var allServices = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var availableNow = false
    var genderFilter = [Gender : String]()
    var professionFilter = [Profession : String]()
    var priceRangeFilter = [PriceRange : Int]()
    var servicesFilter = [String : String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        callUserDefaults()
        setupFilterTableView()
        setupProfessionCollectionView()
    }
    
    private func callUserDefaults() {
        
    }
    
    private func setupProfessionCollectionView() {
        professionCollectionView.dataSource = self
        professionCollectionView.delegate = self
    }
    
    private func setupFilterTableView() {
        tableView.register(UINib(nibName: "ServicesCell", bundle: nil), forCellReuseIdentifier: "ServicesCell")
        fetchAllServices()
    }
    
    
    private func fetchAllServices() {
        DBService.getServices { (professionServices, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let professionServices = professionServices {
                self.allServices = professionServices.map { $0.services }
                        .flatMap{ $0 }
                        .filter{ $0 != "Other"}
            }
        }
    }
    
    // MARK: Actions
    @IBAction func availableNowButtonPressed(_ sender: UIButton) {
        // use a state to indicate whether it's available now or not
        
    }
    
    @IBAction func genderButtonPressed(_ sender: RoundedTextButton) {
        let selectedGender = allGenders[sender.tag]
        if let _ = genderFilter[selectedGender] {
            buttonDeselectedUI(button: sender, gender: selectedGender)
        } else {
            buttonSelectedUI(button: sender, gender: selectedGender)
        }
        print(genderFilter)
    }
    
    private func buttonSelectedUI(button: RoundedTextButton, gender: Gender) {
        genderFilter[gender] = gender.rawValue
        button.backgroundColor = .darkGray
        button.layer.shadowColor = UIColor.red.cgColor
        button.setTitleColor(.white, for: .normal)
    }
    private func buttonDeselectedUI(button: RoundedTextButton, gender: Gender) {
        genderFilter[gender] = nil
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.setTitleColor(.black, for: .normal)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        // Save Item to User Defaults
        dismiss(animated: true)
    }
    
}


// MARK: Setup TableView (Filters)
extension FilterProvidersController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return allServices.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
            let currentServiceName = allServices[indexPath.row]
            cell.delegate = self
            cell.configureCell(serviceName: currentServiceName, indexPath: indexPath)
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 4 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 45
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}

// MARK: Setup CollectionView (Profession Filter)
extension FilterProvidersController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 118, height: 31)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allProfessions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfessionCell", for: indexPath) as? ProfessionCell else {
            fatalError("ProfessionCell is nil")
        }
        let currentProfession = allProfessions[indexPath.row]
        cell.configureCell(profession: currentProfession)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // set filter here for profession
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ProfessionCell
        let selectedProfession = allProfessions[indexPath.row]
        if let _ = professionFilter[selectedProfession] {
            professionDeselected(profession: selectedProfession, cell: selectedCell)
        } else {
            professionSelected(profession: selectedProfession, cell: selectedCell)
        }
    }
    private func professionSelected(profession: Profession, cell: ProfessionCell) {
        professionFilter[profession] = profession.rawValue
        cell.professionLabel.textColor = .white
        cell.backgroundColor = .darkGray
        cell.layer.borderColor = UIColor(hexString: "#FA8072").cgColor
    }
    private func professionDeselected(profession: Profession, cell: ProfessionCell) {
        professionFilter[profession] = nil
        cell.professionLabel.textColor = .black
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.darkGray.cgColor
    }
}

extension FilterProvidersController: ServicesCellDelegate {
    func serviceSwitchToggled(serviceSwitch: UISwitch) {
        let serviceName = allServices[serviceSwitch.tag]
        if let _ = servicesFilter[serviceName] {
            servicesFilter[serviceName] = nil
        } else {
            servicesFilter[serviceName] = serviceName
        }
        print(servicesFilter)
    }
}
