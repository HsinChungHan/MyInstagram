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
            fetchUserPostImage()
        }
    }
    
    let imageView: UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override func setupViews() {
        setupImageView()
    }
    
    private func setupImageView(){
        addSubview(imageView)
        imageView.fullAnchor(super: self)
    }
    
    fileprivate func fetchUserPostImage(){
        guard let imgUrlStr = post?.postImageUrl else {return}
        guard let url = URL(string: imgUrlStr) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error{
                print("Failed to download the post image: ", err)
            }
            guard let data = data else {
                print("No post image data!!")
                return
            }
            guard let image = UIImage(data: data) else {return}
            DispatchQueue.main.async {
                self.imageView.image = image
            }
            }.resume()
    }
}
