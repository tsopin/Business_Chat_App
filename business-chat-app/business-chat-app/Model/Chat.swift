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
    private var _memberCount: Int
    private var _members: [String:Bool]
    private var _chatKey: String
    
    var chatName: String {
        return _chatName
    }
    
    var memberCount: Int {
        return _memberCount
    }
    var members: [String:Bool] {
        return _members
    }
    var key: String {
        return _chatKey
    }
    
    init(name: String, members: [String:Bool], chatKey: String, memberCount: Int ) {
        self._chatName = name
        self._members = members
        self._chatKey = chatKey
        self._memberCount = memberCount
    }
    
    
}
