//
//  UserInfoVC.swift
//  PTJ2_SignUp
//
//  Created by mong on 12/05/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit

class UserInfoVC: UIViewController {
    
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var birthLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var signUpBtn: UIButton!
    
    var didDatePicked:Bool = false
    
    @IBAction func cancelBtn(_ sender: Any) {
        // dismiss all
        UserInformation.shared.reset()
        performSegue(withIdentifier: "unwindToVC1", sender: self)
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func signUpBtn(_ sender: Any) {
        UserInformation.shared.phoneNumber = phoneNumberTextField.text!
        UserInformation.shared.birth = birthLabel.text!
        performSegue(withIdentifier: "unwindToVC1", sender: self)
    }
    
    @objc func isValid(){
        if(!(phoneNumberTextField.text?.isEmpty)! && didDatePicked){
            signUpBtn.isEnabled = true
        }else{
            signUpBtn.isEnabled = false
        }
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        birthLabel.text = formatter.string(from: datePicker.date)
        didDatePicked = true
    }
    

    override func viewDidLoad() {
        ///
        phoneNumberTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        datePicker.addTarget(self, action: #selector(isValid), for: .valueChanged)
        signUpBtn.isEnabled = false
        
    }
}
