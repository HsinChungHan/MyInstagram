//
//  Comment.swift
//  Instagram
//
//  Created by 辛忠翰 on 23/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import Foundation
class Comment  {
    let text: String
    let creationDate: Date
    let user: TheUser
    init(user: TheUser, dictionary: [String : Any]) {
        self.text = dictionary["comment"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        self.user = user
    }
}
