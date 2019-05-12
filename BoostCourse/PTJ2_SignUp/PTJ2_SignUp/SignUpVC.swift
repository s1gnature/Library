//
//  SignUpVC.swift
//  PTJ2_SignUp
//
//  Created by mong on 12/05/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var IDTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordCheckTextField: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var introduceTextField: UITextField!
    @IBOutlet var nextBtn: UIButton!
    
    var isImagePicked: Bool = false
    
    @objc func imagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        isImagePicked = true
        profileImageView.image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true, completion: isValid)
    }
    			
    @IBAction func nextBtn(_ sender: Any) {
        
        UserInformation.shared.ID = IDTextField.text!
        UserInformation.shared.Password = passwordCheckTextField.text!
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoVC
        present(nextVC, animated: true, completion: nil)
    }
    @IBAction func cancelBtn(_ sender: Any) {
        UserInformation.shared.reset()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func isValid(){
        if((passwordCheckTextField.text == passwordTextField.text) && !(IDTextField.text?.isEmpty)!) && isImagePicked{
            nextBtn.isEnabled = true
        }else{
            nextBtn.isEnabled = false
        }
        if((passwordTextField.text?.isEmpty)! || (passwordCheckTextField.text?.isEmpty)!){
            nextBtn.isEnabled = false
        }
    }
    
    
    override func viewDidLoad() {
        ///
        nextBtn.isEnabled = false

        IDTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        passwordCheckTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
    }
    
}
