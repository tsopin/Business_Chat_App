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
    
    private var _REF_DATABASE = DATABASE
    private var _REF_USERS = DATABASE.child("users")
    private var _REF_CHATS = DATABASE.child("chats")
    private var _REF_MESSAGES = DATABASE.child("messages")
    private var _REF_STATUS = DATABASE.child(".info/connected")
    private var _REF_STORAGE_USER_IMAGES = STORAGE.child("userImages")
    
    var REF_DATABASE: DatabaseReference {
        
        _REF_DATABASE.keepSynced(true)
        return _REF_DATABASE
    }
    var REF_STORAGE_USER_IMAGES: StorageReference {
        
        //        _REF_STORAGE.keepSynced(true)
        return _REF_STORAGE_USER_IMAGES
    }
    var REF_USERS: DatabaseReference {
        
        _REF_USERS.keepSynced(true)
        return _REF_USERS
    }
    var REF_CHATS: DatabaseReference {
        
        _REF_CHATS.keepSynced(true)
        return _REF_CHATS
    }
    var REF_MESSAGES: DatabaseReference {
        
        _REF_MESSAGES.keepSynced(true)
        return _REF_MESSAGES
    }
    var REF_STATUS: DatabaseReference {
        
        _REF_STATUS.keepSynced(true)
        return _REF_STATUS
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
        handler(true)
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
    
    func updateUserStatus(withStatus userStatus: String, handler: @escaping (_ chatUpdated: Bool) -> ()) {
        
        REF_USERS.child(currentUserId!).updateChildValues(["status" : userStatus])
        handler(true)
    }
    
    // Create a new group chat
    func createChat(forChatName chatName: String, forMemberIds memberIds: [String], forGroupChat isGroupChat: Bool, handler: @escaping (_ chatCreated: Bool) -> ()) {
        
        var newMembers = [String:Bool]()
        
        switch isGroupChat{
            
        case true:
            for member in memberIds {
                newMembers[member] = true
            }
            
            REF_CHATS.childByAutoId().setValue(["isGroupChat" : isGroupChat,
                                                "members" : newMembers,
                                                "chatName" : chatName])
            handler(true)
            
        case false:
            for memberId in memberIds {
                
                REF_CHATS.childByAutoId().setValue(["isGroupChat" : isGroupChat,
                                                    "members" : [memberId:true, currentUserId!:true],
                                                    "chatName" : chatName])
            }
            handler(true)
        }
    }
    
    //  Update user's active personal chats with choosen chats
    func addChatToUser(isGroup: Bool)  {
        
        switch isGroup{
            
        case true:
            Services.instance.getMyGroupIds(withMe: currentUserId!, handler: { (groupIdsArray) in
                self.REF_USERS.child(currentUserId!).updateChildValues(["activeGroupChats" : groupIdsArray])
            })
        
        case false:
            Services.instance.getMyPersonalChatsIds(withMe: currentUserId!, handler: { (idsArray) in
                self.REF_USERS.child(currentUserId!).updateChildValues(["activePersonalChats" : idsArray])
            })
        }
    }
    
    // Upload message to Database
    
    func sendMessage(withContent content: String, withTimeSent timeSent: String, withMessageId messageId: String, forSender senderId: String, withChatId chatId: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        
        
        REF_MESSAGES.child(chatId!).child(messageId).setValue(["content" : content,
                                                               "senderId" : senderId,
                                                               "timeSent": timeSent ])
        sendComplete(true)
    }
    
    //    MARK: Getting users, chat, contacts
    
    //    Get my all personal chats
    func getMyPersonalChats(handler: @escaping (_ contactsArray: [Chat]) -> ()) {
        
        var chatsArray = [Chat]()
        REF_CHATS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for group in groupSnapshot {
                var chatNamesAray = [String]()
                var chatName = String()
                let isGroupArray = group.childSnapshot(forPath: "isGroupChat").value as! Bool
                let memberArray = group.childSnapshot(forPath: "members").value as! [String:Bool]
                if  isGroupArray == false && memberArray.keys.contains(currentUserId!) {
                    
                    //let groupName = group.childSnapshot(forPath: "chatName").value as! String
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
                guard let status = user.childSnapshot(forPath: "status").value as? String else {return}
                
                let user = User(userName: userName, email: email, status: status)
                
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
    func getUserData(byUserId userId: String, handler: @escaping (_ userData: (String,String,String)) -> ()) {
        
        REF_USERS.observe(DataEventType.value, with: { (userSnapshot) in
            
            var returnedEmail = String()
            var returnedUsername = String()
            var returnedStatus = String()
            
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                
                let userEmail = user.childSnapshot(forPath: "email").value as! String
                let userName = user.childSnapshot(forPath: "username").value as! String
                let status = user.childSnapshot(forPath: "status").value as! String
                // let userPic = user.childSnapshot(forPath: "avatar").value as! Bool
                
                if user.key == userId {
                    
                    returnedEmail = userEmail
                    returnedUsername = userName
                    returnedStatus = status
                }
                handler((returnedEmail, returnedUsername, returnedStatus))
            }
        })
    }
    
    //Get Info for user ID
    func getUserImage(byUserId userId: String, handler: @escaping (_ userImageUrl: URL) -> ()) {
        
        
        REF_STORAGE_USER_IMAGES.child(userId).downloadURL { (url, error) in
            //using a guard statement to unwrap the url and check for error
            guard let imageURL = url, error == nil else {
                if error != nil {
//                    print("FILE NOT EXIST")
                }
                return}
            
            handler(imageURL)
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
                if chatId.keys.contains(currentUserId!) {
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
                let status = user.childSnapshot(forPath: "status").value as! String
                //                let userPicUrl = user.childSnapshot(forPath: "avatarUrl").value as! String
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    let user = User(userName: userName, email: email, status: status)
                    userArray.append(user)
                }
            }
            handler(userArray)
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
    
    func getAllMessagesFor(desiredChat: Chat, handler: @escaping (_ messagesArray: [Message]) -> ()) {
        
        var groupMessageArray = [Message]()
        REF_MESSAGES.child(desiredChat.key).observe(DataEventType.value, with: { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for groupMessage in groupMessageSnapshot {
                
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let timeSent = groupMessage.childSnapshot(forPath: "timeSent").value as! String
                let groupMessage = Message(content: content, timeSent: timeSent, senderId: senderId)
                
                groupMessageArray.append(groupMessage)
            }
            handler(groupMessageArray)
        })
    }
}





