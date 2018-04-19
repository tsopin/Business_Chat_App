//
//  MessageServices.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-31.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SVProgressHUD

class MessageServices {
  
  static let instance = MessageServices()
  
  private var _REF_DATABASE = DATABASE
  private var _REF_MESSAGES = DATABASE.child("messages")
  
  var REF_MESSAGES: DatabaseReference {
    _REF_MESSAGES.keepSynced(true)
    return _REF_MESSAGES
  }
  
  // Upload message to Database
  func sendMessage(withContent content: String, withTimeSent timeSent: Int64, withMessageId messageId: String, forSender senderId: String, withChatId chatId: String?, isMultimedia: Bool, sendComplete: @escaping (_ status: Bool) -> ()) {
    
    REF_MESSAGES.child(chatId!).child(messageId).setValue(["content" : content,
                                                           "senderId" : senderId,
                                                           "timeSent": timeSent,
                                                           "isMultimedia" : isMultimedia])
    ChatServices.instance.REF_CHATS.child(chatId!).child("lastMessageTimeStamp").setValue(timeSent)
    sendComplete(true)
  }
  
  func sendPhotoMessage(isMulti: Bool, withMediaUrl mediaUrl: String, withTimeSent timeSent: Int64, withMessageId messageId: String, forSender senderId: String, withChatId chatId: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
    
    REF_MESSAGES.child(chatId!).child(messageId).setValue(["isMultimedia" : isMulti,
                                                           "content" : mediaUrl,
                                                           "senderId" : senderId,
                                                           "timeSent": timeSent])
    
    ChatServices.instance.REF_CHATS.child(chatId!).child("lastMessageTimeStamp").setValue(timeSent)
    sendComplete(true)
  }
  
  // Get all messages from Database
  func getAllMessagesFor(desiredChat: Chat, handler: @escaping (_ messagesArray: [Message]) -> ()) {
    
    var messageArray = [Message]()
    var returnedMediaUrl = String()
    var returnedContent = String()
    
    REF_MESSAGES.child(desiredChat.key).observeSingleEvent(of: .value, with: { (messageSnapshot) in
      guard let messageSnapshot = messageSnapshot.children.allObjects as? [DataSnapshot] else {return}
      
      for message in messageSnapshot {
        
        guard let senderId = message.childSnapshot(forPath: "senderId").value as? String else {return}
        guard let timeSent = message.childSnapshot(forPath: "timeSent").value as? Int64 else {return}
        guard let isMultimediaMessage = message.childSnapshot(forPath: "isMultimedia").value as? Bool else {return}
        
        if isMultimediaMessage == true {
          let mediaUrl = message.childSnapshot(forPath: "content").value as! String
          returnedMediaUrl = mediaUrl
          //          print("GOT MEDIA URL \(returnedMediaUrl)")
        } else {
          guard let content = message.childSnapshot(forPath: "content").value as? String else {return}
          returnedMediaUrl = "NoMediaUrl"
          returnedContent = content
        }
        
        let message = Message(content: returnedContent, timeSent: timeSent, senderId: senderId, isMultimedia: isMultimediaMessage, mediaUrl: returnedMediaUrl)
        messageArray.append(message)
        
      }
      handler(messageArray)
    })
  }
}











