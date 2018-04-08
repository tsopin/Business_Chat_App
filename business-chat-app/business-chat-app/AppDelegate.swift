//
//  AppDelegate.swift
//  business-chat-app
//
//  Created by Viktor Bilyk on 2018-03-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var tokensDict = [String:String]()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    Database.database().isPersistenceEnabled = true
//    Services.instance.myStatus()
    
    if Auth.auth().currentUser != nil {
      
      let mainTabVC: UIStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
      let nextView: MainTabViewController = mainTabVC.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabViewController
      self.window?.rootViewController = nextView
      
      UserServices.instance.updateUserStatus(withStatus: "online", handler: { (online) in
        if online == true {
          print("status set to Online")
        }
      })
    }
    
    NotificationServices.shared.authorize()
    
    // set colour for navigation bar buttons in entire app
    let navigationBarAppearance = UINavigationBar.appearance()
    navigationBarAppearance.tintColor = UIColor(rgb: 0x084887)
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    
    Auth.auth().addStateDidChangeListener() { auth, user in
      if user != nil {
        UserServices.instance.updateUserStatus(withStatus: "away", handler: { (online) in
          if online == true {
            print("status set to Away")
          }
        })
      }
    }
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    
    Auth.auth().addStateDidChangeListener() { auth, user in
      if user != nil {
        UserServices.instance.updateUserStatus(withStatus: "away", handler: { (online) in
          if online == true {
            print("status set to Away")
          }
        })
      }
    }
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    
    Auth.auth().addStateDidChangeListener() { auth, user in
      if user != nil {
        UserServices.instance.updateUserStatus(withStatus: "online", handler: { (online) in
          if online == true {
            print("status set to Online")
          }
        })
      }
    }
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("did regiser with token \(deviceToken)")
    
    var token = ""
    for i in 0..<deviceToken.count {
      token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
    }
    print("regestration success with token: \(token)")
    
    tokensDict["apnToken"] = token
    
    if let newToken = InstanceID.instanceID().token() {
      tokensDict["instanceIdToken"] = newToken
      print("New token:\(newToken)")
    }
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("RegistrationFailed")
  }
  
}

