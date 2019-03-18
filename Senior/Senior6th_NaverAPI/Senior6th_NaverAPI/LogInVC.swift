//
//  LogInVC.swift
//  Senior6th_NaverAPI
//
//  Created by mong on 2017. 9. 27..
//  Copyright © 2017년 mong. All rights reserved.
//

import Foundation
import UIKit

class LogInVC : UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate{
    let rootID = "mong"
    let rootPW = "0000"
    var check = true
    // 자동로그인 
    /*
     ID 와 PW 에 대한 accountSequence 값이 할당되면 그 값을 UserDefault에 저장 후 
     스플래시 화면에서 그 값이 일치할시 로그인 창 띄우지 않고 바로 메인 뷰컨으로 넘어감.
     */
    let accountSequence = 150621
    var ud = UserDefaults.standard
    
    @IBOutlet weak var shinJJang_img: UIImageView!
    @IBOutlet weak var ID_textfield: UITextField!
    
    @IBOutlet weak var PW_textfield: UITextField!
    
    @IBOutlet weak var LogIn_btn: UIButton!
    
    @IBAction func Login_btn(_ sender: Any) {
        guard let id = ID_textfield.text, let pw = PW_textfield.text
            else{return}
        if id.isEmpty{
            simpleAlert(title: "LogIn Error", message: "plz enter ID")
        }
        else if pw.isEmpty{
            simpleAlert(title: "LogIn Error", message: "plz enter PW")
        }
        else if isValid(){
            let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let mainVC = main_storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
            
            ud.set(accountSequence, forKey: "accountSequence")
            
            present(mainVC, animated: true, completion: nil)
        }
            //id pw 둘 다 틀리게 썼을때
        else {
            simpleAlert(title: "LogIn Error", message: "Check ID & PW")
        }
        print(id)
        print(pw)
        
    }
    // id pw check method
    func isValid() -> Bool {
        
        if ID_textfield.text == rootID {
            if PW_textfield.text == rootPW {
                return true
            } else {
                return false
            }
        }
            
        else {
            return false
        }
        
    }
    // return 클릭 시 키보드 dismiss
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
//        PW_textfield.becomeFirstResponder()
        print("return")
        return true
    }
    
    /*
    // 화면 터치시 에딧 종료.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
 */
    
    //tap을 눌렀을때 이벤트(화면 빈공간 눌렀을때)
    //## 이거 tap gesture recognizer 로 outlet Action 지정해서 만드는게 편할듯.
    // 근데 해보니까 안 되네..? 3/28
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?){
        print("tap")
        // 키보드 호출?
        // 텍스트필드에 해당하는 반응을 실행합니다 -> become
//        self.ID_textfield.becomeFirstResponder()
//        self.PW_textfield.becomeFirstResponder()
        
        // 키보드 숨김
        // 텍스트필드에 해당하는 반응을 해제합니다 -> resign
        self.ID_textfield.resignFirstResponder()
        self.PW_textfield.resignFirstResponder()
        //빈화면 클릭시 텍스트 커서를 없애줌 -> SOPT
        //빈화면 클릭시 키보드 내려줌 -> Naver
    }
    
    // 이건뭐지 ?
    
    func gestureRecognizer(_ gestureRecognizer : UIGestureRecognizer, shouldReceive touch : UITouch) -> Bool{
        if(touch.view?.isDescendant(of: ID_textfield))! || (touch.view?.isDescendant(of: PW_textfield))!{
            return false
        }
        return true
    }
    //키보드 높이에 따른 뷰 조절
    @objc func keyboardWillShow(notification: NSNotification) {
        if check{
            //화면에 나타나는 키보드의 frame 값을 옵셔널 바인딩해서 가져옵니다.
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                var keyboard_height = keyboardSize.height
                //키보드 높이만큼 모든 객체 위로 옮겨줌
                
//                LogIn_btn.frame.origin.y -= keyboard_height
//                ID_textfield.frame.origin.y -= keyboard_height
//                PW_textfield.frame.origin.y -= keyboard_height
//                shinJJang_img.frame.origin.y -= keyboard_height

                self.view.frame = CGRect(x:0, y:-keyboard_height, width:self.view.frame.width, height: self.view.frame.height)
                check = false
                
                //뷰가 바뀌었을때 오토레이아웃 바로 반영해주는것
//                view.layoutIfNeeded()
                print("show")
            }//if let keyboardSize
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboard_height = keyboardSize.height
            //키보드 높이만큼 모든 객체 위로 옮겨줌
//            LogIn_btn.frame.origin.y += keyboard_height
//            ID_textfield.frame.origin.y += keyboard_height
//            PW_textfield.frame.origin.y += keyboard_height
//            shinJJang_img.frame.origin.y += keyboard_height
            
            // 모든 객체를 옮기는 것 보다 view frame 을 옮겨서 전체 틀을
            // 옮기는게 더 편하고 직관적, 실수할 일도 없음.
            self.view.frame = CGRect(x:0, y:0, width:self.view.frame.width, height: self.view.frame.height)
            
            check = true
            //뷰가 바뀌었을때 오토레이아웃 바로 반영해주는것
//            view.layoutIfNeeded()
            print("hide")
        }
        
    }
    
    //키보드가 올라오는 순간을 캐치하는 함수
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        print("keyboardUP")
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:.UIKeyboardWillHide, object: nil)
        print("keyboardDOWN")
    }
    
    func simpleAlert(title:String, message msg:String){
        let alert = UIAlertController(title: title, message:msg,preferredStyle : .alert)
        let okAction = UIAlertAction(title:"확인",style:.default)
        //취소선택 버튼은 다음과 같이 만들수 있습니다
        let cancelAction = UIAlertAction(title:"취소",style:.cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert,animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(
            _:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        // return 누를시 키보드 dismiss
        self.ID_textfield.delegate = self
        self.PW_textfield.delegate = self
        
    }

}
