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
    
    @IBOutlet var textFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var chatTextField: UITextField!
    @IBAction func sendBtn(_ sender: Any) {
        creatRoom()
        print("####: " + "\(chatRoomUid)")
    }
    /*
     MARK:: sendBtn 후에 방만 생성되고 message가 안 올라가짐. 한번 더 눌러줘야 upload가 되는데 오또카지..
     이거 구문 순서가 sendBtn -> CreatRoom 하고 chatRoomUid == nil 일때 isChatRoomExist 불러주고
     chatRoomUid 불러와도 nil임. CreatRoom이 다 끝나고 난뒤에 isChatRoomExist가 불러와지는데 이러면
     send버튼 누를때 방 없을시 생성, 그뒤로 아무행동안함. 다시 한번 더 눌러야지 message 전송. 총 2번 눌러야함
     */
    
    var partnerUid: String?
    var uid: String?
    var chatRoomUid: String?
    var partnerProfileImage: UIImage?
    
    var commentUid: [String] = []
    var commentList: [comment] = []
    var commentDic = ChatVO().commentList
    var userValue: userVO?
    
    var DBRef: DatabaseReference?
    var observe: UInt?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.commentList[indexPath.row].uid == uid){
            let cell = tableView.dequeueReusableCell(withIdentifier: "myMessageCell", for: indexPath) as! myMessageCell
            cell.messageLabel.text = commentList[indexPath.row].message
            cell.messageLabel.numberOfLines = 0
            
            Database.database().reference().child("DB_edit").child("ChatRoom").child(chatRoomUid!).child("userList").observeSingleEvent(of: .value, with: { (snapshot) in
                let userList = snapshot.value as! NSDictionary
                
                let readCnt = userList.count - self.commentList[indexPath.row].readUsers.count
                if(readCnt > 0){
                    cell.readUserCntLabel.isHidden = false
                    cell.readUserCntLabel.text = "\(readCnt)"
                }else{
                    cell.readUserCntLabel.isHidden = true
                }
            })

            
            
            if let time = self.commentList[indexPath.row].timestamp{
                cell.timestampLabel.text = time.getCurrentTime
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "partnerMessageCell", for: indexPath) as! partnerMessageCell
            cell.messageLabel.text = commentList[indexPath.row].message
            cell.messageLabel.numberOfLines = 0
            cell.nameLabel.text = userValue?.userName
            
            if let time = self.commentList[indexPath.row].timestamp{
                cell.timestampLabel.text = time.getCurrentTime
            }
            
            
            Database.database().reference().child("DB_edit").child("ChatRoom").child(chatRoomUid!).child("userList").observeSingleEvent(of: .value, with: { (snapshot) in
                let userList = snapshot.value as! NSDictionary
                
                let readCnt = userList.count - self.commentList[indexPath.row].readUsers.count
                if(readCnt > 0){
                    cell.readUserCntLabel.isHidden = false
                    cell.readUserCntLabel.text = "\(readCnt)"
                }else{
                    cell.readUserCntLabel.isHidden = true
                }
            })
            
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
            cell.profileImageView.layer.masksToBounds = true
//            guard let imageData = try? Data(contentsOf: URL(string: (userValue?.profileURL)!)!) else{
//                cell.profileImageView.image = UIImage(named: "user")
//                return cell
//            }
//            cell.messageImageView.image = UIImage(data: imageData)
            cell.profileImageView.image = UIImage(named: "user")
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    // keyboardLayoutConstraint
    @objc func keyboardWillShow(notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.textFieldBottomConstraint.constant = keyboardSize.height + 5
        }
        
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
            }, completion: { (completion) in
                if self.commentList.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(item: self.commentList.count - 1, section: 0), at: .bottom, animated: true)
                }
        })
    }
    @objc func keyboardWillHide(notification: Notification){
        self.textFieldBottomConstraint.constant = 5
        
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (completion) in
            
        })
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    
    // getUser & Partner's Value
    func getPartnerInfo(){
        Database.database().reference().child("DB_edit").child("users").child(self.partnerUid!).observeSingleEvent(of: .value, with: { (snapshot) in
            self.userValue = userVO()
            guard let value = snapshot.value as? NSDictionary else{
                return
            }
            
            self.userValue?.email = value["email"] as! String
            self.userValue?.userName = value["name"] as! String
            self.userValue?.profileURL = value["profileImageURL"] as! String
            self.userValue?.uid = value["uid"] as! String
            
            guard let imageData = try? Data(contentsOf: URL(string: (self.userValue?.profileURL)!)!) else{
//                cell.profileImageView.image = UIImage(named: "user")
                return
            }
            self.partnerProfileImage = UIImage(data: imageData)
            self.navigationItem.title = self.userValue?.userName
//            self.getMessageList()
        })
    }
    
    func getMessageList(){
       DBRef = Database.database().reference().child("DB_edit").child("ChatRoom").child(self.chatRoomUid!).child("Comments")
        observe = DBRef!.observe(.value, with: { (snapshot) in
            
            // removeAll 사용하면 말풍선 1개씩밖에 안나와져벌임.
            self.commentList.removeAll()
            self.commentUid.removeAll()
        
            guard let value = snapshot.value as? NSDictionary else{
                // 여기서 value 는 chatRoom.(roomUID).Comments 에 존재하는 각각의 comment 들의 key, value
                return
            }
            //MARK:: edit message
            var valueKeys = value.allKeys as! [String]
            valueKeys = valueKeys.sorted()
            for key in valueKeys{
                
                let tmpComment = comment()
                let tmpValue = value[key] as! NSDictionary
                tmpComment.message = tmpValue["message"] as! String
                tmpComment.uid = tmpValue["uid"] as! String
                tmpComment.timestamp = tmpValue["timestamp"] as! NSNumber
                
        
                var readUserValue = tmpValue["readUsers"] as! NSDictionary
                for index in readUserValue{
                    tmpComment.readUsers.updateValue(index.value as! Bool, forKey: index.key as! String)
                }
                
                // 이거 로그아웃하고 다시 다른 아이디로 들어왔들 때 이전uid, 현재uid 둘 다 읽음 처리로 update된다..
                tmpComment.readUsers[self.uid!] = true
                
                snapshot.ref.child(key).child("readUsers").updateChildValues(tmpComment.readUsers)
                
                let tmpDic = [Int(key)!:tmpComment]
                self.commentUid.append(key)
                self.commentList.append(tmpComment)
                self.commentDic.updateValue(tmpComment, forKey: key)
            }
            
            
            print(self.commentUid)
            print(self.commentList)
            print(self.commentDic)

            
            self.tableView.reloadData()
            
        })
    }
    
    func readUserCnt(){
        
    }
    
    
    func creatRoom(){
        let roomInfo: Dictionary<String,Any> = [
            "userList" : [
                uid! : true,
                partnerUid! : true
            ]
        ]
   
        // 채팅방이 없을 시 채팅방 생성
        if(chatRoomUid == nil){
           
            Database.database().reference().child("DB_edit").child("ChatRoom").childByAutoId().setValue(roomInfo, withCompletionBlock: { (err, ref) in
                if(err == nil){
                    self.isChatRoomExist()
                }
            })
            
            // 처음 DB가 깨끗할때는 chatRoomUid 값이 항상 nil 이기 때문에 새로운 방이 계속 만들어짐.
            // 그러므로 새로운 방을 만들고 난 뒤에 isChatRommExist 를 불러와서 갱신 시켜줘야지
            // 만들어진 방에 대한 list가 불러와져서 중복된 방이 만들어지지않음.
            
            print("##DEBUG : " + "\(chatRoomUid)")
           
        }
        // 채팅방이 존재할 시 입력한 메세지 DB로 전송
        else{
//            ServerValue.timestamp()
            let timestamp = NSDate().timeIntervalSince1970
            let userCnt = Database.database().reference().child("DB_edit").child("ChatRoom").child(chatRoomUid!).child("userList").key?.count
            let value: Dictionary<String,Any> = [
                "uid" : uid!,
                "message" : chatTextField.text!,
                "timestamp" : timestamp,
                "readUsers" : [uid:true]
                
            ]
            let commentID = Int(timestamp)
            // childByAutoID로 하니까 임의로 생성된 key들이 나중에 allkeys로 불러올때 알파벳 순으로 sort 되어서 불러와짐. -> 메세지 순서가 뒤바뀜
            // 그래서 값을 timestamp로 줘버리면 불러와도 정상적인 순서로 가져옴. 여기서 timestamp 값은 절대 같은 숫자가 될 수 없으므로 괜찮은거같음!
            Database.database().reference().child("DB_edit").child("ChatRoom").child(chatRoomUid!).child("Comments").child("\(commentID)").setValue(value, withCompletionBlock: { (err, ref) in
                self.chatTextField.text! = ""
            })
        }
    }
    
    func isChatRoomExist(){
        // queryOrdered -> child (여기선 chatRoom의 child들, 즉 childByAutoID 값들을 의미) 들의 value
        // 들 중 userList 라는 key 값을 가지는 value들을 탐색해서 반환.
        // 여기서는 userList 안의 uid 값을을 찾아서 반환 ("userList/uid")
        // queryEqual -> 현재 key 값들 중, parameter로 넣은 value와 동일한 값을 찾아서 반환.
        // 여기서는 userList/uid : true 로 되어있는 값만 DB에서 찾아 반환.
        // 즉 DB에서 currentUser.uid를 탐색, 그 중 true 값인 방을 찾아서 chatRoomUid 반환.
        Database.database().reference().child("DB_edit").child("ChatRoom").queryOrdered(byChild: "userList/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot]{
                if let chatRoomdic = item.value as? NSDictionary{
                    print(chatRoomdic)
                    let userList = chatRoomdic["userList"] as! NSDictionary
                    print(userList)
                    let partnerUidValue = userList[self.partnerUid] as? Bool
                    if (partnerUidValue == true) {
                        self.chatRoomUid = item.key
                        self.getPartnerInfo()
                        self.getMessageList()
                    }
                }
            
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // add KeyboardShowHide observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        // remove observer
        NotificationCenter.default.removeObserver(self)
        
        // 채팅방에서 나갔을때도 이 옵저버가 백그라운드에서 작동 되므로 getMessageList 에 대한 옵저버를 제거해줌.
        DBRef?.removeObserver(withHandle: observe!)
    }
    
    override func viewDidLoad() {
        uid  = Auth.auth().currentUser?.uid
        self.tabBarController?.tabBar.isHidden = true
        isChatRoomExist()
        self.commentList.removeAll()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.tableView.separatorStyle = .none
        
    }
}

/*
  MARK:: 강의에서는 Int에다가 extension으로 주고, 시간을 Firebase서버의 값인 ServerValue.timestamp() 로 받아와서 cell에 뿌려줬음.
  그렇게 하니까 getMessageList() 메소드가 여러번 불러와져서 같은 메세지를 여러번 append 시켜버려서 tableView에 뿌려주더라. -> 이유는 아직 모르겠음.....
  그래서 Xcode 자체에서 시간을 불러와서 DB로 보내버렸음. 그리고 그 값을 가져와서 Date에다가 넘겨줘서 시간을 뿌려버림.
*/
extension NSNumber{
    var getCurrentTime: String{
        let dateFomatter = DateFormatter()
        dateFomatter.locale = Locale(identifier: "ko_KR")
        dateFomatter.dateFormat = "yyyy.MM.dd HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(TimeInterval(self)))
        return dateFomatter.string(from: date)
    }
}
