//
//  NotificationServices.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-04-04.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationServices: NSObject {
  private override init() {}
  
  static let shared = NotificationServices()
  let unCenter = UNUserNotificationCenter.current()
  
  func authorize() {
    let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    unCenter.requestAuthorization(options: options) { (granted, error) in
      print(error ?? "noError")
      guard granted else {return}
      DispatchQueue.main.async {
        self.configure()
      }
    }
  }
  func configure() {
    unCenter.delegate = self
    
    let application = UIApplication.shared
    application.registerForRemoteNotifications()
 
  }
}

extension NotificationServices: UNUserNotificationCenterDelegate {
  
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("na")
    
    if let day = notification.request.content.userInfo["day"] {
      print("day: \(day)")
    }
    
    
    let dict = notification.request.content.userInfo["aps"] as! NSDictionary
    
    var messageBody: String?
    var messageTitle : String = "Alert"
    
    if let alertDict = dict["alert"] as? Dictionary<String, String> {
      
      messageBody = alertDict["body"]!
      
      if alertDict["title"] != nil { messageTitle = alertDict["title"]!}
    } else {
      messageBody = dict["alert"] as? String
    }

    let options: UNNotificationPresentationOptions = [.alert, .sound, .badge]
    completionHandler(options)
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    print("N Received")
    
    updateBadgeCount()
    completionHandler()
  }

  
  func updateBadgeCount() {
    var badgeCount = UIApplication.shared.applicationIconBadgeNumber
    if badgeCount > 0 {
      badgeCount = badgeCount - 1
    }
    UIApplication.shared.applicationIconBadgeNumber = badgeCount
  }
  
}
