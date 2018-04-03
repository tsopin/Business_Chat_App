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
  func myStatus() {
    
    let connectedRef = Database.database().reference(withPath: ".info/connected")
    connectedRef.observe(.value, with: {  snapshot in
      if snapshot.value as? Bool ?? false {
        print("Connected")
      } else {
        print("Not connected")
      }
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
  func uploadPhotoMessage(withImage image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
    
    if let uploadData = UIImageJPEGRepresentation(image, 0.3) {
      REF_STORAGE_PHOTO_MESSAGES.child(currentUserId!).putData(uploadData, metadata: nil, completion: { (metadata, error) in
        
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





