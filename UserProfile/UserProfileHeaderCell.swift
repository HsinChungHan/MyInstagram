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
    var user: TheUser? {
        didSet{
            userNameLabel.text = user?.userName
            guard let imgUrlStr = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: imgUrlStr)
            setupFollowButton()
        }
    }
    
    fileprivate func setupFollowButton(){
        guard let userId = user?.uid else {return}
        if userId == Auth.auth().currentUser?.uid{
            
        }else{
            //check if following
            checkIsFollowingUser(userId: userId, isFollowingCompletionHandler: {
                self.setupUnfollowStyle()
            }, noFollowingCompletionHandler: {
                self.setupFollowStyle()
            })
        }
        
    }
    
    fileprivate func checkIsFollowingUser(userId: String, isFollowingCompletionHandler: @escaping () -> (), noFollowingCompletionHandler: @escaping () -> ()){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let dbRef = Database.database().reference().child("followings").child(currentUserId).child(userId)
        dbRef.observe(.value, with: { (snapshot) in
            if let isFollowing = snapshot.value as? Int, isFollowing == 1{
                isFollowingCompletionHandler()
            }else{
                noFollowingCompletionHandler()
            }
        }) { (error) in
            print("Failed to fetch the followings from DB: ", error)
        }
    }
    
    @objc func handleEditProfileOrFollow(){
        guard let userId = user?.uid else {return}
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        if userId != currentUserId{
           
            if editPorfileFollowButton.titleLabel?.text == "follow"{
                 //follow user
                let dbRef = Database.database().reference().child("followings").child(currentUserId)
                let values: [String : Any] = [
                    userId : 1
                ]
                dbRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if let err = error{
                        print("Failed to follow user: ",err.localizedDescription)
                        return
                    }
                    print("Successfully followed user!")
                    self.setupUnfollowStyle()
                })
            }else{
                //unfollow user
                let dbRef = Database.database().reference().child("followings").child(currentUserId).child(userId)
                dbRef.removeValue(completionBlock: { (error, ref) in
                    if let err = error{
                        print("Faile to unfollow user: ", err.localizedDescription)
                        return
                    }
                    print("Successfully unfollowed user!")
                    self.setupFollowStyle()
                })
            }
            
        }else{
            print("edit")
        }
    }
    
    private func setupFollowStyle(){
        self.editPorfileFollowButton.setTitle("follow", for: .normal)
        self.editPorfileFollowButton.setBackgroundColor(color: .rgb(red: 17, green: 154, blue: 237), forUIControlState: .normal)
        self.editPorfileFollowButton.setTitleColor(.white, for: .normal)
        self.editPorfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    private func setupUnfollowStyle(){
        self.editPorfileFollowButton.setTitle("Unfollow", for: .normal)
        self.editPorfileFollowButton.setBackgroundColor(color: .white, forUIControlState: .normal)
        self.editPorfileFollowButton.setTitleColor(.black, for: .normal)
        self.editPorfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor

    }
    
    let profileImageView: CustomImageView = {
       let imgView = CustomImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let topDividerView: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let bottomDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    let gridButton: UIButton = {
       let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "grid"), for: .normal)
        return btn
    }()
    
    let listButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "list"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    
    let bookMarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "ribbon"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    
    let userNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "posts", attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor : UIColor.lightGray
            ]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)
            ])
        attributedText.append(NSMutableAttributedString(string: "followers", attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor : UIColor.lightGray
            ]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let followingsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)
            ])
        attributedText.append(NSMutableAttributedString(string: "followings", attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor : UIColor.lightGray
            ]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    //因為當我們更改了btn上的title時，便需要等到都更動完後，才去設定editPorfileFollowButton，如此一來，才可以觸動
    //func handleEditProfileOrFollow()
    lazy var editPorfileFollowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 5.0
        btn.clipsToBounds = true
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return btn
    }()
    
    
    
    override func setupViews() {
        setupImageView()
        setupButtonToolBar()
        setupUserNameLabel()
        setupUserStatsView()
        setupEditProfileButton()
    }
    
    fileprivate func setupImageView() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, topPadding: 12, bottom: nil, bottomPadding: 0, left: leftAnchor, leftPadding: 12, right: nil, rightPadding: 0, width: 80, height: 80)
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = 40
        //與profileImageView.clipsToBounds一樣
        profileImageView.layer.masksToBounds = true
    }
    
    
    
    fileprivate func setupUserNameLabel() {
        addSubview(userNameLabel)
        userNameLabel.anchor(top: profileImageView.bottomAnchor, topPadding: 4, bottom: listButton.topAnchor, bottomPadding: 0, left: leftAnchor, leftPadding: 12, right: rightAnchor, rightPadding: 12, width: 0, height: 0)
    }
    
    fileprivate func setupButtonToolBar() {
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookMarkButton])
        addSubview(stackView)
        stackView.anchor(top: nil, topPadding: 0, bottom: bottomAnchor, bottomPadding: 0, left: leftAnchor, leftPadding: 0, right: rightAnchor, rightPadding: 0, width: 0, height: 50)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        addSubview(topDividerView)
        topDividerView.anchor(top: stackView.topAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, left: stackView.leftAnchor, leftPadding: 0, right: stackView.rightAnchor, rightPadding: 0, width: 0, height: 1)
        
        addSubview(bottomDividerView)
        bottomDividerView.anchor(top: nil, topPadding: 0, bottom: stackView.bottomAnchor, bottomPadding: 0, left: leftAnchor, leftPadding: 0, right: rightAnchor, rightPadding: 0, width: 0, height: 1)
    }
    
    fileprivate func setupUserStatsView(){
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingsLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: profileImageView.topAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, left: profileImageView.rightAnchor, leftPadding: 12, right: rightAnchor, rightPadding: 12, width: 0, height: 0)
        stackView.heightAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    fileprivate func setupEditProfileButton(){
        addSubview(editPorfileFollowButton)
        editPorfileFollowButton.anchor(top: postLabel.bottomAnchor, topPadding: 12, bottom: profileImageView.bottomAnchor, bottomPadding: 0, left: profileImageView.rightAnchor, leftPadding: 10, right: rightAnchor, rightPadding: 10, width: 0, height: 0)
    }
    
    
}


