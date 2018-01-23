//
//  CommentCell.swift
//  Instagram
//
//  Created by 辛忠翰 on 21/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Firebase
class CommentCell: BasicCell {
    var post: Post?{
        didSet{
            guard let caption = post?.caption else {return}
            commentTextView.text = caption
            guard let currentUser = post?.user else {return}
            userProfileImageView.loadImage(urlString: currentUser.profileImageUrl)
            print(currentUser.userName)
            setupAttributedCommentText(name: currentUser.userName, commentText: caption)
        }
    }
    
    var comment: Comment?{
        didSet{
            guard let userId = comment?.user.uid else {return}
            fetchLoadCommentProfileImg(uid: userId)
            guard let commentText = comment?.text else {return}
            commentTextView.text = commentText
            guard let userName = comment?.user.userName else {return}
            setupAttributedCommentText(name: userName , commentText: commentText)
        }
    }
    
    fileprivate func setupAttributedCommentText(name: String, commentText: String){
        let attributedText = NSMutableAttributedString(string: name, attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)
            ])
        attributedText.append(NSMutableAttributedString(string: " \(commentText)", attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)
            ]))
        commentTextView.attributedText = attributedText
    }
    
    
    fileprivate func fetchLoadCommentProfileImg(uid: String){
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.userProfileImageView.loadImage(urlString: user.profileImageUrl)
        }
    }
    
    let userProfileImageView: CustomImageView = {
        let civ = CustomImageView()
        civ.backgroundColor = .lightGray
        civ.scaleAspectFill()
        return civ
    }()
    
    let commentTextView: UITextView = {
       let textView = UITextView()
        textView.text = "Types sth here..."
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.isScrollEnabled = false
        return textView
    }()
    
    let seperateView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    override func setupViews() {
        backgroundColor = .white
        setupUserProfileImageView()
        setupCommentLabel()
        setupSeperateView()
    }
    
    fileprivate func setupUserProfileImageView(){
        addSubview(userProfileImageView)
        userProfileImageView.anchor(top: nil, topPadding: 0, bottom: nil, bottomPadding: 0, left: leftAnchor, leftPadding: 8, right: nil, rightPadding: 0, width: 44, height: 44)
        userProfileImageView.layoutIfNeeded()
        userProfileImageView.beRoundImage(length: userProfileImageView.frame.height)
    }
    
    fileprivate func setupCommentLabel(){
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, topPadding: 8, bottom: bottomAnchor, bottomPadding: -8, left: userProfileImageView.rightAnchor, leftPadding: 8, right: rightAnchor, rightPadding: 8, width: 0, height: 0)
        userProfileImageView.topAnchor.constraint(equalTo: commentTextView.topAnchor).isActive = true
    }
    
    fileprivate func setupSeperateView(){
        addSubview(seperateView)
        seperateView.anchor(top: nil, topPadding: 0, bottom: bottomAnchor, bottomPadding: 0, left: commentTextView.leftAnchor, leftPadding: 0, right: rightAnchor, rightPadding: 0, width: 0, height: 1)
    }
}
