//
//  SignUpVC.swift
//  firebaseChatApp
//
//  Created by mong on 29/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

let DBRef = Database.database().reference()
let StorageRef = Storage.storage().reference()

let networkIndicator = UIActivityIndicatorView()

class SignUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var userImageView: UIImageView!
    
    var isUserImageSelected = false
    var isExist = false
    
    @objc func imagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userImageView.image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        isUserImageSelected = true
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func CancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getValueFromDBbyAllKeys() {
        DBRef.child("ChatDB").child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as! NSDictionary
            for uid in value.allKeys{
                let child = value[uid] as! NSDictionary
                if(child["email"] != nil) {
                    let email = child["email"] as! String

                }else{ return }
            }
        })
    }
    @IBAction func SignUpBtn(_ sender: Any) {
        if((emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (nameTextField.text?.isEmpty)! ||
            !isUserImageSelected){
            let alert = UIAlertController(title: "", message: "빈칸을 확인하세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let roadingAlert = UIAlertController(title: "", message: "생성중", preferredStyle: .alert)
//        networkIndicator.center.y = self.view.frame.height / 2.0
//        networkIndicator.center.x = self.view.center.x + 30
//        networkIndicator.style = UIActivityIndicatorView.Style.gray
//        roadingAlert.view.addSubview(networkIndicator)
//        networkIndicator.startAnimating()
        present(roadingAlert, animated: true, completion: nil)
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(result, err) in
            
            // 이미 동일한 email이 존재할경우에는 예외처리.
            // err 종류마다 다양하므로 각각 분기 시켜야함. 지금은 그냥 임시로.
            print(err?.localizedDescription)
            if (err != nil) {
                roadingAlert.dismiss(animated: true, completion: nil)
                    let alert = UIAlertController(title: "", message: "이미 존재하는 email입니다😂", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
            }
            let uid = result?.user.uid
            print("####UID: " + uid!)
            let imageData = self.userImageView.image?.jpegData(compressionQuality: 0.1)
            let userStorage = StorageRef.child("userImages").child(uid!)
            let uploadTask = userStorage.putData(imageData!, metadata: nil) { (metadata, error) in
                if (error != nil) {}
                else{}
                userStorage.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        print("###ERROR : fail to init downloadURL")
                        return
                    }
                    // upload to DB
                    DBRef.child("ChatDB").child("users").child(uid!).setValue([
                        "name":self.nameTextField.text,
                        "email":self.emailTextField.text,
                        "profileImageURL":url?.absoluteString,
                        "uid":Auth.auth().currentUser?.uid
                        ])
                }
            }

        
//            networkIndicator.stopAnimating()
            roadingAlert.dismiss(animated: true, completion: nil)
            let alert = UIAlertController(title: "", message: "회원가입완료🥰", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {(_) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        })
    }
    override func viewDidLoad() {
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
    }
}
