//
//  ChattingVC.swift
//  firebaseChatApp
//
//  Created by mong on 30/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit

class ChattingVC: UIViewController {
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
