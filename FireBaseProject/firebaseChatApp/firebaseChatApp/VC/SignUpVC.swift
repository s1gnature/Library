//
//  SignUpVC.swift
//  firebaseChatApp
//
//  Created by mong on 29/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

let DBRef = Database.database().reference()
let networkIndicator = UIActivityIndicatorView()

class SignUpVC: UIViewController{
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBAction func CancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func SignUpBtn(_ sender: Any) {
        let roadingAlert = UIAlertController(title: "", message: "생성중", preferredStyle: .alert)
        
//        networkIndicator.center.y = self.view.frame.height / 2.0
//        networkIndicator.center.x = self.view.center.x + 30
//        networkIndicator.style = UIActivityIndicatorView.Style.gray
//        roadingAlert.view.addSubview(networkIndicator)
//        networkIndicator.startAnimating()
        present(roadingAlert, animated: true, completion: nil)
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(result, err) in
            let uid = result?.user.uid
            DBRef.child("ChatDB").child("users").child(uid!).setValue(["name":self.nameTextField.text])
//            networkIndicator.stopAnimating()
            roadingAlert.dismiss(animated: true, completion: nil)
            let alert = UIAlertController(title: "", message: "회원가입완료🥰", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {(_) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
}
