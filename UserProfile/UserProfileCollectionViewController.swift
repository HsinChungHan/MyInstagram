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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        fetchUser()
        registerCell()
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
        collectionView?.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    //設定header，要記得去調整header的大小，還有register header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeaderCell
        header.user = currentUser
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .green
        return cell
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
        let padding: CGFloat = 1
        print(view.frame.width)
        let width = (view.frame.width - padding * 2)/3
        let height = width
        return CGSize(width: width, height: height)
    }
}








