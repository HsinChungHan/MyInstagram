//
//  UserProfileHeaderCell.swift
//  Instagram
//
//  Created by 辛忠翰 on 12/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Firebase
class UserProfileHeaderCell: BasicCell {
    
    let profileImageView: UIImageView = {
       let imgView = UIImageView()
        imgView.backgroundColor = .red
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    override func setupViews() {
        backgroundColor = .gray
        setupImageView()
    }
    
    func setupImageView() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, topPadding: 12, bottom: nil, bottomPadding: 0, left: leftAnchor, leftPadding: 12, right: nil, rightPadding: 0, width: 80, height: 80)
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = 40
        //與profileImageView.clipsToBounds一樣
        profileImageView.layer.masksToBounds = true
        
        
    }
    var user: CurrentUser? {
        didSet{
            setupProfileImage()
        }
    }
    fileprivate func setupProfileImage(){
        guard let user = self.user else {
            print("No user QQ ")
            return
        }
        print("user: ", user)
        guard let imageUrl = URL(string: user.profileImageUrl) else {
            print("no url")
            return
            
        }
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let err = error {
                print("Failed to get img url: ",err)
                return
            }
            guard let data = data else{
                print("no data")
                return
            }
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
