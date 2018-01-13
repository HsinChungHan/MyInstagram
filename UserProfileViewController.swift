//
//  UserProfileViewController.swift
//  Instagram
//
//  Created by 辛忠翰 on 12/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Firebase
class UserProfileViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationItem.title = "User Profile"
        fetchUser()
        collectionView?.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
    }
    
    //設定header，要記得去調整header的大小，還有register header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeaderCell
        header.user = currentUser
        return header
    }
    
    
    var currentUser: CurrentUser?
    fileprivate func fetchUser() {
        guard let currentUserId = Auth.auth().currentUser?.uid else{return}
        let ref = Database.database().reference().child("users").child("\(currentUserId)")
        //.value:取得值
        ref.observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            self.currentUser = CurrentUser(dictionary: dictionary)
            guard let user =  self.currentUser else {return}
            self.navigationItem.title = user.userName
            self.collectionView?.reloadData()
        }) { (error) in
            print("Failed to fetch user: ", error)
        }
    }
}


extension UserProfileViewController: UICollectionViewDelegateFlowLayout{
   //去調整header大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}








