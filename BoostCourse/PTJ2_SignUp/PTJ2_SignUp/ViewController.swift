//
//  ViewController.swift
//  PTJ2_SignUp
//
//  Created by mong on 12/05/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {}
    @IBOutlet var IDTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if(!(UserInformation.shared.ID?.isEmpty)!){
            IDTextField.text = UserInformation.shared.ID
        }
    }


}

