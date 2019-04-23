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
    case hairStylist = "Hair Stylist"
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
    case male = "male"
    case female = "female"
    case other = "other"
    
    static func fetchAllGenders() -> [Gender] {
        var genders = [Gender]()
        for gender in Gender.allCases {
            genders.append(gender)
        }
        return genders
    }
}

// TODO: Collapsable Cell & Divide services by profession
class FilterProvidersController: UITableViewController {
    
    @IBOutlet weak var professionCollectionView: UICollectionView!
    @IBOutlet weak var availableNowButton: RoundedTextButton!
    @IBOutlet weak var maleGenderButton: RoundedTextButton!
    @IBOutlet weak var femaleGenderButton: RoundedTextButton!
    @IBOutlet weak var otherGenderButton: RoundedTextButton!
    @IBOutlet weak var maxPriceSlider: UISlider!
    @IBOutlet weak var maxPriceLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    let allGenders = Gender.fetchAllGenders()
    var allProfessions = Profession.fetchAllProfessions()
    var allServices = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var availableNow = defaults.object(forKey: UserDefaultsKeys.availableNow) as? Bool ?? false
    lazy var genderFilter = defaults.object(forKey: UserDefaultsKeys.genderFilter) as? [String : String] ?? [String : String]()
    lazy var professionFilter = defaults.object(forKey: UserDefaultsKeys.professionFilter) as? [String : String] ?? [String : String]()
    lazy var maxPriceFilter = defaults.object(forKey: UserDefaultsKeys.maxPriceFilter) as? Int ?? 1000
    lazy var servicesFilter = defaults.object(forKey: UserDefaultsKeys.servicesFilter) as? [String: String] ?? [String : String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterTableView()
        setupProfessionCollectionView()
        setupAvailableNowButtonUI()
        setupGenderButtonsUI()
        setupMaxPriceSliderUI()
    }
    
    private func setupAvailableNowButtonUI() {
        availableNow ? availableNowButton.buttonSelectedUI() : availableNowButton.buttonDeselectedUI()
    }
    private func setupGenderButtonsUI() {
        for gender in genderFilter {
            switch gender.key {
            case Gender.male.rawValue:
                maleGenderButton.buttonSelectedUI()
            case Gender.female.rawValue:
                femaleGenderButton.buttonSelectedUI()
            case Gender.other.rawValue:
                otherGenderButton.buttonSelectedUI()
            default:
                break
            }
        }
    }
    private func setupMaxPriceSliderUI() {
        maxPriceSlider.value = Float(maxPriceFilter)
        maxPriceLabel.text = "$\(maxPriceFilter)"
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
                        .filter{ $0 != "Other" }
                        .removingDuplicates()
            }
        }
    }
    
    // MARK: Actions
    @IBAction func availableNowButtonPressed(_ sender: RoundedTextButton) {
        if availableNow {
            availableNow = false
            sender.buttonDeselectedUI()
        } else {
            availableNow = true
            sender.buttonSelectedUI()
        }
        print(availableNow)
    }
    
    @IBAction func genderButtonPressed(_ sender: RoundedTextButton) {
        let selectedGender = allGenders[sender.tag]
        if let _ = genderFilter[selectedGender.rawValue] {
            genderFilter[selectedGender.rawValue] = nil
            sender.buttonDeselectedUI()
        } else {
            genderFilter[selectedGender.rawValue] = selectedGender.rawValue
            sender.buttonSelectedUI()
        }
        print(genderFilter)
    }
    

    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        let maxPrice = Int(sender.value)
        maxPriceFilter = maxPrice
        maxPriceLabel.text = "$\(maxPrice)"
    }
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        defaults.set(availableNow, forKey: UserDefaultsKeys.availableNow)
        defaults.set(genderFilter, forKey: UserDefaultsKeys.genderFilter)
        defaults.set(maxPriceFilter, forKey: UserDefaultsKeys.maxPriceFilter)
        defaults.set(professionFilter, forKey: UserDefaultsKeys.professionFilter)
        defaults.set(servicesFilter, forKey: UserDefaultsKeys.servicesFilter)
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
            cell.serviceSwitch.isOn = servicesFilter[currentServiceName] != nil
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
        if let _ = professionFilter[currentProfession.rawValue] {
            professionSelected(profession: currentProfession, cell: cell)
        } else {
            professionDeselected(profession: currentProfession, cell: cell)
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ProfessionCell
        let selectedProfession = allProfessions[indexPath.row]
        if let _ = professionFilter[selectedProfession.rawValue] {
            professionDeselected(profession: selectedProfession, cell: selectedCell)
        } else {
            professionSelected(profession: selectedProfession, cell: selectedCell)
        }
        print(professionFilter)
    }
    private func professionSelected(profession: Profession, cell: ProfessionCell) {
        professionFilter[profession.rawValue] = profession.rawValue
        cell.professionLabel.textColor = .white
        cell.backgroundColor = .darkGray
        cell.layer.borderColor = UIColor(hexString: "#FA8072").cgColor
    }
    private func professionDeselected(profession: Profession, cell: ProfessionCell) {
        professionFilter[profession.rawValue] = nil
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
