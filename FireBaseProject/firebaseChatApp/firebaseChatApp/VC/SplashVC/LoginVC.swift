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
    
    // keyboardLayoutConstraint
    @objc func keyboardWillShow(notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame = CGRect(x: 0, y: -100, width: self.view.frame.width, height: self.view.frame.height)
        }
        
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (completion) in
            
        })
    }
    @objc func keyboardWillHide(notification: Notification){
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (completion) in
            
        })
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // add KeyboardShowHide observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        // remove observer
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
}
