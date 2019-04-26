//
//  ViewController.swift
//  RemoteConfig
//
//  Created by mong on 26/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit
import Firebase

let remoteConfig = RemoteConfig.remoteConfig()
class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefault")
        fetchRemoteConfig()
    }
    override func viewDidAppear(_ animated: Bool) {
        displayMessage()
    }

    func fetchRemoteConfig(){
        remoteConfig.configSettings = RemoteConfigSettings.init(developerModeEnabled: true)
        
        remoteConfig.fetch(withExpirationDuration: 0, completionHandler: { (status, error) in
            if (status == .success){
                remoteConfig.activateFetched()
            }
//            self.displayMessage()
        })
    }
    
    
    func displayMessage(){
        let message = remoteConfig["welcome_message"].stringValue
        let caps = remoteConfig["welcome_message_caps"].boolValue
        let color = remoteConfig["backgroundColor"].numberValue
        
        let alert = UIAlertController.init(title: "Announce!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        self.view.backgroundColor = UIColor.orange
        self.present(alert, animated: true, completion: nil)
    }
    
}

