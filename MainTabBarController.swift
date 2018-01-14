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
        //home tab
        let homeVC = UIViewController()
         let homeNaviVC = templateNaviViewController(rootViewController: homeVC, unselectedImage: "home_unselected", selectedImage: "home_selected")
        
        //search tab
        let searchVC = UIViewController()
        let searchNaviVC = templateNaviViewController(rootViewController: searchVC, unselectedImage: "search_unselected", selectedImage: "search_selected")
    
        //plus tab
        let plusVC = UIViewController()
        let plusNaviVC = templateNaviViewController(rootViewController: plusVC, unselectedImage: "plus_unselected", selectedImage: "plus_selected")
        
        //like tab
        let likeVC = UIViewController()
        let likeNaviVC = templateNaviViewController(rootViewController: likeVC, unselectedImage: "like_unselected", selectedImage: "")
        
        //user profile tab
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let userProfileVC = UserProfileViewController(collectionViewLayout: layout)
        let userProfileNaviVC = templateNaviViewController(rootViewController: userProfileVC, unselectedImage: "profile_unselected", selectedImage: "profile_selected")
        
        viewControllers = [homeNaviVC, searchNaviVC, plusNaviVC, likeNaviVC, userProfileNaviVC]
        
        //因為icom預設在tab bar中，是中間偏上，所以我們要用程式碼的方式調整位置
        //modify tab bar item inset
        //需在把所有naviVC塞到viewControllers後再行調整
        guard let items = tabBar.items else {return}
        for item in items{
            //讓item中的image往下一點，到正中央的位置
            //其中buttom調整為-4是因為，要讓整張圖片可以往下4，比例才不會跑掉
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            
        }
        
    }

    fileprivate func templateNaviViewController(rootViewController: UIViewController, unselectedImage: String, selectedImage: String) -> UINavigationController{
        let naviVC = UINavigationController(rootViewController: rootViewController)
        naviVC.tabBarItem.image = UIImage(named: unselectedImage)?.withRenderingMode(.alwaysOriginal)
        naviVC.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        return naviVC
    }
}
