//
//  Message.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-13.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class Message {
    
    private var _content: String
    private var _timeSent: String
    private var _senderName: String
    
    
    var content : String {
        return _content
    }
    var timeSent : String {
        return _timeSent
    }
    var userName : String {
        return _senderName
    }

    
    init(content: String, timeSent: String, senderName: String, email: String) {
        self._content = content
        self._timeSent = timeSent
        self._senderName = senderName

    }
    
    
}
