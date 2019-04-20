//
//  HomeVC.swift
//  FirebaseLogin
//
//  Created by mong on 18/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeVC: UIViewController {
    @IBOutlet var UserLabel: UILabel!
    
    
    override func viewDidLoad() {
        UserLabel.text = Auth.auth().currentUser?.email
    }
}
