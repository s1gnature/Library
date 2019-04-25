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
import FirebaseDatabase

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var Users: [UserVO] = []
    var uID: [String] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! collectionViewCell
        
        cell.subjectLabel.text = Users[indexPath.row].subject!
        cell.explanationLabel.text = Users[indexPath.row].explanation!
        print(Users[indexPath.row].uID!)
        let data = try? Data(contentsOf: URL(string: Users[indexPath.row].imageURL!)!)
        cell.imageView.image = UIImage(data: data!)

        cell.favoriteBtn.tag = indexPath.row
        cell.favoriteBtn.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
        
        
        // stars 에서 사용자의 uID로 stars<Dictionary>를 조회해서 만약 사용자가
        // like button 을 눌렀다면 true 값이 DB로 반환될것임. 그러므로 image 는
        // true에 해당하는 이미지를 보여주고 아니라면 default 이미지 보여줌.
        // 그런데 아래에 requestUserData 구문 중 강의에서 나오는 구문이 뻑나서
        // 내쪼대로 만들어놨는데 저기서는 like가 아닐 시 DB 상에서 stars 변수가
        // 삭제돼서 없기 때문에 불러오지를 못함. 그래서 해당 DB에서
        // stars[currentUser.uID] == nil 일때는
        // 임시로 Dictionary<currentUser.uID,false> 로 만들어서 append 해주고
        //  각 셀에 뿌려줄때 true / false 로 분기해서 이미지 할당.
        
//        if(Users[indexPath.row].stars != nil){
//            if(Users[indexPath.row].stars![(Auth.auth().currentUser?.uid)!] == nil){
//                cell.favoriteBtn.setImage(UIImage(named: "plus"), for: .normal)
//            }else{
//                cell.favoriteBtn.setImage(UIImage(named: "heart"), for: .normal)
//            }
//        }else{
//            cell.favoriteBtn.setImage(UIImage(named: "plus"), for: .normal)
//        }
        
        
        if(Users[indexPath.row].stars![(Auth.auth().currentUser?.uid)!]!){
            cell.favoriteBtn.setImage(UIImage(named: "heart"), for: .normal)
        }else{
            cell.favoriteBtn.setImage(UIImage(named: "plus"), for: .normal)
        }
 
        cell.trashBtn.tag = indexPath.row
        cell.trashBtn.addTarget(self, action: #selector(deleteBtn(_:)), for: .touchUpInside)
        
        
        
        return cell
    }
    
    @IBAction func requestBtn(_ sender: Any) {
        requestUserData()
        print("#### UID: " + (Auth.auth().currentUser?.uid)!)
    }
    
    // MARK:: Transaction 여러 사용자가 동시에 접근하는걸 방지
    @objc func like(_ sender: UIButton){
        DBRef.child("users").child(uID[sender.tag]).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var stars: Dictionary<String, Bool>
                stars = post["stars"] as? [String : Bool] ?? [:]
                var starCount = post["starCount"] as? Int ?? 0
                if let _ = stars[uid] {
                    // Unstar the post and remove self from stars
                    starCount -= 1
                    stars.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    starCount += 1
                    stars[uid] = true
                }
                post["starCount"] = starCount as AnyObject?
                post["stars"] = stars as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        if(sender.imageView?.image == UIImage(named: "heart")){
            sender.setImage(UIImage(named: "plus"), for: .normal)
        }else{
            sender.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    
    @objc func deleteBtn(_ sender: UIButton){
        Storage.storage().reference().child("ios_firebase_imageUpload").child(Users[sender.tag].imageName!).delete(completion: {(error) in
            if(error != nil){
                print("####Error: deleteImage")
            }else{
                print("####Success: CompleteDeleteImage")
            }
        })
         DBRef.child("users").child(uID[sender.tag]).removeValue()
        
        self.collectionView.reloadSections(IndexSet(0...0))
//        requestUserData()
    }
    
    func requestUserData(){
        // value.key == users의 uID 이므로 allkeys에 대한 각각의 key 를 가져와서 리스트 구성
//        DBRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
        DBRef.child("users").observe(.value, with: { (snapshot) in
            self.Users.removeAll()
            self.uID.removeAll()
            // Get user value
            // value == ALL OF users.child
            // DB상에서 어떠한 data도 없을땐 return 으로 불러오기 취소.
            if(snapshot.childrenCount == 0){return}
            let value = snapshot.value as! NSDictionary
            
            /*
             // 이게 강의에서 나오는 구문인데 뻑남...
            for child in snapshot.children{
                let fchild = child as! DataSnapshot
                let user = UserVO()
                
                user.setValuesForKeys(fchild.value as! [String:Any])
                self.Users.append(user)
            }
             */
            
            for key in value.allKeys{
                let child = value[key] as! NSDictionary
                let user = UserVO()
                user.explanation = child["explanation"] as! String
                user.uID = child["uID"] as! String
                user.userID = child["userID"] as! String
                user.subject = child["subject"] as! String
                user.imageURL = child["imageURL"] as! String
                user.imageName = child["imageName"] as! String
                
                if(child["stars"] == nil){
                    user.stars = Dictionary.init(dictionaryLiteral: ((Auth.auth().currentUser?.uid)!,false))
                }else{
                    // 위에 nil 이 아닐때이나, currentUser.uID가 없을때 그냥 넘겨주면 currentUser.uid로 stars값 불러왔을때
                    // 뻑나요!
                    
                    // 그래서 먼저 stars값이 nil 인지 아닌지 검사. nil 이면 false값 가지는 dictionary init()
                    // 아닐 시 stars의 값을 불러와서 currentUser.uid의 값이 있는지 없는지 검사.
                    // 있다면 그대로 반환, 없다면 false값 가지는 dictionary init()
                    let userStarList = child["stars"] as! NSDictionary
                    if(userStarList[Auth.auth().currentUser?.uid] == nil){
                        user.stars = Dictionary.init(dictionaryLiteral: ((Auth.auth().currentUser?.uid)!,false))
                    }else{
                        user.stars = child["stars"] as! Dictionary
                    }
                }

                self.Users.append(user)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            self.uID = value.allKeys as! [String]
            
        })
    }
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        requestUserData()
    }
}
