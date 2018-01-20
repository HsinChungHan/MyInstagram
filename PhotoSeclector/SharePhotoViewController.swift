//
//  SharePhotoViewController.swift
//  Instagram
//
//  Created by 辛忠翰 on 14/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Firebase
class SharePhotoViewController: UIViewController {

    var selectedImage: UIImage?{
        didSet{
            imageView.image = selectedImage
        }
    }
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .lightGray
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let textView: UITextView = {
       let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        textView.delegate = self
        setupNavigationBar()
        setupViews()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    fileprivate func setupNavigationBar()  {
        let rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShareItem))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    @objc func handleShareItem(){
        guard let image = selectedImage else {return}
        guard let uploadData = UIImageJPEGRepresentation(image, 0.8) else {return}
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("post")
        storageRef.child("\(fileName).jpg").putData(uploadData, metadata: nil) { (metadata, error) in
            if let err = error{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload the post image to Strorage: ", err.localizedDescription)
                return
            }
            
            guard let imgUrl = metadata?.downloadURL()?.absoluteString else {return}
            print("Successfully upload post image to Strorage: ", imgUrl)
            
            self.savePostToDBWithImageUrl(imageUrl: imgUrl)
        }
        //讓使用者按過一次後就不能再按了，防止他多次點擊，送出多篇重複文章
        //若有錯誤發生的話還是要讓使用者可以再次點擊button，所以要再err那再加入
        //navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    fileprivate func savePostToDBWithImageUrl(imageUrl: String){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let caption = textView.text else {return}
        guard let postImage = selectedImage else {return}
        //為了要在feed page可以精準的抓出圖片的寬高，我們也要一併上傳
        let values = ["postImageUrl" : imageUrl, "caption" : caption, "width" : postImage.size.width, "height" : postImage.size.height, "creationDate" : Date().timeIntervalSince1970] as [String : Any]
        let userPostRef = Database.database().reference(fromURL: DB_BASEURL).child("posts").child(uid)
        //childByAutoId自動創一個unique的id出來
        userPostRef.childByAutoId().updateChildValues(values) { (error, dataRef) in
            if let err = error{
                print("Failed to upload the post to DB: ", err.localizedDescription)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            print("Successfully upload post to DB: ", dataRef)
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: SharePhotoViewController.updateFeedNotificationName, object: nil)
        }
        
    }
    
    
    fileprivate func setupViews(){
        view.addSubview(containerView)
        
        //safeAreaLayoutGuide會抓目前被tabBar擋住後的最大高度
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, left: view.leftAnchor, leftPadding: 0, right: view.rightAnchor, rightPadding: 0, width: view.frame.width, height: 120)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, topPadding: 10, bottom: nil, bottomPadding: 0, left: containerView.leftAnchor, leftPadding: 10, right: nil, rightPadding: 0, width: 100, height: 100)
        
        containerView.addSubview(textView)
        textView.anchor(top: imageView.topAnchor, topPadding: 0, bottom: imageView.bottomAnchor, bottomPadding: 0, left: imageView.rightAnchor, leftPadding: 10, right: containerView.rightAnchor, rightPadding: 10, width: 0, height: 0)
        
    }
}


extension SharePhotoViewController: UITextViewDelegate{
    //監控textView的字數，> 0才可按按鈕，= 0不可按
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}
