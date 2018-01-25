//
//  CommentCollectionViewController.swift
//  Instagram
//
//  Created by 辛忠翰 on 21/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Firebase

class CommentsCollectionViewController: UICollectionViewController {

    let cellID = "CommentCell"
    var post: Post?
    var comments = [Comment]()
    let currentUserId = Auth.auth().currentUser?.uid
    var currentUser: TheUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        fetchComments()
        fetchCurrentUser()
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
    }

    
    fileprivate func setupNavigationItem(){
        collectionView?.backgroundColor = .white
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellID)
        navigationItem.title = "Comments"
    }
    
    fileprivate func fetchComments(){
        guard let postId = post?.postId else {return}
        let dbRef = Database.database().reference().child("comments").child(postId)
            dbRef.observe(.childAdded , with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                guard let uid = self.currentUserId else {return}
                Database.fetchUserWithUID(uid: uid) { (user) in
                    self.currentUser = user
                    let comment = Comment.init(user: user, dictionary: dictionary)
                    self.comments.append(comment)
                    self.collectionView?.reloadData()
                }

                
            }) { (error) in
                print("Failed to fetch comments: ", error)
            }
    }
    
    
    fileprivate func fetchCurrentUser(){
        guard let uid = currentUserId else {return}
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.currentUser = user
        }
    }
    
    //因為進來時把tabBar隱藏起來，所以返回上頁的時候要再讓tabBar顯現出來
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter comment here..."
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 2.0
        textField.setLeftPaddingPoints(10)
        return textField
    }()
    
    
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        
        let seperateView: UIView = {
           let view = UIView()
            view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
            return view
        }()
        
        containerView.addSubview(seperateView)
        seperateView.anchor(top: containerView.topAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, left: containerView.leftAnchor, leftPadding: 0, right: containerView.rightAnchor, rightPadding: 0, width: 0, height: 1)
        
        
        let profileiMageView = CustomImageView()
        if let currentUserId = currentUserId {
            Database.fetchUserWithUID(uid: currentUserId) { (currentUser) in
                DispatchQueue.main.async {
                    profileiMageView.loadImage(urlString: currentUser.profileImageUrl)
                }
            }
        }
       
        profileiMageView.backgroundColor = .lightGray
        profileiMageView.scaleAspectFill()
        containerView.addSubview(profileiMageView)
        profileiMageView.anchor(top: containerView.topAnchor, topPadding: 8, bottom: containerView.bottomAnchor, bottomPadding: -8, left: containerView.leftAnchor, leftPadding: 8, right: nil, rightPadding: 0, width: 0, height: 0)
        profileiMageView.layoutIfNeeded()
        profileiMageView.widthAnchor.constraint(equalTo: profileiMageView.heightAnchor, multiplier: 1).isActive = true
        profileiMageView.beRoundImage(length: profileiMageView.frame.height)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, topPadding: 0, bottom: containerView.bottomAnchor, bottomPadding: 0, left: nil, leftPadding: 0, right: containerView.rightAnchor, rightPadding: 8, width: 50, height: 0)
        
        
        containerView.addSubview(commentTextField)
        commentTextField.anchor(top: containerView.topAnchor, topPadding: 8, bottom: containerView.bottomAnchor, bottomPadding: -8, left: profileiMageView.rightAnchor, leftPadding: 8, right: submitButton.leftAnchor, rightPadding: 8, width: 0, height: 0)
        commentTextField.layoutIfNeeded()
        commentTextField.layer.cornerRadius = commentTextField.frame.height/2
        return containerView
    }()
    
    
    @objc func handleSubmit() {
        guard let post = post else {return}
        let values = [
            "comment" : commentTextField.text ?? "",
            "userId" : currentUserId ?? "",
            "creationDate" : Date().timeIntervalSince1970
            
            ] as [String : Any]
        //childByAutoId會讓firebase自動給一個unique id，這樣當留言存進Database時，不會因為ID一樣，而被覆蓋過去
        let dbRef = Database.database().reference().child("comments").child(post.postId).childByAutoId()
        dbRef.updateChildValues(values) { (error, reference) in
            if let err = error{
                print("Failed to update comment into DB: ", err)
                return
            }
            print("Successfully to update comment into DB!")
            
        }
    }
    
    
    
    //下面這兩個property需要同時出現才有效果
    //inputAccessoryView可以讓我們放一個區域在鍵盤頂端，算著鍵盤一起被推上來
    override var inputAccessoryView: UIView? {
        get{
            //在這邊設定containerView會有奇怪的bug，但是拉出去設containerView這個bug就消失了
            return containerView
        }
    }
    
    //把鍵盤推起來
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    
    //MARK: UICollectionViewDelegate
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CommentCell
        if indexPath.section == 0{
            guard let post = post else {return cell}
            cell.post = post
        }else if comments.count > 0{
            cell.comment = comments[indexPath.item]
        }
        
        return cell
    }
    
}


extension CommentsCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //依照留言動態調整整個cell的大小
        //一開始不用care height的真實大小，但要給正確的width，這樣系統會根據這個width去計算最適應的高
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
       let cell = CommentCell(frame: frame)
        if comments.count > 0{
            cell.comment = comments[indexPath.item]
            //強迫cell先更新layout
            cell.layoutIfNeeded()
            //height隨便給一個很大的數字
            let targetSize = CGSize(width: view.frame.width, height: 1000)
            let estimatedSize = cell.systemLayoutSizeFitting(targetSize)
            let height = max(8 + 44 + 8, estimatedSize.height)
            return CGSize(width: view.frame.width, height: height)
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //調整section之間的padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
}
