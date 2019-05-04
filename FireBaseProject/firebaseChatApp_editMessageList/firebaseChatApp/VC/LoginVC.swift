//
//  LoginVC.swift
//  firebaseChatApp
//
//  Created by mong on 29/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginVC: UIViewController{
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBAction func LoginBtn(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, err) in
            if(err != nil){
                print(err?.localizedDescription)
                let alert = UIAlertController(title: "", message: "이메일과 비밀번호를 확인하세요😄", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "UserVC") as! UserVC
                let mainTabBarVC = mainStoryboard.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
                self.present(mainTabBarVC, animated: true, completion: nil)
            }
        })
    }
    
    override func viewDidLoad() {
        
    }
    
}
