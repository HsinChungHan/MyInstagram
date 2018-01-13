//
//  LogInViewController.swift
//  Instagram
//
//  Created by 辛忠翰 on 10/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class LogInViewController: UIViewController{
    let signUpButton: UIButton = {
       let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an acoount? ", attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor : UIColor.lightGray
            ])
        attributedTitle.append(NSMutableAttributedString(string: "Sign up.", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)
            ]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    @objc func handleSignUpButton(){
        DispatchQueue.main.async {
            let signUpVC = SignUpViewController()
            //只有這行無法push過去，因為navigationController此時為nil，因為此時我們是在ViewController，所以我們的NavigationController為nil。所以我們在TabBarViewController呼叫LogInViewController時要順便把它包進去NaviGationController
            //print(navigationController) => navigationController: nil
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        let logogoImageView = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        logogoImageView.contentMode = .scaleAspectFill
        logogoImageView.clipsToBounds = true
        view.addSubview(logogoImageView)
        logogoImageView.anchor(top: nil, topPadding: 0, bottom: nil, bottomPadding: 0, left: nil, leftPadding: 0, right: nil, rightPadding: 0, width: 200, height: 50)
        logogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
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
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 &&
            passwordTextField.text?.characters.count ?? 0 > 0
        if isFormValid{
            logInButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            logInButton.isEnabled = true
        }else{
            logInButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            logInButton.isEnabled = false
        }
    }
    
    
    let logInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 5.0
        btn.layer.masksToBounds = true
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(handleLogInButton), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    @objc func handleLogInButton(){
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Failed to log in: ", err.localizedDescription)
                return
            }
            guard let user = user else {return}
            print("Sucessfully log in: ", user.uid)
            //因為在mainTabBarViewController的setupViewController()放在viewDidLoad中，只會被call到一次，當再重新到
            //mainTabBarViewController時，就不會被call到了，所以我們現在要強迫它在call一次setupViewController()
            //我覺得效用與viewWillAppear相似
            //這邊的rootViewController = MainTabBarViewController()因為在Appdelegate中有設定過
            guard let mainTabBarVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
            mainTabBarVC.setupViewController()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: UIViewController's life function
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupLogoView()
        setupInputs()
        setupSignUpButton()
        
    }
    
    fileprivate func setupLogoView(){
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, left: view.leftAnchor, leftPadding: 0, right: view.rightAnchor, rightPadding: 0, width: 0, height: 150)
    }
    
    fileprivate func setupInputs(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, logInButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, topPadding: 20, bottom: nil, bottomPadding: 0, left: view.leftAnchor, leftPadding: 40, right: view.rightAnchor, rightPadding: 40, width: 0, height: 150)
    }
    
    
    fileprivate func setupSignUpButton() {
        view.addSubview(signUpButton)
        view.backgroundColor = .white
        signUpButton.anchor(top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -10, left: view.leftAnchor, leftPadding: 0, right: view.rightAnchor, rightPadding: 0, width: 0, height: 0)
    }
    
    //讓我們的statusbar變白色的字
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
    
}
