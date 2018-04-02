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

class MessageServices {
  
  static let instance = MessageServices()
  
  private var _REF_DATABASE = DATABASE
  private var _REF_MESSAGES = DATABASE.child("messages")
  
  var REF_MESSAGES: DatabaseReference {
    _REF_MESSAGES.keepSynced(true)
    return _REF_MESSAGES
  }
  
  // Upload message to Database
  func sendMessage(withContent content: String, withTimeSent timeSent: String, withMessageId messageId: String, forSender senderId: String, withChatId chatId: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
    
    REF_MESSAGES.child(chatId!).child(messageId).setValue(["content" : content,
                                                           "senderId" : senderId,
                                                           "timeSent": timeSent ])
    sendComplete(true)
  }
  
  // Get all messages from Database
  func getAllMessagesFor(desiredChat: Chat, handler: @escaping (_ messagesArray: [Message]) -> ()) {
    
    var groupMessageArray = [Message]()
    
    REF_MESSAGES.child(desiredChat.key).observe(DataEventType.value, with: { (groupMessageSnapshot) in
      guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
      
      for groupMessage in groupMessageSnapshot {
        
        guard let content = groupMessage.childSnapshot(forPath: "content").value as? String else {return}
        guard let senderId = groupMessage.childSnapshot(forPath: "senderId").value as? String else {return}
        guard let timeSent = groupMessage.childSnapshot(forPath: "timeSent").value as? String else {return}
        
        let groupMessage = Message(content: content, timeSent: timeSent, senderId: senderId)
        groupMessageArray.append(groupMessage)
        
      }
      handler(groupMessageArray)
    })
  }
}











