//
//  Post.swift
//  Instagram
//
//  Created by 辛忠翰 on 15/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import Foundation
import UIKit
class Post{
    let caption: String
    let creationDate: Date
    let height: Int
    let width: Int
    let postImageUrl: String
    let user: TheUser
    let postId: String
    
    
    
    init(dictionary: [String : Any], user: TheUser, postId: String) {
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.height = dictionary["height"] as? Int ?? 0
        self.width = dictionary["width"] as? Int ?? 0
        self.user = user
        self.postId = postId ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
    
}
