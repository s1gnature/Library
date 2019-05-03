//
//  chatListVC.swift
//  firebaseChatApp
//
//  Created by mong on 03/05/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class chatListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var uid: String!
    var chatList: [ChatVO] = []
    var partnerUidList: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatListCell", for: indexPath) as! chatListCell
        
        var partnerUid: String?
        
        for item in chatList[indexPath.row].userList{
            if(item.key != uid){
                partnerUid = item.key
                partnerUidList.append(partnerUid!)
            }
        }
        
        // 이거 강의에서 이렇게 불러왔는데 이렇게 불러오게되면 여러 사람 채팅방에서는 userInfo 못 불러올거같은데..?
        Database.database().reference().child("ChatDB").child("users").child(partnerUid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let userValue = userVO()

            let fsnapshot = snapshot.value as! NSDictionary

            userValue.userName = fsnapshot["name"] as! String
            userValue.email = fsnapshot["email"] as! String
            userValue.uid = fsnapshot["uid"] as! String
            
            
            // 지금은 commentList가 없고 comment 하나만 불러오기때문이 임시로 이렇게 만듦.
            
            cell.contextLabel.text = self.chatList[indexPath.row].Comments?.message
            cell.timestampLabel.text = self.chatList[indexPath.row].Comments?.timestamp?.getCurrentTime
            cell.nameLabel.text = userValue.userName
            
            let imageURL = fsnapshot["profileImageURL"] as! String

            guard let imageData = try? Data(contentsOf: URL(string: imageURL)!) else{
                cell.profileImageView.image = UIImage(named: "user")
                return
            }
            cell.profileImageView.image = UIImage(data: imageData)
        })
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let partnerUid = partnerUidList[indexPath.row]
        let chattingVC = storyboard?.instantiateViewController(withIdentifier: "ChattingVC") as! ChattingVC
        chattingVC.partnerUid = partnerUid
        self.navigationController?.pushViewController(chattingVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func getChatRoomList(){
        chatList.removeAll()
        Database.database().reference().child("ChatDB").child("ChatRoom").queryOrdered(byChild: "userList/"+uid).queryEqual(toValue: true).observeSingleEvent(of: .value, with: { (snapshot) in
            
            for item in snapshot.children.allObjects as! [DataSnapshot]{
                if let chatRoomdic = item.value as? NSDictionary{
                    print("##"+"\(chatRoomdic)")
                    var chatValue = ChatVO()
                    var commentValue = comment()
                    
                    let chatRoomComment = chatRoomdic.value(forKey: "Comments") as! NSDictionary
                    let chatRoomUserList = chatRoomdic.value(forKey: "userList") as! NSDictionary
                    chatValue.userList = chatRoomUserList as! Dictionary<String, Bool>
                    
                    commentValue.message = chatRoomComment["message"] as! String
                    commentValue.uid = chatRoomComment["uid"] as! String
                    commentValue.timestamp = chatRoomComment["timestamp"] as! NSNumber
                    chatValue.Comments = commentValue
                    
                    self.chatList.append(chatValue)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    
    
    override func viewDidLoad() {
        uid = Auth.auth().currentUser?.uid
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        // 여기다가 list를 불러 와야지 채팅방 진입 후 채팅 치고 나왔을 때 최신으로 반영 댐.
        getChatRoomList()
    }
    
    
}
