//
//  Group.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-15.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class Chat {
    
    private var _chatName: String
    private var _memberCount: String
    private var _members: [String:Bool]
    private var _chatKey: String
    private var _lastMessage: String
    
    var chatName: String {
        return _chatName
    }
    
    var memberCount: String {
        return _memberCount
    }
    var members: [String:Bool] {
        return _members
    }
    var key: String {
        return _chatKey
    }
  var lastMessage: String {
    return _lastMessage
  }
    
  init(name: String, members: [String:Bool], chatKey: String, memberCount: String, lastMessage: String) {
        self._chatName = name
        self._members = members
        self._chatKey = chatKey
        self._memberCount = memberCount
        self._lastMessage = lastMessage
    }
    
    
}
