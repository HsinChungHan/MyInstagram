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
        collectionView?.backgroundColor = .white
        registerCell()
        setupNavigationItems()
        fetchUserPosts()
        
        
    }

    fileprivate func registerCell(){
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
    }

    fileprivate func setupNavigationItems(){
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        navigationItem.titleView?.contentMode = .scaleAspectFit
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal) , style: .plain, target: self, action: #selector(handlePhotoButton))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send")?.withRenderingMode(.alwaysOriginal) , style: .plain, target: self, action: #selector(handleSendButton))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func handlePhotoButton(){
        
    }
    
    @objc func handleSendButton(){
        
    }
    
    var posts = [Post]()
    fileprivate func fetchUserPosts(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let dbRef = Database.database().reference(fromURL: DB_BASEURL)
        
        //to fetch who post
        dbRef.child("users").child(currentUserId).observe(.value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            if let userName = dictionaries["userName"] as? String,
                let profileImgUrl = dictionaries["profileImageUrl"] as? String{
               
                let user = TheUser(dictionary: ["userName" : userName, "profileImageUrl": profileImgUrl])
                //to fetch the posts
                dbRef.child("posts").child(currentUserId).observe(.value, with: { (snapshot) in
                    guard let dictionaries = snapshot.value as? [String : Any] else {return}
                    dictionaries.forEach({ (key, value) in
                        guard let dictionary = value as? [String : Any] else {return}
                        let post = Post.init(dictionary: dictionary, user: user)
                        //使用append會把新的element加到array尾端，若要讓新的element在array的開頭，需要使用insert
                        self.posts.insert(post, at: 0)
//                        self.posts.append(post)
                    })
                    self.collectionView?.reloadData()
                }) { (error) in
                    print("Failed to fetch the posts form DB: ", error.localizedDescription)
                }
            }
        }) { (error) in
            print("Failed to fetch who post: ", error)
        }
    }
    
    fileprivate func fetchWhoPost(dbRef: DatabaseReference, userId: String, completionHandler: @escaping (_ user: TheUser?)->()){
        var user: TheUser?
        dbRef.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            
            if let userName = dictionaries["userName"] as? String{
                user = TheUser(dictionary: ["userName" : userName])
            }
            completionHandler(user)
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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



