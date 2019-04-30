//
//  AppDelegate.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/3/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

  var window: UIWindow?
 let authService = AuthService()
//static var container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    window = UIWindow(frame: UIScreen.main.bounds)
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.sound, .alert]
    center.requestAuthorization(options: options) { (granted, error) in
        if let error = error {
            print(error.localizedDescription)
        }
    }
    center.delegate = self
    if let _ = authService.getCurrentUser(){
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let servicetab = storyboard.instantiateViewController(withIdentifier: "UserTabBarController")
        window?.rootViewController = servicetab
        
    }else{
        let storyboard = UIStoryboard(name: "Entrance", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        window?.rootViewController = login
        
    }
    window?.makeKeyAndVisible()
    return true
  }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

