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
    @IBOutlet weak var lastnameTFA: UITextField!
    @IBOutlet weak var LICENSEnUMBER: UITextField!
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var licenseAddress: UITextField!
    @IBOutlet weak var licenseCity: UITextField!
    @IBOutlet weak var licenseState: UITextField!
    @IBOutlet weak var licenseZipcode: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTFUI()
    }
    
    private func setupTFUI() {
        let textfields: [UITextField] = [nameTF, lastnameTFA, LICENSEnUMBER, businessName, licenseAddress, licenseCity, licenseState, licenseZipcode]
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
}

extension FormViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
}
