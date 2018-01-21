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
    
//    override func viewWillAppear(_ animated: Bool) {
//         posts.removeAll()
//        fetchAllPosts()
//    }
    
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
        dbRef.observe(.value, with: { (snapshot) in
            self.collectionView?.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            dictionaries.forEach({ (key, value) in
                guard let dictionary = dictionaries[key] as? [String: Any] else {return}
                let post = Post.init(dictionary: dictionary, user: user)
                //使用append會把新的element加到array尾端，若要讓新的element在array的開頭，需要使用insert
                self.posts.insert(post, at: 0)
            })
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.collectionView?.reloadData()
        }) { (error) in
            print("Failed to fetch Post: ", error)
        }
    }
    
    
    fileprivate func fetchFollowingUsersIds(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let dbRef = Database.database().reference().child("followings").child(currentUserId)
        dbRef.observe(.value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            dictionaries.forEach({ (key, value) in
                print("key: ", key)
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
        cell.post = posts[indexPath.item]
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



