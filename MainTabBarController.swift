//
//  MainTabBarController.swift
//  Instagram
//
//  Created by 辛忠翰 on 12/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
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
