//
//  ChatVC.swift
//  firebaseChatApp
//
//  Created by mong on 30/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class InfoVC: UIViewController {
    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setStateMessageBtn(_ sender: Any) {
        let alert = UIAlertController(title: "상태메세지 등록", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textfield) in
            textfield.placeholder = "상태메세지를 입력하세요"
        })
        alert.addAction(UIAlertAction(title: "등록", style: .default, handler: { (_) in
            // add state message
            if let stateMessage = alert.textFields?.first{
                let tmpDic = ["stateMessage":stateMessage.text]
                let uid = Auth.auth().currentUser?.uid
                
                Database.database().reference().child("DB_edit").child("users").child(uid!).updateChildValues(tmpDic)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
