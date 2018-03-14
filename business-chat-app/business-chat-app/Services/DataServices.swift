//
//  DataService.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-13.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import Foundation
import Firebase

let DATABASE = Database.database().reference()
let currentUser = Auth.auth().currentUser?.uid

class DataServices {
    static let instance = DataServices()
    
    
    private var _REF_DATABASE = DATABASE
    private var _REF_USERS = DATABASE.child("users")
    private var _REF_CHATS = DATABASE.child("chats")

    var REF_DATABASE: DatabaseReference {
        return _REF_DATABASE
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    var REF_CHATS: DatabaseReference {
        return _REF_CHATS
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
//    func createChat(chatId: String, members: [String]) {
//        REF_CHATS.childByAutoId().updateChildValues(userData)
//    }
    
    
    func getAllUsers(handler: @escaping (_ groupsArray: [User]) -> ()) {
        
        var usersArray = [User]()
        REF_DATABASE.observeSingleEvent(of: .childAdded) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                
                    
                
                    let userName = user.childSnapshot(forPath: "username").value as! String
                    let email = user.childSnapshot(forPath: "email").value as! String
                

                let user = User(userName: userName, email: email)
                    
                    usersArray.append(user)
                
            }
            handler(usersArray)
        }
        
        
    }
    func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        
        
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
    
 
    
    func addContact(forUsersIds ids: [String], handler: @escaping (_ contactAdded: Bool) -> ()) {
        
        var newContacts = [String:Bool]()
        
        for user in ids {
            
            newContacts[user] = true
        }
        
        REF_USERS.child(currentUser!).child("contactList").updateChildValues(newContacts)
        
        handler(true)
        
    }
    
    func addChat(forChatName chatName: String, forMemberIds memberIds: [String], handler: @escaping (_ chatCreated: Bool) -> ()) {
        
        var newMembers = [String:Bool]()
        
        for member in memberIds {
            
            newMembers[member] = true
        }
        
        
        REF_CHATS.child(currentUser!).child("members").setValue(newMembers)
        REF_CHATS.child(currentUser!).child("chatName").setValue(chatName)
        
        handler(true)
        
    }
    
    func getMyContacts(handler: @escaping (_ groupsArray: [User]) -> ()) {
  
        
    }
    

    
    
}
