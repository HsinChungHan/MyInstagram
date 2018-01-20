//
//  HomePostCell.swift
//  Instagram
//
//  Created by 辛忠翰 on 16/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit

class HomePostCell: BasicCell {
    var post: Post?{
        didSet{
            guard let photoImgUrl = post?.postImageUrl else {return}
            
            photoImageView.loadImage(urlString: photoImgUrl)
            
            guard let userName =  post?.user.userName else {return}
            
            userNameLabel.text = userName
            
            guard let profileImgUrl = post?.user.profileImageUrl else {return}
            
            userProfileImageView.loadImage(urlString: profileImgUrl)
            
            guard let post = post else {return}
            setupAttributedCaption(post: post)
            
        }
    }
    fileprivate func setupAttributedCaption(post: Post){
        let userName = post.user.userName
        let caption = post.caption
        
        let attributedText = NSMutableAttributedString(string: userName, attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)
            ])
        attributedText.append(NSMutableAttributedString(string: " \(caption)", attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)
            ]))
        
        //在文章和creation time 中間創造一個小段落
        attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 4)
            ]))
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSMutableAttributedString(string: "\(timeAgoDisplay)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),
             NSAttributedStringKey.foregroundColor : UIColor.gray
            ]))
        captionLabel.attributedText = attributedText
    }
    
    
    let userStateView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return view
    }()
    
    let userProfileImageView: CustomImageView = {
       let civ = CustomImageView()
        civ.scaleAspectFill()
        civ.backgroundColor = .gray
        return civ
    }()
    
    let userNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Irene"
        label.textColor = .black
        return label
    }()
    
    let optionButton: UIButton = {
       let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    let photoImageView: CustomImageView = {
        let civ = CustomImageView()
        civ.scaleAspectFill()
        return civ
    }()
    
    let actionButtonsView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return view
    }()
    
    let likeButton: UIButton = {
       let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal) , for: .normal)
        return btn
    }()
    
    let commentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "send")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let ribbonButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    lazy var captionLabel: UILabel = {
        let label = UILabel()
        if let userName = userNameLabel.text{
           
        }
        
        label.numberOfLines = 0
        return label
    }()
    
    
    
    override func setupViews() {
        setupUserStateView()
        setupPhotoImageView()
        setupActionButtonsView()
        setupCaptionLabel()
    }
    
    fileprivate func setupUserStateView(){
        addSubview(userStateView)
        userStateView.anchor(top: topAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, left: leftAnchor, leftPadding: 0, right: rightAnchor, rightPadding: 0, width: 0, height: 50)
        
        userStateView.addSubview(userProfileImageView)
        userProfileImageView.anchor(top: nil, topPadding: 0, bottom: nil, bottomPadding: 0, left: userStateView.leftAnchor, leftPadding: 8, right: nil, rightPadding: 0, width: 40, height: 40)
        userProfileImageView.centerYAnchor.constraint(equalTo: userStateView.centerYAnchor).isActive = true
        userProfileImageView.layoutIfNeeded()
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
        userProfileImageView.layer.masksToBounds = true
        
        userStateView.addSubview(userNameLabel)
        userNameLabel.anchor(top: nil, topPadding: 0, bottom: nil, bottomPadding: 0, left: userProfileImageView.rightAnchor, leftPadding: 8, right: rightAnchor, rightPadding: 60, width: 0, height: 0)
        userNameLabel.centerYAnchor.constraint(equalTo: userStateView.centerYAnchor).isActive = true
        
        userStateView.addSubview(optionButton)
        optionButton.anchor(top: nil, topPadding: 0, bottom: nil, bottomPadding: 0, left: nil, leftPadding: 0, right: rightAnchor, rightPadding: 8, width: 40, height: 0)
        optionButton.centerYAnchor.constraint(equalTo: userStateView.centerYAnchor).isActive = true
    }
    
    fileprivate func setupPhotoImageView(){
        addSubview(photoImageView)
        photoImageView.anchor(top: userStateView.bottomAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, left: leftAnchor, leftPadding: 0, right: rightAnchor, rightPadding: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
    }
    
    
    
    fileprivate func setupActionButtonsView(){
        addSubview(actionButtonsView)
        actionButtonsView.anchor(top: photoImageView.bottomAnchor , topPadding: 0, bottom: nil, bottomPadding: 0, left: leftAnchor, leftPadding: 0, right: rightAnchor, rightPadding: 0, width: 0, height: 50)
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        actionButtonsView.addSubview(stackView)
        stackView.anchor(top: actionButtonsView.topAnchor, topPadding: 0, bottom: actionButtonsView.bottomAnchor, bottomPadding: 0, left: actionButtonsView.leftAnchor, leftPadding: 8, right: nil, rightPadding: 0, width: 120, height: 0)
        
        actionButtonsView.addSubview(ribbonButton)
        ribbonButton.anchor(top: actionButtonsView.topAnchor , topPadding: 0, bottom: actionButtonsView.bottomAnchor, bottomPadding: 0, left: nil, leftPadding: 0, right: rightAnchor, rightPadding: 8, width: 40, height: 0)
    }
    
    fileprivate func setupCaptionLabel(){
        addSubview(captionLabel)
        captionLabel.anchor(top: actionButtonsView.bottomAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, left: leftAnchor, leftPadding: 8, right: rightAnchor, rightPadding: 8, width: 0, height: 80)
    }
    
    
    
}
