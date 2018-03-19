//
//  Services.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-13.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import Foundation
import Firebase

let DATABASE = Database.database().reference()
let currentUserId = Auth.auth().currentUser?.uid
let currentEmail = Auth.auth().currentUser?.email
let currentUserName = Auth.auth().currentUser?.uid



class Services {
    static let instance = Services()
    
    
    private var _REF_DATABASE = DATABASE
    private var _REF_USERS = DATABASE.child("users_test")
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
    
    
    //MARK: Add and update data to Database
    
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
        //
        
        handler(true)
        
    }
    
    // Update personal chats in database
    func updatePersonalChat(forPersonalChat chatIds: [String:Bool], handler: @escaping (_ chatUpdated: Bool) -> ()) {
        
        REF_USERS.child(currentUserId!).updateChildValues(["activePersonalChats" : chatIds])
        handler(true)
    }
    // Update group chats in database
    func updateGroupChat(forGroupChats activeGroupChatsIds: [String:Bool], handler: @escaping (_ chatUpdated: Bool) -> ()) {
        
        REF_USERS.child(currentUserId!).updateChildValues(["activeGroupChats" : activeGroupChatsIds])
        handler(true)
    }
    
    // Create a new group chat
    func createGroupChat(forChatName chatName: String, forMemberIds memberIds: [String], forGroupChat isGroupChat: Bool, handler: @escaping (_ chatCreated: Bool) -> ()) {
        
        var newMembers = [String:Bool]()
        
        for member in memberIds {
            
            newMembers[member] = true
        }
        
        REF_CHATS.childByAutoId().setValue(["isGroupChat" : isGroupChat,
                                            "members" : newMembers,
                                            "chatName" : chatName])
        handler(true)
    }
    // Create a new group chat
    func createPersonalChat(forChatName chatName: String, forMemberIds memberIds: [String:String], forGroupChat isGroupChat: Bool, handler: @escaping (_ chatCreated: Bool) -> ()) {
        
        let newMembers = Array(memberIds.keys)
        let meMe = Array(memberIds.values)
        let newArray = newMembers + meMe
        
        
        var goArray = [String:Bool]()
        
        for i in newArray {
            goArray[i] = true
        }
        
        REF_CHATS.childByAutoId().setValue(["isGroupChat" : isGroupChat,
                                            "members" : goArray,
                                            "chatName" : chatName])
        
        handler(true)
    }
    
    //  Update user's active personal chats with choosen chats
    func addPersonalChatsToUser()  {
        
        Services.instance.getMyPersonalChatsIds(withMe: currentUserId!, handler: { (idsArray) in
            
            Services.instance.updatePersonalChat( forPersonalChat: idsArray, handler: { (chatCreated) in
                if chatCreated {
                    
                    print("Chat added")
                    
                }else {
                    print("Chat addition Error")
                }
            })
        })
    }
    
    //  Update user's active group chats with choosen chats
    func addGroupChatsToUser() {
        Services.instance.getMyGroupIds(withMe: currentUserId!, handler: { (groupIdsArray) in
            
            Services.instance.updateGroupChat(forGroupChats: groupIdsArray, handler: { (userUpdated) in
                if userUpdated {
                    
                    print("Group Chat added")
                    
                }else {
                    print("Chat addition Error")
                }
            })
        })
    }
    
    // Upload message to Database
    
    func sendMessage(withContent content: String, withTimeSent timeSent: String, forSender senderId: String, withChatId chatId: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        
        
        REF_CHATS.child(chatId!).child("messages").childByAutoId().updateChildValues(["content" : content,
                                                                                      "senderId" : senderId,
                                                                                      "timeSent": timeSent ])
        sendComplete(true)
        
    }
    
    //    MARK: Getting users, chat, contacts
    
    //    Get my all personal chats
    func getMyContacts(handler: @escaping (_ contactsArray: [Chat]) -> ()) {
        
        var chatsArray = [Chat]()
        REF_CHATS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for group in groupSnapshot {
                var chatNamesAray = [String]()
                var chatName = String()
                let isGroupArray = group.childSnapshot(forPath: "isGroupChat").value as! Bool
                let memberArray = group.childSnapshot(forPath: "members").value as! [String:Bool]
                if  isGroupArray == false && memberArray.keys.contains(currentUserId!) {
                    
//                    let groupName = group.childSnapshot(forPath: "chatName").value as! String
                    chatNamesAray = Array(memberArray.keys)
                    chatNamesAray = chatNamesAray.filter { $0 != currentUserId }
                    chatName = chatNamesAray[0]
                    let groupKey = group.key                     
                    let group = Chat(name: chatName, members: memberArray, chatKey: groupKey, memberCount: "\(memberArray.count)")
                    
                    chatsArray.append(group)
                }
            }
            handler(chatsArray)
        }
        
    }
    
    //    Get my group chats
    func getMyGroups(handler: @escaping (_ groupsArray: [Chat]) -> ()) {
        
        var groupsArray = [Chat]()
        REF_CHATS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for group in groupSnapshot {
                let isGroupArray = group.childSnapshot(forPath: "isGroupChat").value as! Bool
                let memberArray = group.childSnapshot(forPath: "members").value as! [String:Bool]
                if  isGroupArray == true && memberArray.keys.contains(currentUserId!) {
                    
                    let groupName = group.childSnapshot(forPath: "chatName").value as! String
                    
                    let group = Chat(name: groupName, members: memberArray, chatKey: group.key, memberCount: "\(memberArray.count)")
                    
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
        
        
    }
    //    Get all registred users from database
    func getAllUsers(handler: @escaping (_ allUsersArray: [User]) -> ()) {
        
        var usersArray = [User]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                
                guard let userName = user.childSnapshot(forPath: "username").value as? String else {return}
                guard let email = user.childSnapshot(forPath: "email").value as? String else {return}
                let user = User(userName: userName, email: email)
                
                if email != currentEmail{
                    usersArray.append(user)
                }
                
            }
            handler(usersArray)
        }
    }
    
    //    MARK: Getting data for particular entries
    
    //Get Info for current user
    func getmyInfo(handler: @escaping (_ myName: String) -> ()) {
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            
            var myName = String()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                
                let userEmail = user.childSnapshot(forPath: "email").value as! String
                let userName = user.childSnapshot(forPath: "username").value as! String
                
                if userEmail == currentEmail! {
                    myName = userName
					print("this is: \(myName)")
                }
                handler(myName)
            }
            
        }
    }
    //Get Info for user ID
    func getUserEmail(byUserId userId: String, handler: @escaping (_ myName: String) -> ()) {

        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in

            var returnedUserEmail = String()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}

            for user in userSnapshot {

                let userEmail = user.childSnapshot(forPath: "email").value as! String

                if user.key == userId {
                    returnedUserEmail = userEmail
                    print(returnedUserEmail)
                }
                handler(returnedUserEmail)
            }

        }
    }
    
    //Get Info for user ID
    func getUserName(byUserId userId: String, handler: @escaping (_ myName: String) -> ()) {
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            
            var returnedUserName = String()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                
                    let userName = user.childSnapshot(forPath: "username").value as! String
                
                if user.key == userId {
                    returnedUserName = userName
                    print(returnedUserName)
                }
                handler(returnedUserName)
            }
            
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
    
    //Get personal chats ID's by members ID's
    func getMyPersonalChatsIds(withMe myId: String, handler: @escaping (_ uidArray: [String:Bool]) -> ()) {
        
        
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
    
    //Get group chats ID's by members ID's
    func getMyGroupIds(withMe myId: String, handler: @escaping (_ uidArray: [String:Bool]) -> ()) {
        
        
        REF_CHATS.observeSingleEvent(of: .value) { (userSnapshot) in
            
            var chatIdsArray = [String:Bool]()
            
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for chat in userSnapshot {
                
                let isGroup = chat.childSnapshot(forPath: "isGroupChat").value as! Bool
                let chatId = chat.childSnapshot(forPath: "members").value as! [String:Bool]
                if chatId.contains(where: { $0.value }) && isGroup == true {
                    chatIdsArray[chat.key] = true
                }
            }
            handler(chatIdsArray)
        }
    }
    
    // Search users by email
    func getUserInfoByEmail(forSearchQuery query: String, handler: @escaping (_ usersDataArray: [User]) -> ()) {
        
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
    
    
    func getAllMessagesFor(desiredChat: Chat, handler: @escaping (_ messagesArray: [Message]) -> ()) {
        
        var groupMessageArray = [Message]()
        REF_CHATS.child(desiredChat.key).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for groupMessage in groupMessageSnapshot {
                
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let timeSent = groupMessage.childSnapshot(forPath: "timeSent").value as! String
                let groupMessage = Message(content: content, timeSent: timeSent, senderId: senderId)
                
                groupMessageArray.append(groupMessage)
                
            }
            handler(groupMessageArray)
        }
    }
    

    
}





