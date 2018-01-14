//
//  PhotoSelectorCell.swift
//  Instagram
//
//  Created by 辛忠翰 on 14/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit

class PhotoSelectorCell: BasicCell {
    var image: UIImage?{
        willSet{
            imageView.image = newValue
        }
    }
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "irene")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override func setupViews() {
        setupImageView()
    }
    
    fileprivate func setupImageView(){
        addSubview(imageView)
        imageView.fullAnchor(super: self)
    }
}
