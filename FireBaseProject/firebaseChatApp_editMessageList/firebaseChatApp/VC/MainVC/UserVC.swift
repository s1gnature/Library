//
//  ViewController.swift
//  firebaseChatApp
//
//  Created by mong on 29/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit
import Firebase

class UserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userList: [userVO] = []
    
    @IBOutlet var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTableViewCell", for: indexPath) as! userTableViewCell
        
        cell.userName.text = userList[indexPath.row].userName
        cell.userEmail.text = userList[indexPath.row].email
        
        cell.imageView?.layer.cornerRadius = 30
        cell.imageView?.clipsToBounds = true
        
        guard let imageData: Data = try? Data(contentsOf: URL(string: userList[indexPath.row].profileURL!)!) else {
            cell.imageView?.image = UIImage(named: "user")
            return cell
        }
        cell.imageView?.image = UIImage(data: imageData)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = storyboard?.instantiateViewController(withIdentifier: "ChattingVC") as! ChattingVC
        chatVC.partnerUid = userList[indexPath.row].uid
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        
        DBRef.child("DB_edit").child("users").observe(.value, with: { (snapshot) in
            self.userList.removeAll()
            let uidList = snapshot.value as! NSDictionary
            for key in uidList.allKeys{
                
                // login한 본인일 경우 list에서 뺌.
                let uid = key as! String
                if(Auth.auth().currentUser?.uid == uid){
                    continue
                }
                
                let userInfo = uidList[key] as! NSDictionary
                let userModel = userVO()
                userModel.userName = userInfo["name"] as! String
                userModel.email = userInfo["email"] as! String
                userModel.profileURL = userInfo["profileImageURL"] as! String
                userModel.uid = userInfo["uid"] as! String
                self.userList.append(userModel)
            }
            
            /*
            for child in snapshot.children{
                let fchild = child as! DataSnapshot
                let userModel = userVO()
                userModel.setValuesForKeys(fchild.value as! [String:Any])
                self.userList.append(userModel)
            }
             */
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        print(userList)
        
    }

    override func viewDidAppear(_ animated: Bool) {
//        self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
    }

}

