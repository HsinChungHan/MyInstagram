//
//  SearchCollectionViewController.swift
//  Instagram
//
//  Created by 辛忠翰 on 17/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Firebase
class SearchCollectionViewController: UICollectionViewController {
    let cellId = "SearchCellId"
    
    lazy var searchBar: UISearchBar = {
       let sb = UISearchBar()
        sb.placeholder = "Enter username..."
//        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        sb.delegate = self
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        //就算cell個數不足一頁，仍然可以垂直晃動
        collectionView?.alwaysBounceVertical = true
        //讓你滑動collectionView時可以自動把keyboard收起來
        collectionView?.keyboardDismissMode = .onDrag
        
        setupNavigationBar()
        registerCell()
        fetchUsers()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    
    fileprivate func setupNavigationBar(){
        navigationController?.navigationBar.addSubview(searchBar)
        let naviBar = navigationController?.navigationBar
        searchBar.anchor(top: naviBar?.topAnchor, topPadding: 0, bottom: naviBar?.bottomAnchor, bottomPadding: 0, left: naviBar?.leftAnchor, leftPadding: 8, right: naviBar?.rightAnchor, rightPadding: 8, width: 0, height: 0)
    }
    
    fileprivate func registerCell(){
        collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    var filterUsers = [TheUser]()
    var users = [TheUser]()
    fileprivate func fetchUsers(){
        let dbRef = Database.database().reference(fromURL: DB_BASEURL)
        dbRef.child("users").observe(.value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            dictionaries.forEach({ (key, value) in
                if key == Auth.auth().currentUser?.uid{
                    return
                }
                let uid = key
                guard let dictionary = value as? [String : Any] else {return}
                let user = TheUser.init(uid: uid, dictionary: dictionary)
                self.users.insert(user, at: 0)
            })
            //讓users做sorted，由名字的前後順序排序
            self.users.sort(by: { (user1, user2) -> Bool in
                return user1.userName.compare(user2.userName) == .orderedAscending
            })
            
            self.filterUsers = self.users
            self.collectionView?.reloadData()
        }) { (error) in
            print("Failed to fetch users: ", error)
        }
    }
    
    
    
    //MARK: UICollectionViewDelegate, UICollectionViewDatasource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        cell.user = filterUsers[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //換到profilePage時要把searchBarh藏起來，和把keyboard藏起來
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let selectedUser = filterUsers[indexPath.item]
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let userProfileCVC = UserProfileCollectionViewController(collectionViewLayout: layout)
        userProfileCVC.uid = selectedUser.uid
        navigationController?.pushViewController(userProfileCVC, animated: true)
    }
}


extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
}


extension SearchCollectionViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.isEmpty{
            self.filterUsers = self.users
        }else{
            self.filterUsers = self.users.filter { (user) -> Bool in
                //因為輸入的搜尋會針對大小寫不同，而有不同的搜尋結果，所以要把所有都轉成小寫，再去做比對
                return user.userName.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView?.reloadData()
    }
}


