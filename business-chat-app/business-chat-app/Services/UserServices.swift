//
//  UserServices.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-31.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UserServices {
  static let instance = UserServices()
  
  private var _REF_DATABASE = DATABASE
  private var _REF_USERS = DATABASE.child("users")
  
  var REF_DATABASE: DatabaseReference {
    _REF_DATABASE.keepSynced(true)
    return _REF_DATABASE
  }
  
  var REF_USERS: DatabaseReference {
    _REF_USERS.keepSynced(true)
    return _REF_USERS
  }
  
  //MARK: Add and update data to Database
  
  func updateUserStatus(withStatus userStatus: String, handler: @escaping (_ chatUpdated: Bool) -> ()) {
    
    REF_USERS.child(currentUserId!).updateChildValues(["status" : userStatus])
    handler(true)
  }
  
  //Create new user in database
  func createDBUser(uid: String, userData: Dictionary<String, Any>) {
    REF_USERS.child(uid).updateChildValues(userData)
  }
  
  // Add contact
  func addContact(forUsersIds ids: [String], handler: @escaping (_ contactAdded: Bool) -> ()) {
    
    var newContacts = [String:Bool]()
    var activeChats = [String:Bool]()
    activeChats[currentUserId!] = true
    
    for user in ids {
      newContacts[user] = true
    }
    REF_USERS.child(currentUserId!).updateChildValues(["contactList" : newContacts])
    handler(true)
  }
  
  //    Get all registred users from database
  func getAllUsers(handler: @escaping (_ allUsersArray: [User]) -> ()) {
    
    var usersArray = [User]()
    REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
      guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
      
      for user in userSnapshot {
        
        guard let userName = user.childSnapshot(forPath: "username").value as? String else {return}
        guard let email = user.childSnapshot(forPath: "email").value as? String else {return}
        guard let status = user.childSnapshot(forPath: "status").value as? String else {return}
		
		var avatarUrl = String()
		
		if let imageUrl = user.childSnapshot(forPath: "avatarURL").value as? String {
			avatarUrl = imageUrl
		} else {
			avatarUrl = "NoImage"
		}
		
        
		let user = User(userName: userName, email: email, avatarUrl: avatarUrl, status: status)
        
        if email != currentEmail{
          usersArray.append(user)
        }
      }
      handler(usersArray)
    }
  }
  
  //    MARK: Getting data for particular entries
  
  
  //Get Info for user ID
  func getUserData(byUserId userId: String, handler: @escaping (_ userData: (String, String, String, String, String)) -> ()) {
    
    REF_USERS.observe(DataEventType.value, with: { (userSnapshot) in
      
      var returnedEmail = String()
      var returnedUsername = String()
      var returnedStatus = String()
      var returnedImageUrl = String()
      var lastSeen = String()
      
      guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
      
      for user in userSnapshot {
        
        guard let userEmail = user.childSnapshot(forPath: "email").value as? String else {return}
        guard let userName = user.childSnapshot(forPath: "username").value as? String else {return}
        guard let status = user.childSnapshot(forPath: "status").value as? String else {return}
        guard let lastOnline = user.childSnapshot(forPath: "lastOnline").value as? Double else {return}
        guard let isUserPicExist = user.childSnapshot(forPath: "avatar").value as? Bool else {return}
        
        if user.key == userId {
          
          returnedEmail = userEmail
          returnedUsername = userName
          returnedStatus = status
          lastSeen = String(lastOnline)
          
          if isUserPicExist == true {
            let userPicUrl = user.childSnapshot(forPath: "avatarURL").value as! String
            returnedImageUrl = userPicUrl
          } else {
            returnedImageUrl = "NoImage"
          }
        }
        handler((returnedEmail, returnedUsername, returnedStatus, returnedImageUrl, lastSeen))
      }
    })
  }
  
  //Get users ID's by Email
  func getUsersIds(forUsernames usernames: [String], handler: @escaping (_ usersIdsArray: [String]) -> ()) {
    
    REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
      
      var idArray = [String]()
      guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
      
      for user in userSnapshot {
        
        let email = user.childSnapshot(forPath: "email").value as! String
        if usernames.contains(email) {
          idArray.append(user.key)
        }
      }
      handler(idArray)
    }
  }
  
  // Search users by email
  func getUserInfoByEmail(forSearchQuery query: String, handler: @escaping (_ usersDataArray: [User]) -> ()) {
    
    var userArray = [User]()
    
    REF_USERS.observe(.value) { (userSnapshot) in
      guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
      
      for user in userSnapshot {
        
        guard let email = user.childSnapshot(forPath: "email").value as? String else {return}
        guard let userName = user.childSnapshot(forPath: "username").value as? String else {return}
		
		var avatarUrl = String()
		
		if let imageUrl = user.childSnapshot(forPath: "avatarURL").value as? String {
			avatarUrl = imageUrl
		} else {
			avatarUrl = "NoImage"
		}
			
		
        guard let status = user.childSnapshot(forPath: "status").value as? String else {return}
        
        if email.contains(query) == true && email != Auth.auth().currentUser?.email {
			let user = User(userName: userName, email: email, avatarUrl: avatarUrl, status: status)
          userArray.append(user)
        }
      }
      handler(userArray)
    }
  }
  
  func saveTokens() {
    
    let appDelegage = UIApplication.shared.delegate as! AppDelegate
    let tokens = appDelegage.tokensDict
    
    REF_USERS.child(currentUserId!).updateChildValues(["tokens" : tokens])
    
    //    appDelegage.tokensDict.removeAll()
  }
}
