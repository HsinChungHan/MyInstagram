//
//  User.swift
//  Instagram
//
//  Created by 辛忠翰 on 12/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import Foundation
class MyUser: Codable {
    let email , password , profileImageUrl , userName  : String
    init(email: String, password: String, profileImageUrl: String, userName: String) {
        self.email = email
        self.password = password
        self.profileImageUrl = profileImageUrl
        self.userName = userName
    }
}
