//
//  UserProfileCell.swift
//  Instagram
//
//  Created by 辛忠翰 on 15/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: BasicCell {
    var post: Post?{
        didSet{
            guard let imgUrlStr = post?.postImageUrl else{return}
            imageView.loadImage(urlString: imgUrlStr)
        }
    }
    
    lazy var imageView: CustomImageView = {
       let imgView = CustomImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        if let post = post{
            imgView.loadImage(urlString: post.postImageUrl)
        }
        return imgView
    }()
    
    override func setupViews() {
        setupImageView()
    }
    
    private func setupImageView(){
        addSubview(imageView)
        imageView.fullAnchor(super: self)
    }
}
