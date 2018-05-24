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
    
    if Auth.auth().currentUser != nil {
      
      let mainTabVC: UIStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
      let nextView: MainTabViewController = mainTabVC.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabViewController
      self.window?.rootViewController = nextView
    }
    
    UserServices.instance.setStatusAppDelegate(withStatus: "online")
    NotificationServices.shared.authorize()
    
    // set colour for navigation bar buttons in entire app
    let navigationBarAppearance = UINavigationBar.appearance()
    navigationBarAppearance.tintColor = UIColor(rgb: 0x084887)
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    UserServices.instance.setStatusAppDelegate(withStatus: "away")
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    UserServices.instance.setStatusAppDelegate(withStatus: "away")
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    UserServices.instance.setStatusAppDelegate(withStatus: "online")
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
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

