//
//  HomeFeedCollectionViewController.swift
//  Instagram
//
//  Created by 辛忠翰 on 15/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.

import UIKit
import Firebase

class HomeFeedCollectionViewController: UICollectionViewController {

    let cellId = "HomePostCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoViewController.updateFeedNotificationName, object: nil)
        
        collectionView?.backgroundColor = .white
        setupRefreshControl()
        registerCell()
        setupNavigationItems()
        fetchAllPosts()
    }
    
    @objc fileprivate func handleUpdateFeed(){
        handleRefreshControl()
    }
    
    fileprivate func setupRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    @objc fileprivate func handleRefreshControl(){
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts(){
        fetchUserPosts()
        fetchFollowingUsersIds()
    }
    
    fileprivate func registerCell(){
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
    }

    fileprivate func setupNavigationItems(){
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        navigationItem.titleView?.contentMode = .scaleAspectFit
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal) , style: .plain, target: self, action: #selector(handleCameraButton))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send")?.withRenderingMode(.alwaysOriginal) , style: .plain, target: self, action: #selector(handleSendButton))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func handleCameraButton(){
        let cameraVC = CameraViewController()
        self.present(cameraVC , animated: true) {
            
        }
    }
    
    @objc func handleSendButton(){
        
    }
    
    var posts = [Post]()
    var followingUsers = [TheUser]()
    fileprivate func fetchUserPosts(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUID(uid: currentUserId) { (currentUser) in
            self.fetchPostWithUser(user: currentUser)
        }
    }
    
    fileprivate func fetchPostWithUser(user: TheUser){
        let uid = user.uid
         let dbRef = Database.database().reference().child("posts").child(uid)
        dbRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView?.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            dictionaries.forEach({ (key, value) in
                guard let dictionary = dictionaries[key] as? [String: Any] else {return}
                let postId = key
                let post = Post.init(dictionary: dictionary, user: user, postId: postId)
                self.fetchLikedPost(postId: postId, userId: uid, post: post)
            })
        }) { (error) in
            print("Failed to fetch Post: ", error)
        }
    }
    
    fileprivate func fetchLikedPost(postId: String, userId: String, post: Post){
        let dbRef = Database.database().reference().child("likes").child(postId).child(userId)
        dbRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Int, value == 1{
                post.hasLiked = true
            }else{
                post.hasLiked = false
            }
            //使用append會把新的element加到array尾端，若要讓新的element在array的開頭，需要使用insert
            self.posts.insert(post, at: 0)
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            print("The posts number are: ", self.posts.count)
            self.collectionView?.reloadData()
        }) { (error) in
            print("Faile to fetch the liked post: ", error.localizedDescription)

        }
    }
    
    
    
    fileprivate func fetchFollowingUsersIds(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let dbRef = Database.database().reference().child("followings").child(currentUserId)
        dbRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            dictionaries.forEach({ (key, value) in
                print(key, value)
                Database.fetchUserWithUID(uid: key, completionHandler: { (user) in
                    self.fetchPostWithUser(user: user)
                })
            })
            
        }) { (error) in
            print("Failed to fetch following users ID: ", error)
            return
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("posts.count: ",posts.count)
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        if posts.count > 0{
            cell.post = posts[indexPath.item]
            print("cell.post = posts[\(indexPath.item)]")
            cell.delegate = self
        }
        
        return cell
    }
}

extension HomeFeedCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width + 50 + 50 + 80 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
   
}


extension HomeFeedCollectionViewController: HomePostCellDelegate{
    func didTapComment(post: Post) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let commentVC = CommentsCollectionViewController(collectionViewLayout: layout)
        commentVC.post = post
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func didTapLike(for cell: HomePostCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else {
            return
        }
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let post = posts[indexPath.item]
        let postId = post.postId
        let dbRef = Database.database().reference().child("likes").child(postId)
        //將用戶like的post新增到DB
        let values = [
            //post.hasLiked = true, 代表原先為true, 後來要改為false=0，並存到DB中
            currentUserId : post.hasLiked == true ? 0 : 1
            ] as [String:Any]
        dbRef.updateChildValues(values) { (error, _) in
            if let err = error{
                print("Failed to add the liked post into the DB: ", err)
            }
            print("Successfully updated the liked post into the DB!!")
            post.hasLiked = !post.hasLiked
            //因為我們只是參考了一個post進來，所以也要同時更動我們所參考的posts
            //若是不做這個動作，當你reload data時，還是原本的posts，而不是後來我們更動過的post
            //後來發現如果你的post是struct的話才需要，因為struct是pass by value
            //                self.posts[indexPath.item] = post
            //可以只reload更改的cell
            self.collectionView?.reloadItems(at: [indexPath])
        }
    }
}
