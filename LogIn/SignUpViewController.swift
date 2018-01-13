//
//  SignUpViewController.swift
//  Instagram
//
//  Created by 辛忠翰 on 13/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class SignUpViewController: UIViewController{
    
    lazy var plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal) , for: .normal)
        btn.addTarget(self, action: #selector(handlePlusPhototButton), for: .touchUpInside)
        return btn
    }()
    @objc func handlePlusPhototButton(){
        let imgPickerController = UIImagePickerController()
        //要同時有UIImagePickerControllerDelegate, UINavigationControllerDelegate才可使用
        imgPickerController.delegate = self
        //可以再選取照片的同時裁切照片
        imgPickerController.allowsEditing = true
        //要到info.plist中加入"Privacy - Photo Library Usage Description"向使用者詢問取得進入photo library 的權限
        present(imgPickerController, animated: true, completion: nil)
    }
    
    
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        //0: black, 1: white
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && userNameTextField.text?.characters.count ?? 0 > 0 &&
            passwordTextField.text?.characters.count ?? 0 > 0
        if isFormValid{
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            signUpButton.isEnabled = true
        }else{
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            signUpButton.isEnabled = false
        }
    }
    
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "UserName"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 5.0
        btn.layer.masksToBounds = true
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(handleSignInButton), for: .touchUpInside)
        //先預設btn一開始都不能按，一直等到user把表格全填完才可按
        btn.isEnabled = false
        return btn
    }()
    @objc func handleSignInButton(){
        
        guard let name = userNameTextField.text, name.characters.count > 0,
            let email = emailTextField.text, email.characters.count > 0,
            let password = passwordTextField.text, password.characters.count > 0
            else {
                print("Check the form!")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if err != nil{
                print("Fail to create user: ",err.debugDescription)
                return
            }
            print("Successfully created user!!")
            guard let user = user else{return}
            guard let image = self.plusPhotoButton.imageView?.image else {return}
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
            guard let userName = self.userNameTextField.text else{return}
            let imageName = userName + "--" + NSUUID().uuidString
            //這邊要加入storage的url
            let storageRef = Storage.storage().reference(forURL: "gs://instagram-ee809.appspot.com/").child("profile_image--\(imageName).jpg")
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err{
                    print("Failed to upload imaage into db: ", err)
                    return
                }
                guard let profileImgUrl = metadata?.downloadURL()?.absoluteString else{return}
                print("Successfully upload profile image: ", profileImgUrl)
                
                //upload user information into DB
                let dbRef = Database.database().reference(fromURL: "https://instagram-ee809.firebaseio.com/")
                let usersRef = dbRef.child("users").child(user.uid)
                let dictionaryValues = ["userName" : name, "email" : email, "password" : password, "profileImageUrl" : profileImgUrl]
                usersRef.updateChildValues(dictionaryValues, withCompletionBlock: { (err, ref) in
                    if err != nil{
                        print("Failed to save user info into db: ", err.debugDescription)
                        return
                    }
                    print("Successfully to save user info into db.")
                    self.readRef(user: user)
                    
                    guard let mainTabBarVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                    DispatchQueue.main.async {
                        mainTabBarVC.setupViewController()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            })
            
            
            
        }
    }
    fileprivate func readRef(user: User) {
        let ref = Database.database().reference(fromURL: "https://instagram-ee809.firebaseio.com/")
        let userRef = ref.child("users").child(user.uid)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else{return}
            guard let userName = value["userName"] else{return}
            guard let email = value["email"] else{return}
            guard let password = value["password"] else{return}
            print("userName: ",userName)
            print("email: ",email)
            print("password: ",password)
            
        }
    }
    
    let logInButton: UIButton = {
        let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an acoount? ", attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor : UIColor.lightGray
            ])
        attributedTitle.append(NSMutableAttributedString(string: "Sign in.", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)
            ]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(handleLogInButton), for: .touchUpInside)
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    @objc func handleLogInButton(){
            _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setupAddPhotoButton()
        setupStackView()
        setupLogInButton()
    }
    
    fileprivate func setupAddPhotoButton() {
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.anchor(top: view.topAnchor, topPadding: 64, bottom: nil, bottomPadding: 0, left: nil, leftPadding: 0, right: nil, rightPadding: 0, width: 140, height: 140)
    }
    
    fileprivate func setupStackView(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, topPadding: 20, bottom: nil, bottomPadding: 0, left: view.leftAnchor, leftPadding: 40, right: view.rightAnchor, rightPadding: 40, width: 0, height: 200)
    }
    
    fileprivate func setupLogInButton(){
        view.addSubview(logInButton)
        logInButton.anchor(top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -10, left: view.leftAnchor, leftPadding: 0, right: view.rightAnchor, rightPadding: 0, width: 0, height: 0)
    }
}



extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            plusPhotoButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusPhotoButton.layoutIfNeeded()
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.height/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.gray.cgColor
        plusPhotoButton.layer.borderWidth = 1.0
        dismiss(animated: true, completion: nil)
    }
}

