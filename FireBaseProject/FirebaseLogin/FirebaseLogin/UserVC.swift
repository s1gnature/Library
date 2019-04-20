//
//  UserVC.swift
//  FirebaseLogin
//
//  Created by mong on 18/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class UserVC: UIViewController {
    
    @IBAction func LogoutBtn(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        } catch{
            print("[UserVC]error in logout")
        }
        dismiss(animated: true, completion: nil)
    }
    
}
