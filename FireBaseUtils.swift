//
//  FireBaseUtils.swift
//  Instagram
//
//  Created by 辛忠翰 on 17/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import Firebase
extension Database{
    static func fetchOrderPostsWithUID(user: TheUser, uid: String, completionHandler: @escaping (_ post: Post) -> ()){
        let dbRef = Database.database().reference(fromURL: DB_BASEURL).child("posts").child(uid)
        dbRef.queryOrdered(byChild: "creationDate").observe(.childAdded , with: { (snapshot) in
            //snapshot.key是所有的postId，snapshot.value就是每個post的內容
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let post = Post.init(dictionary: dictionary, user: user)
            completionHandler(post)
        }) { (error) in
            print("Failed to fetch the posts form DB: ", error.localizedDescription)
        }
    }
    
    static func fetchUserWithUID(uid: String, completionHandler:@escaping (_ user: TheUser)->()) {
        let dbRef = Database.database().reference(fromURL: DB_BASEURL)
        dbRef.child("users").child(uid).observe(.value, with: { (snapshot) in
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

