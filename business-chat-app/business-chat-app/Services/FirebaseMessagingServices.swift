////
////  FirebaseMessagingServices.swift
////  business-chat-app
////
////  Created by Timofei Sopin on 2018-04-04.
////  Copyright © 2018 Brogrammers. All rights reserved.
////
//
//import UIKit
//import FirebaseMessaging
//
//enum SubscriptionTopic: String {
//  case newMessage = "newMessage"
//}
//
//
//class FirebaseMessagingServices {
//  private init() {}
//  static let shared = FirebaseMessagingServices()
//  let messaging = Messaging.messaging()
//
//  func subscribe(to topic: SubscriptionTopic)  {
//    messaging.subscribe(toTopic: topic.rawValue)
//  }
//  func unsubscribe(to topic: SubscriptionTopic) {
//    messaging.unsubscribe(fromTopic: topic.rawValue)
//  }
//
//}
