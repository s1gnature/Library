//
//  UploadVC.swift
//  FirebaseLogin
//
//  Created by mong on 20/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

let DBRef = Database.database().reference()
let firebaseStorage = Storage.storage()

class UploadVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var subjectTextField: UITextField!
    @IBOutlet var explainTextField: UITextField!
    
    
    @IBAction func UploadBtn(_ sender: Any) {
        uploadToFirebase()
    }
    
    @objc func openImagePicker(){
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.imageView.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
    }
    
    
    func uploadToFirebase(){
        let image = imageView.image?.jpegData(compressionQuality: 0.5)
        let imageName = Auth.auth().currentUser!.uid + "\(Int(NSDate.timeIntervalSinceReferenceDate * 1000)).jpg"
        let testImageName = "test!!"
        
        // firebase 저장소 생성
        let storageRef = firebaseStorage.reference().child("ios_firebase_imageUpload").child(imageName)
        
        let uploadTask = storageRef.putData(image!, metadata: nil) { (metadata, error) in
            if (error != nil) {
                
            }
            else{
                
            }
            let downloadURL = storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
  
                // child 해줄때 string 길이의 한계가 있는듯. 근데 childbyAutoID 에서는 길이가 상관이없는데.. 왜그럴까
                // 이거 경로상 특수문자가 포함이 되면 안되는듯! 그래서 email을 child로는 포함이 안되고 uid로는 가능한거같다!
                DBRef.child("users").child((Auth.auth().currentUser?.uid)!).setValue([
                    "userID": Auth.auth().currentUser?.email,
                    "uID": Auth.auth().currentUser?.uid,
                    "subject": self.subjectTextField.text!,
                    "explanation": self.explainTextField.text!,
                    "imageURL": "\(downloadURL)",
                    "imageName": imageName,
                    "starCount": 0
                    ])
            }
        }
        
        
        
        
        
            let alert = UIAlertController.init(title: "", message: "전송 완료🥰", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "확인", style: .default, handler: {(_) in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImagePicker)))
        imageView.isUserInteractionEnabled = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
