//
//  Chat.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-13.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit


class Chat {
    
    private var _chatName: String
    private var _members: [String]
//    private var _isGroupChat: Bool?
    
    
    var chatName: String {
        return _chatName
    }
    var members: [String] {
        return _members
    }

    
    init(chatName: String, members: [String]) {
        self._chatName = chatName
        self._members = members

    }
}

