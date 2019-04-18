//
//  ViewController.swift
//  FirebaseLogin
//
//  Created by mong on 16/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult?, error: Error!) {
//        print(result!.token.tokenString)
        
        // result 값이 nil 일 경우 firebase 로 내용 보내지 않고 return
        if(result?.token == nil) { return }
        
        // 인증 성공 했을경우 credential 을 생성, firebase로 넘겨서 사용자 등록
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
            FBSDKLoginManager().logOut()
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let alert = UIAlertController.init(title: "", message: "로그아웃 되었습니다", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet var FBLoginBtn: FBSDKLoginButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBAction func signInBtn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func logInBtn(_ sender: Any) {
        if((emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!){
            let alert = UIAlertController.init(title: "", message: "이메일 혹은 비밀번호를 확인하세요", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "확인", style: .default, handler: nil)
            alert.addAction(ok);
            present(alert, animated: true, completion: nil)
        }
        else{
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            // ...
            
            let alert = UIAlertController.init(title: "", message: "환영합니다🥰", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "확인", style: .default, handler: nil)
            alert.addAction(ok);
            self.present(alert, animated: true, completion: nil)
        }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        FBLoginBtn.delegate = self
    }


}

