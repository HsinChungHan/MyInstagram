//
//  MainTabBarController.swift
//  Instagram
//
//  Created by 辛忠翰 on 12/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Firebase
class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if isUserLogIn(){
            setupViewController()
        }
    }
    
    
    
    private func isUserLogIn() -> Bool{
        if Auth.auth().currentUser == nil{
            //Ep8 12:00
            DispatchQueue.main.async {//在console區，會出現view不在window hirachy
                let loginVC = LogInViewController()
                let naviVC = UINavigationController(rootViewController: loginVC)
                self.present(naviVC, animated: true, completion: nil)
            }
            return false
        }
        return true
    }
    
    func setupViewController(){
        //將redVC嵌套在naviVC
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let userProfileVC = UserProfileViewController(collectionViewLayout: layout)
        let naviViewController = UINavigationController(rootViewController: userProfileVC)
        naviViewController.tabBarItem.image = UIImage(named: "profile_unselected")?.withRenderingMode(.alwaysOriginal)
        naviViewController.tabBarItem.selectedImage = UIImage(named: "profile_selected")?.withRenderingMode(.alwaysOriginal)
        
        viewControllers = [naviViewController, UIViewController()]
    }

}
