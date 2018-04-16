//
//  ChatServices.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-31.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import CryptoSwift


class ChatServices {
  
  var testOlolo = [String]()
  
  static let instance = ChatServices()
  
  private var _REF_DATABASE = DATABASE
  private var _REF_CHATS = DATABASE.child("chats")
  
  var REF_CHATS: DatabaseReference {
    
    _REF_CHATS.keepSynced(true)
    return _REF_CHATS
  }
  
  // Create a new group chat
  func createChat(forChatName: String, forMemberIds memberIds: [String], forGroupChat isGroupChat: Bool, handler: @escaping (_ chatCreated: Bool) -> ()) {
    
    var newMembers = [String:Bool]()
    var md5ChatId = String()
    let date = Date()
    let currentDate = date.timeIntervalSinceReferenceDate
    
    switch isGroupChat{
      
    case true:
      
      for member in memberIds {
        
        newMembers[member] = true
      }
      let chatId = REF_CHATS.childByAutoId().key
//        forChatName.md5()
      
      
      REF_CHATS.child(chatId).setValue(["isGroupChat" : isGroupChat,
                                        "members" : newMembers,
                                        "chatName" : forChatName,
                                        "lastMessage" : "\(currentDate)"])
      for member in memberIds {
        UserServices.instance.REF_USERS.child(member).child("activeGroupChats").updateChildValues([chatId : true])
      }
      UserServices.instance.REF_USERS.child(currentUserId!).child("activeGroupChats").updateChildValues([chatId : true])
      handler(true)
      
    case false:
      
      for memberId in memberIds {
        
        var memberAndCurrentUser: [String] = [memberId, currentUserId!]
        memberAndCurrentUser = memberAndCurrentUser.sorted()
        md5ChatId = memberAndCurrentUser.joined().md5()
        
        let chatName = memberId + currentUserId!
        
        REF_CHATS.child(md5ChatId).setValue(["isGroupChat" : isGroupChat,
                                             "members" : [memberId:true, currentUserId! : true],
                                             "chatName" : chatName,
                                             "lastMessage" : "\(currentDate)"])
        
        UserServices.instance.REF_USERS.child(memberId).child("activePersonalChats").updateChildValues([md5ChatId : true])
        UserServices.instance.REF_USERS.child(currentUserId!).child("activePersonalChats").updateChildValues([md5ChatId : true])
      }
      handler(true)
    }
    
    
    //    FirebaseMessagingServices.shared.subscribe(to: .newMessage)
  }
  
  
  //    MARK: Getting users, chat, contacts
  
  
  
  //  // GETTING PERSONAL CHATS ID FROM USES activePersonalChats
  func getMyChatsIds(isGroup: Bool, handler: @escaping (_ uidArray: [String]) -> ()) {
    var chatIdsArray = [String]()
    
    
    if isGroup {
      UserServices.instance.REF_USERS.child(currentUserId!).child("activeGroupChats").observeSingleEvent(of: .value) { (chatsSnapshot) in
        guard let returnedPersonalChats = chatsSnapshot.value as? [String:Bool] else {return}
        for chat in returnedPersonalChats.keys {
          chatIdsArray.append(chat)
        }
        handler(chatIdsArray)
        
      }
    } else {
      UserServices.instance.REF_USERS.child(currentUserId!).child("activePersonalChats").observeSingleEvent(of: .value) { (chatsSnapshot) in
        guard let returnedPersonalChats = chatsSnapshot.value as? [String:Bool] else {return}
        for chat in returnedPersonalChats.keys {
          chatIdsArray.append(chat)
        }
        handler(chatIdsArray)
      }
    }
  }
  
  // GETTING CHAT INFO BY ID
  func getMyChats(forIds: [String], handler: @escaping (_ contactsArray: [Chat]) -> ()) {
    
    var chatsArray = [Chat]()
    
    for id in forIds {
      
      REF_CHATS.child(id).observeSingleEvent(of: .value) { (chatSnapshot) in
        
        var returnedChatName = String()
        var returnedMembers = [String:Bool]()
        
        guard let data = chatSnapshot.value as? NSDictionary else {return}
        guard let chatName = data["chatName"] as? String else {return}
        guard let members = data["members"] as? [String:Bool] else {return}
        guard let lastMessage = data["lastMessage"] as? String else {return}
        
        let chatKey = id
        returnedMembers = members
        returnedChatName = chatName
        
        let newchatName = returnedChatName.replacingOccurrences(of: currentUserId!, with: "")
        let group = Chat(name: newchatName, members: returnedMembers, chatKey: chatKey, memberCount: "\(returnedMembers.count)", lastMessage: lastMessage)
        
        chatsArray.append(group)
        
        handler(chatsArray)
      }
    }
  }

  
  func deleteChatFromUser(isGroup: Bool, chatId: String) {
    
    let killer = [chatId:nil] as [String : Any?]
    
    if isGroup {
      UserServices.instance.REF_USERS.child(currentUserId!).child("activeGroupChats").updateChildValues(killer as Any as! [AnyHashable : Any])
      
    } else {
      UserServices.instance.REF_USERS.child(currentUserId!).child("activePersonalChats").updateChildValues(killer as Any as! [AnyHashable : Any])
    }
  }
  
}
