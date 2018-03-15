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
    //Create new user in database
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    //Get list of all users from Firebase
    func getAllUsers(handler: @escaping (_ allUsersArray: [User]) -> ()) {
        
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
    
    //Get chats ID's by members
    func getMyChatsIds(withMe myId: String, handler: @escaping (_ uidArray: [String:Bool]) -> ()) {
        
        
        REF_CHATS.observeSingleEvent(of: .value) { (userSnapshot) in
            
            var chatIdsArray = [String:Bool]()
            
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for chat in userSnapshot {
                
                let chatId = chat.childSnapshot(forPath: "members").value as! [String:Bool]
                if chatId.contains(where: { $0.value }) {
                    chatIdsArray[chat.key] = true
                }
            }
            handler(chatIdsArray)
        }
    }
    
    
    // Get username and email
    func getUserInfo(forSearchQuery query: String, handler: @escaping (_ usersDataArray: [User]) -> ()) {
        
        var userArray = [User]()
        
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                let userName = user.childSnapshot(forPath: "username").value as! String
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    let user = User(userName: userName, email: email)
                    userArray.append(user)
                }
            }
            handler(userArray)
        }
    }
    
    
    // Add contact
    func addContact(forUsersIds ids: [String], handler: @escaping (_ contactAdded: Bool) -> ()) {
        
        var newContacts = [String:Bool]()
        var activeChats = [String:Bool]()
        activeChats[currentUser!] = true
        
        for user in ids {
            
            newContacts[user] = true
        }
        REF_USERS.child(currentUser!).updateChildValues(["contactList" : newContacts,
                                                         "activeChats" : activeChats])
        
        handler(true)
        
    }
    
    // Update chats contact
    func updateChat(forChat chatIds: [String:Bool], handler: @escaping (_ chatUpdated: Bool) -> ()) {

        REF_USERS.child(currentUser!).child("activeChats").updateChildValues(chatIds)
        handler(true)
    }
    
    // Create new chat
    func addChat(forChatName chatName: String, forMemberIds memberIds: [String], forGroupChat isGroupChat: Bool, handler: @escaping (_ chatCreated: Bool) -> ()) {
        
        var newMembers = [String:Bool]()
        
        for member in memberIds {
            
            newMembers[member] = true
        }
        
        REF_CHATS.childByAutoId().setValue(["isGroupChat" : isGroupChat,
                                            "members" : newMembers,
                                            "chatName" : chatName])
        
        handler(true)
    }
    
    //    Update user's active chats with choosen chats
    func addChatsToUser()  {
        
        DataServices.instance.getMyChatsIds(withMe: currentUser!, handler: { (idsArray) in
            DataServices.instance.updateChat( forChat: idsArray, handler: { (chatCreated) in
                if chatCreated {
                    
                  print("Chat added")
                    
                }else {
                    print("Chat addition Error")
                }
            })
        })
        
    }
    
    
    func getMyContacts(handler: @escaping (_ contactsArray: [User]) -> ()) {
        
        
    }
    func getMyGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        
        var groupsArray = [Group]()
        REF_CHATS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for group in groupSnapshot {
                let isGroupArray = group.childSnapshot(forPath: "isGroupChat").value as! Bool
                let memberArray = group.childSnapshot(forPath: "members").value as! [String:Bool]
                if  isGroupArray == true && memberArray.keys.contains(currentUser!) {
                    
                    let groupName = group.childSnapshot(forPath: "chatName").value as! String
                    
                    let group = Group(name: groupName, members: memberArray, memberCount: memberArray.count)
                    
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
        
        
    }
        
        
    }
    
    
    


