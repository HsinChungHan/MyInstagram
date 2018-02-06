//
//  AppDelegate.swift
//  Instagram
//
//  Created by 辛忠翰 on 10/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

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
        attemptRegisterForNotification(application: application)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registerd for notificaions: ", deviceToken);
    }
    
    
    private func attemptRegisterForNotification(application: UIApplication){
        print("Attempt to register Apple Push Notification System (APNS)...")
        //也要實作firebase的推播功能
        Messaging.messaging().delegate = self
        //要實作UNUserNotificationCenter的推播通知功能
        UNUserNotificationCenter.current().delegate = self
        
        
        
        //user notification auth
        //need to import userNotifications first
        //all of this for ios10+
        //會跳出一個可否進行推播的視窗
        let option: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: option) { (granted, error) in
            if let err = error{
                print("Failed to request auth: ", err.localizedDescription)
            }
            if granted{
                print("Auth granted...")
            }else{
                print("Auth denied...")
            }
        }
        application.registerForRemoteNotifications()
    }

}

extension AppDelegate: MessagingDelegate{
    //get the firebase cloud message token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        //fcmToken: firebase cloud message token
        print("Registered with FCM with token: ", fcmToken)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    //list for user notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

