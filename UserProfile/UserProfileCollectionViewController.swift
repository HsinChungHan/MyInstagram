//
//  UserProfileViewController.swift
//  Instagram
//
//  Created by 辛忠翰 on 12/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Firebase

class UserProfileCollectionViewController: UICollectionViewController {
    let headerId = "headerId"
    let userProfilePhotoCellId = "UserProfilePhotoCellId"
    let homePostCellId = "HomePostCell"
    var uid: String?
    //因為程式一開始進來就會在gridView
    var isGridView = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        fetchUser { (user) in
//            self.fetchOrderedPosts(user: user)
            self.paginatePost()
        }
        
        
        registerCell()
        //這是不照順序抓取post的方式(因為一次抓全部的posts):dbRef.observeSingleEvent
//        fetchUserPosts()
        //這是照child被加入DB的順序，抓取post的方式:dbRef.observe(childAdded)
        //會等到每次有post加入時，會等到那個post上傳到DB後，才會去下載
        //也解決了在PhotoSelector share出一篇新文章後，立即到UserProfile所出現的bug
//        fetchOrderedPosts()
    }
    
   
    
    func setupNavigationBar() {
        collectionView?.backgroundColor = .white
        navigationItem.title = "User Profile"
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: self, action: #selector(handleLogOutButton))
        
        rightBarItem.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarItem
    
    }
    @objc func handleLogOutButton(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Instagram is iPhone only. If someone might want to use the UIAlertController as an actionSheet on an iPad be aware that you will need to add(加了下面那行後，他會從rightBarButtonItem那pop出來)
        // added for iPad
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do{
                ///我們需要到MainTabBarController那去判斷使用者是否有登入 Ep8,09:00有提到
                try Auth.auth().signOut()
                let logInVC = LogInViewController()
                let naviVC = UINavigationController(rootViewController: logInVC)
                self.present(naviVC, animated: true, completion: nil)

            }catch let signOutErr{
                print("Failed to sign out: ", signOutErr.localizedDescription)
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func registerCell() {
        collectionView?.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: userProfilePhotoCellId)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
    }
    
    var posts = [Post]()
    fileprivate func fetchOrderedPosts(user: TheUser){
        let uid = user.uid
        self.fetchOrderPostsWithUID(user: user, uid: uid) { (post) in
            self.posts.insert(post, at: 0)
            self.collectionView?.reloadData()
        }
    }
    
    var isFinishedPaging = false
    fileprivate func paginatePost(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUID(uid: uid) { (user) in
            let dbRef = Database.database().reference().child("posts").child(uid)
            var query = dbRef.queryOrderedByKey()
            if !self.posts.isEmpty {
                let value = self.posts.last?.postId
                print("last?.postId: ", value ?? "")
                query = query.queryStarting(atValue: value)
            }
            
            let paginLimited = 4
            query.queryLimited(toFirst: UInt(paginLimited)).observeSingleEvent(of: .value, with: { (snapshot) in
                print("Suceessfully to fetch posts!!")
                guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
                if allObjects.count < paginLimited{
                    self.isFinishedPaging = true
                }
                if !self.posts.isEmpty{
                    //因為每次paging後，第一個都會重複，所以要把allObjects的第一個remove掉
                    allObjects.removeFirst()
                }
                
               
                
                allObjects.forEach({ (snapshot) in
                    
                    guard let dictionary = snapshot.value as? [String : Any] else {return}
                    print(snapshot.key)
                    let post = Post.init(dictionary: dictionary, user: user, postId: snapshot.key)
                    self.posts.append(post)
                    self.collectionView?.reloadData()
                })
            }) { (error) in
                print("Failed to fetch posts: ", error.localizedDescription)
            }
        }
    }
    
    
    
    fileprivate func fetchOrderPostsWithUID(user: TheUser, uid: String, completionHandler: @escaping (_ post: Post) -> ()){
        let dbRef = Database.database().reference(fromURL: DB_BASEURL).child("posts").child(uid)
        dbRef.queryOrdered(byChild: "creationDate").observe(.childAdded , with: { (snapshot) in
            print("Successfully fetch posts from DB!!")
            //snapshot.key是所有的postId，snapshot.value就是每個post的內容
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let post = Post.init(dictionary: dictionary, user: user, postId: snapshot.key)
            completionHandler(post)
        }) { (error) in
            print("Failed to fetch the posts form DB: ", error.localizedDescription)
        }
    }
    
    
    
    fileprivate func fetchUserPosts(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let dbRef = Database.database().reference(fromURL: DB_BASEURL).child("posts").child(currentUserId)
        dbRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //這邊的snapshot.key就是一個uid，所以 snapshot.value就是uid下的node
            //要對照資料庫看
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String : Any] else {return}
                //                let post = Post.init(dictionary: dictionary, user: self.currentUser!)
                //                self.posts.append(post)
            })
            self.collectionView?.reloadData()
        }) { (error) in
            print("Failed to fetch the posts form DB: ", error.localizedDescription)

        }
    }
    
    
    
    //MARK: UICOllectionViewDelegate
    //設定header，要記得去調整header的大小，還有register header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeaderCell
        headerCell.user = currentUser
        headerCell.delegate = self
        return headerCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //pagination logic
        
        if indexPath.item == self.posts.count - 1 && !isFinishedPaging{//也就是說到了posts的最後一個的時候，觸發pagination
            paginatePost()
        }
        switch isGridView {
        case false:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
            if !posts.isEmpty{
                cell.post = posts[indexPath.item]
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userProfilePhotoCellId, for: indexPath) as! UserProfilePhotoCell
            if !posts.isEmpty{
                cell.post = posts[indexPath.item]
            }
            return cell
        }
        
        
        
        
    }
    
    var currentUser: TheUser?
    fileprivate func fetchUser(completionHandler: @escaping (_ user: TheUser) -> ()) {
        guard let currentUserId = Auth.auth().currentUser?.uid else{return}
        let userId = uid ?? currentUserId
        Database.fetchUserWithUID(uid: userId) { (user) in
            self.currentUser = user
            self.navigationItem.title = user.userName
            self.collectionView?.reloadData()
            completionHandler(user)
        }
    }
}


extension UserProfileCollectionViewController: UICollectionViewDelegateFlowLayout{
   //去調整header大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView{
            let padding: CGFloat = 1
            let width = (view.frame.width - padding * 2)/3
            let height = width
            return CGSize(width: width, height: height)
        }else{
            return CGSize(width: view.frame.width, height: view.frame.width + 50 + 50 + 80 )
        }
        
    }
}


extension UserProfileCollectionViewController: UserProfileHeaderCellDelegate{
    func didTapListButton() {
        isGridView = false
        collectionView?.reloadData()
    }
    
    func didTapGridButton() {
        isGridView = true
        collectionView?.reloadData()
    }
}





