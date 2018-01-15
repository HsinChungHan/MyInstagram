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
    let creationDate: Date?
    let height: Int
    let width: Int
    let postImageUrl: String
    
    init(dictionary: [String : Any]) {
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.caption = dictionary["postImageUrl"] as? String ?? ""
        self.height = dictionary["height"] as? Int ?? 0
        self.width = dictionary["width"] as? Int ?? 0
        self.creationDate = dictionary["creationDate"] as? Date
    }
    
}
