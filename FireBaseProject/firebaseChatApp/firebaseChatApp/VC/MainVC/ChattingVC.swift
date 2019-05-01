//
//  ChattingVC.swift
//  firebaseChatApp
//
//  Created by mong on 30/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChattingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var chatTextField: UITextField!
    @IBAction func sendBtn(_ sender: Any) {
        creatRoom()
        print("####: " + "\(chatRoomUid)")
    }
    /*
     MARK:: 이거 구문 순서가 sendBtn -> CreatRoom 하고 chatRoomUid == nil 일때 isChatRoomExist 불러주고
     chatRoomUid 불러와도 nil임. CreatRoom이 다 끝나고 난뒤에 isChatRoomExist가 불러와지는데 이러면
     sendBtn 후에 방만 생성되고 message가 안 올라가짐. 한번 더 눌러줘야 upload가 되는데 오또카지..
     */
    
    var partnerUid: String?
    var uid: String?
    var chatRoomUid: String?
    
    var commentList: [comment] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! messageCell
        cell.messageLabel.text = commentList[indexPath.row].message
        return cell
    }
    
    func getMessageList(){
        Database.database().reference().child("ChatDB").child("ChatRoom").child(self.chatRoomUid!).child("Comments").observe(.value, with: { (snapshot) in
            
            self.commentList.removeAll()
        
            guard let value = snapshot.value as? NSDictionary else{
                return
            }
            var tmpComment = comment()
            tmpComment.message = value["message"] as! String
            tmpComment.uid = value["uid"] as! String
            self.commentList.append(tmpComment)
            
            self.tableView.reloadData()
            
        })
    }
    
    
    
    
    func creatRoom(){
        let roomInfo: Dictionary<String,Any> = [
            "userList" : [
                uid! : true,
                partnerUid! : true
            ]
        ]
   
        if(chatRoomUid == nil){
           
            Database.database().reference().child("ChatDB").child("ChatRoom").childByAutoId().setValue(roomInfo, withCompletionBlock: { (err, ref) in
                if(err == nil){
                    self.isChatRoomExist()
                }
            })
            
            // 처음 DB가 깨끗할때는 chatRoomUid 값이 항상 nil 이기 때문에 새로운 방이 계속 만들어짐.
            // 그러므로 새로운 방을 만들고 난 뒤에 isChatRommExist 를 불러와서 갱신 시켜줘야지
            // 만들어진 방에 대한 list가 불러와져서 중복된 방이 만들어지지않음.
            
            print("##DEBUG : " + "\(chatRoomUid)")
           
        }
        else{
            let value: Dictionary<String,Any> = [
                    "uid" : uid!,
                    "message" : chatTextField.text!
            ]
            Database.database().reference().child("ChatDB").child("ChatRoom").child(chatRoomUid!).child("Comments").setValue(value)
        }
    }
    
    func isChatRoomExist(){
        // queryOrdered -> child (여기선 chatRoom의 child들, 즉 childByAutoID 값들을 의미) 들의 value
        // 들 중 userList 라는 key 값을 가지는 value들을 탐색해서 반환.
        // 여기서는 userList 안의 uid 값을을 찾아서 반환 ("userList/uid")
        // queryEqual -> 현재 key 값들 중, parameter로 넣은 value와 동일한 값을 찾아서 반환.
        // 여기서는 userList/uid : true 로 되어있는 값만 DB에서 찾아 반환.
        // 즉 DB에서 currentUser.uid를 탐색, 그 중 true 값인 방을 찾아서 chatRoomUid 반환.
        Database.database().reference().child("ChatDB").child("ChatRoom").queryOrdered(byChild: "userList/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot]{
                self.chatRoomUid = item.key
                self.getMessageList()
            }
        })
    }
    
    
    
    
    override func viewDidLoad() {
        uid  = Auth.auth().currentUser?.uid
        self.tabBarController?.tabBar.isHidden = true
        isChatRoomExist()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
