//
//  Services.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-13.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import Alamofire


let DATABASE = Database.database().reference()
let STORAGE = Storage.storage().reference()
let currentUserId = Auth.auth().currentUser?.uid
let currentEmail = Auth.auth().currentUser?.email
let currentUserName = Auth.auth().currentUser?.uid

class Services {
  
  static let instance = Services()
  
  private var _REF_STATUS = DATABASE.child(".info/connected")
  private var _REF_STORAGE_USER_IMAGES = STORAGE.child("userImages")
  private var _REF_STORAGE_PHOTO_MESSAGES = STORAGE.child("photoMessages")
  
  var REF_STORAGE_USER_IMAGES: StorageReference {
    return _REF_STORAGE_USER_IMAGES
  }
  var REF_STORAGE_PHOTO_MESSAGES: StorageReference {
    return _REF_STORAGE_PHOTO_MESSAGES
  }
  var REF_STATUS: DatabaseReference {
    _REF_STATUS.keepSynced(true)
    return _REF_STATUS
  }
  
  // Get connection status
  func myStatus()-> Bool {
    
    let networkCheck = NetworkReachabilityManager()
    networkCheck?.startListening()
    
    networkCheck?.listener = { status in
      if networkCheck?.isReachable ?? false {
        
        switch status {
          
        case .reachable(.ethernetOrWiFi):
          print("The network is reachable over the WiFi connection")
          
        case .reachable(.wwan):
          print("The network is reachable over the WWAN connection")
          
        case .notReachable:
       print("The network is not reachable")
          
        case .unknown :
          print("It is unknown whether the network is reachable")
          
        }
      }
    }
    return (networkCheck?.isReachable)!
  }
  
  func presenceSystem() {
    // since I can connect from multiple devices, we store each connection instance separately
    // any time that connectionsRef's value is null (i.e. has no children) I am offline
    let myConnectionsRef = Database.database().reference(withPath: "users/\(currentUserId!)/connections")
    
    // stores the timestamp of my last disconnect (the last time I was seen online)
    let lastOnlineRef = Database.database().reference(withPath: "users/\(currentUserId!)/lastOnline")
    let offlineAfterDisconnect = Database.database().reference(withPath: "users/\(currentUserId!)/status")
    let connectedRef = Database.database().reference(withPath: ".info/connected")
    
    connectedRef.observe(.value, with: { snapshot in
      // only handle connection established (or I've reconnected after a loss of connection)
      guard let connected = snapshot.value as? Bool, connected else { return }
      
      // add this device to my connections list
      let con = myConnectionsRef.childByAutoId()
      
      // when this device disconnects, remove it.
      con.onDisconnectRemoveValue()
      
      // The onDisconnect() call is before the call to set() itself. This is to avoid a race condition
      // where you set the user's presence to true and the client disconnects before the
      // onDisconnect() operation takes effect, leaving a ghost user.
      
      // this value could contain info about the device or a timestamp instead of just true
      con.setValue(true)
      let date = Date()
      let currentDate = date.timeIntervalSinceReferenceDate
      // when I disconnect, update the last time I was seen online
      lastOnlineRef.onDisconnectSetValue(currentDate)
      offlineAfterDisconnect.onDisconnectSetValue("offline")
    })
  }
  
  //Get Info for user ID
  func getUserImage(byUserId userId: String, handler: @escaping (_ userImageUrl: URL) -> ()) {
    
    REF_STORAGE_USER_IMAGES.child(userId).downloadURL { (url, error) in
      //using a guard statement to unwrap the url and check for error
      guard let imageURL = url, error == nil else {
        if error != nil {
          //print("FILE NOT EXIST")
        }
        return
      }
      
      handler(imageURL)
    }
  }
  
  //    MARK: Upload to Storage
  func uploadUserImage(withImage image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
    
    if let uploadData = UIImageJPEGRepresentation(image, 0.3) {
      REF_STORAGE_USER_IMAGES.child(currentUserId!).putData(uploadData, metadata: nil, completion: { (metadata, error) in
        
        if error != nil {
          print("Failed to upload image:", error!)
          
          return
        }
        
        if let imageUrl = metadata?.downloadURL()?.absoluteString {
          completion(imageUrl)
        }
      })
    }
  }
  
  //    MARK: Upload to Storage
  func uploadPhotoMessage(withImage image: UIImage, withChatKey chatKey: String, withMessageId messageId: String, completion: @escaping (_ imageUrl: String) -> ()) {
    
    if let uploadData = UIImageJPEGRepresentation(image, 0.3) {
      REF_STORAGE_PHOTO_MESSAGES.child(chatKey).child(messageId).putData(uploadData, metadata: nil, completion: { (metadata, error) in
        
        if error != nil {
          print("Failed to upload image:", error!)
          return
        }
        
        if let imageUrl = metadata?.downloadURL()?.absoluteString {
          completion(imageUrl)
        }
      })
    }
  }
}





