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

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var Users: [UserVO] = []
    var userUID: [String] = []
    
    // uid로 받아와야합니당
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! collectionViewCell
        
        cell.subjectLabel.text = Users[indexPath.row].uID!
        cell.explanationLabel.text = Users[indexPath.row].explanation!
        print(Users[indexPath.row].uID!)
        let data = try? Data(contentsOf: URL(string: Users[indexPath.row].imageURL!)!)
        cell.imageView.image = UIImage(data: data!)
        return cell
    }
    
    @IBAction func requestBtn(_ sender: Any) {
        requestUserData()
    }
    
    func requestUserData(){
        DBRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            // value == ALL OF users.child
            let value = snapshot.value as! NSDictionary
            let child = value[(Auth.auth().currentUser?.uid)!] as! NSDictionary
            let user = UserVO()
            user.explanation = child["explanation"] as! String
            user.uID = child["uID"] as! String
            user.userID = child["userID"] as! String
            user.subject = child["subject"] as! String
            user.imageURL = child["imageURL"] as! String
            
            //            user.uID = child["uID"] as! String
            //            print(user.uID)
            self.Users.append(user)
            //            let VO: NSDictionary = value(forKey: "\(Auth.auth().currentUser?.uid)")
            
            //            for child in snapshot.children{
            //                print(child)
            
            //                let user = UserVO()
            
            //                self.Users.append(user)
            //                self.userUID.append(user)
            //            }
            // ...
            self.collectionView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        print(Users)
    }
}
