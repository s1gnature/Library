//
//  UserVC.swift
//  FirebaseLogin
//
//  Created by mong on 18/04/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class UserVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBAction func LogoutBtn(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        } catch{
            print("[UserVC]error in logout")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profileUploadBtn(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage).pngData()!
        let imageName = Auth.auth().currentUser!.uid + "\(Int(NSDate.timeIntervalSinceReferenceDate * 1000)).jpg"
        let testImageName = "test!!"
        
        // firebase 저장소 생성
        let firebaseStorage = Storage.storage()
        let storageRef = firebaseStorage.reference().child("ios_fireabase_imageUpload").child(imageName)
        
        let uploadTask = storageRef.putData(image, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        dismiss(animated: true, completion: {
            let alert = UIAlertController.init(title: "", message: "전송 완료🥰", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        })
        
        

    }
    
}
