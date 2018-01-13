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
//        let attributedText = NSMutableAttributedString(string: "Don't have an acoount? ", attributes: [
//            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12),
//            NSAttributedStringKey.foregroundColor : UIColor.lightGray.cgColor
//            ])
//        attributedText.append(NSMutableAttributedString(string: "Sign Up.", attributes: [
//            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),
//            NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237).cgColor
//            ]))
//        btn.setAttributedTitle(attributedText, for: .normal)
        btn.setTitle("Don't have an acoount? Sign Up.", for: .normal)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupSignUpButton()
    }
    
    fileprivate func setupSignUpButton() {
        view.addSubview(signUpButton)
        view.backgroundColor = .white
        signUpButton.anchor(top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -10, left: view.leftAnchor, leftPadding: 0, right: view.rightAnchor, rightPadding: 0, width: 0, height: 0)
    }
}
