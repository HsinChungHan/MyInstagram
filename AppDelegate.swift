//
//  AppDelegate.swift
//  Instagram
//
//  Created by 辛忠翰 on 10/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //要把FirebaseApp.configure()放在設定是窗前，否則執行TabBarController中的if Auth.auth().currentUser == nil會崩潰
        //You should call FirebaseApp.configure() before setting up the window
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
//        window?.rootViewController = LogInViewController()
        window?.rootViewController = MainTabBarController()
        
        return true
    }

}
