//
//  FormViewController.swift
//  Stylist
//
//  Created by Oniel Rosario on 6/20/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var expirationTF: UITextField!
    @IBOutlet weak var LICENSEnUMBER: UITextField!
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var licenseAddress: UITextField!
    @IBOutlet weak var licenseCity: UITextField!
    @IBOutlet weak var licenseState: UITextField!
    @IBOutlet weak var licenseZipcode: UITextField!
    @IBOutlet weak var submit: UIButton!
   var authService: AuthService?
    lazy var formSent = SentForm() 
    
    init(authService: AuthService) {
           super.init(nibName: nil, bundle: nil)
          self.authService = authService
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUser = authService?.getCurrentUser() {
            DBService.checkForm(id: currentUser.uid) { (exist) in
                if exist {
                    self.formSent.backButton.addTarget(self, action: #selector(self.backPressed), for: .touchUpInside)
                    self.view.addSubview(self.formSent)
                } else {
                    self.setupTFUI()
                }
            }
        }
    }
    
    @objc func backPressed() {
        dismiss(animated: true)
    }
    
    private func setupTFUI() {
        let textfields: [UITextField] = [nameTF, expirationTF, LICENSEnUMBER, businessName, licenseAddress, licenseCity, licenseState, licenseZipcode]
        textfields.forEach{
            $0.delegate = self
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0, y: $0.frame.height - 2, width: $0.frame.width, height: 2)
            bottomLine.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            $0.borderStyle = .none
            $0.layer.addSublayer(bottomLine)
        }

    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func goBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
    let date = Date()
        let id = DBService.generateDocumentId
      guard let licenceName = nameTF.text, !licenceName.isEmpty,
        let currentUser = authService?.getCurrentUser(),
        let expirationDate = expirationTF.text, !expirationDate.isEmpty,
        let licenceNumber = LICENSEnUMBER.text, !licenceNumber.isEmpty,
        let businessName = businessName.text, !businessName.isEmpty,
        let address = licenseAddress.text, !address.isEmpty,
        let city = licenseCity.text, !city.isEmpty,
        let state = licenseState.text, !state.isEmpty,
        let zipCode = licenseZipcode.text, !zipCode.isEmpty else { return }
     let form = Form(userID: currentUser.uid , date: date.description, documentID: id, licenceNumber: licenceNumber, licenceState: state, licenseHolderName: licenceName, licenseExpiration: expirationDate, businessName: businessName, licenceAddress: address + "," + city + "," + zipCode )
        DBService.UploadFormToDB(form: form, id: id) { (error) in
            if let error = error {
                print(error)
            } else {
                self.showAlert(title: "Sucess", message: "Form has been Sent, we will email you", actionTitle: "OK")
            }
        }
        
    }
    
}

extension FormViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
}
