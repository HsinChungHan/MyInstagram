//
//  UserProfileViewController.swift
//  Instagram
//
//  Created by 辛忠翰 on 12/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Firebase
class UserProfileViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationItem.title = "User Profile"
        fetchUser()
    }
    fileprivate func fetchUser() {
        guard let currentUserId = Auth.auth().currentUser?.uid else{return}
        let ref = Database.database().reference().child("users").child("\(currentUserId)")
        //.value:取得值
        ref.observe(.value, with: { (snapshot) in
            print(snapshot.value ?? "")
            guard let dictionary = snapshot.value as? [String : Any] else {return}
                if let email = dictionary["email"] as? String{
                    print("email is ", email)
                }
                if let userName = dictionary["userName"] as? String{
                    self.navigationItem.title = userName
                }
            
        }) { (error) in
            print("Failed to fetch user: ", error)
        }
    }
}











