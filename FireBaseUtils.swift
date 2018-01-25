//
//  FireBaseUtils.swift
//  Instagram
//
//  Created by 辛忠翰 on 17/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import Firebase
extension Database{
    
    static func fetchUserWithUID(uid: String, completionHandler:@escaping (_ user: TheUser)->()) {
        let dbRef = Database.database().reference().child("users").child(uid)
        dbRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            if let userName = dictionaries["userName"] as? String,
                let profileImgUrl = dictionaries["profileImageUrl"] as? String{
                
                let user = TheUser(uid: uid, dictionary:
                    ["userName" : userName,
                     "profileImageUrl": profileImgUrl
                    ])
                completionHandler(user)
            }
        }) { (error) in
            print("Failed to fetch who post: ", error)
        }
        
    }
}

