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
    var commentDic = ChatVO().commentList
    var partnerUidList: [String] = []
    
    let tmpView = UIView()
    

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
        Database.database().reference().child("DB_edit").child("users").child(partnerUid!).observeSingleEvent(of: .value, with: { (snapshot) in
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
        Database.database().reference().child("DB_edit").child("ChatRoom").queryOrdered(byChild: "userList/"+uid).queryEqual(toValue: true).observeSingleEvent(of: .value, with: { (snapshot) in

            for item in snapshot.children.allObjects as! [DataSnapshot]{
                if let chatRoomdic = item.value as? NSDictionary{
                    print("##"+"\(chatRoomdic)")
                    var chatValue = ChatVO()
                    
                    let chatRoomComment = chatRoomdic.value(forKey: "Comments") as! NSDictionary
                    
                    let chatRoomUserList = chatRoomdic.value(forKey: "userList") as! NSDictionary
                    chatValue.userList = chatRoomUserList as! Dictionary<String, Bool>
                    
                    //MARK:: edit message
                    //여기서는 제일 최근의 메세지만 필요하므로 sorted된 array의 last값을 넘겨줘서 제일 마지막에 찍힌 메세지를 넘겨줌.
                    var valueKeys = chatRoomComment.allKeys as! [String]
                    valueKeys = valueKeys.sorted()
                    var commentValue = comment()
                    var tmpMessage = chatRoomComment[valueKeys.last] as! NSDictionary
                    commentValue.message = tmpMessage["message"] as! String
                    commentValue.uid = tmpMessage["uid"] as! String
                    commentValue.timestamp = tmpMessage["timestamp"] as! NSNumber
                    chatValue.Comments = commentValue
                    
                    self.chatList.append(chatValue)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    
    
    override func viewDidLoad() {
        tmpView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        tmpView.backgroundColor = UIColor.white
//        self.view.addSubview(tmpView)
        
        uid = Auth.auth().currentUser?.uid
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        tmpView.isHidden = false
        // 여기다가 list를 불러 와야지 채팅방 진입 후 채팅 치고 나왔을 때 최신으로 반영 댐
        getChatRoomList()

    }
    
}
