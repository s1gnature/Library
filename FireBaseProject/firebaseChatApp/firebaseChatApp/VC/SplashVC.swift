//
//  SplashVC.swift
//  firebaseChatApp
//
//  Created by mong on 29/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SplashVC: UIViewController{
    let remoteConfig = RemoteConfig.remoteConfig()
    
    override func viewDidLoad() {
        
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    override func viewDidAppear(_ animated: Bool) {
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
                // 앱 종료 후 재시작 alert
            }
            self.displayAlert()
        }
    }
    func displayAlert(){
        let status = remoteConfig["enable_enter"].boolValue
        let noticeMessage = remoteConfig["notice_message"].stringValue
        
        let alert = UIAlertController(title: "", message: noticeMessage, preferredStyle: .alert)
        
        if(status){
//            let main = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {(_) in
                self.present(VC, animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }else{
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {(_) in exit(0)}
            ))
            present(alert, animated: true, completion: nil)
        }
    }
}
