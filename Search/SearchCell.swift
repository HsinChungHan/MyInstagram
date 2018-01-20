//
//  SearchCell.swift
//  Instagram
//
//  Created by 辛忠翰 on 17/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit

class SearchCell: BasicCell {
    var user: TheUser?{
        didSet{
            guard let profileImageUrl = user?.profileImageUrl else {return}
            userProfileImageView.loadImage(urlString: profileImageUrl)
            guard let name = user?.userName else {return}
            userNameLabel.text = name
        }
    }
    
    
    let userProfileImageView: CustomImageView = {
        let civ = CustomImageView()
        civ.scaleAspectFill()
        civ.image = UIImage(named: "irene")
        return civ
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Irene"
        label.textColor = .black
        return label
    }()
    
    let postsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "1 Posts"
        label.textColor = .lightGray
        return label
    }()
    
    let seperateView: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func setupViews() {
        backgroundColor = .white
        setupUserProfileImageView()
        setupLabels()
        
        
        
    }
    
    fileprivate func setupUserProfileImageView(){
        addSubview(userProfileImageView)
        userProfileImageView.anchor(top: nil, topPadding: 0, bottom: nil, bottomPadding: 0, left: leftAnchor, leftPadding: 8, right: nil, rightPadding: 0, width: 50, height: 50)
        userProfileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        userProfileImageView.layoutIfNeeded()
        userProfileImageView.beRoundImage(radius: userProfileImageView.frame.width)
    }
    
    fileprivate func setupLabels(){
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, postsCountLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: userProfileImageView.topAnchor, topPadding: 0, bottom: userProfileImageView.bottomAnchor, bottomPadding: 0, left: userProfileImageView.rightAnchor, leftPadding: 8, right: rightAnchor, rightPadding: 8, width: 0, height: 0)
       
        addSubview(seperateView)
        seperateView.anchor(top: nil, topPadding: 0, bottom: bottomAnchor, bottomPadding: 0, left: stackView.leftAnchor, leftPadding: 0, right: stackView.rightAnchor, rightPadding: 0, width: 0, height: 1)
    }
}
