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
    private var _timeSent: Int64
    private var _senderId: String
    private var _isMultimedia: Bool
    private var _mediaUrl: String
  
    var content : String {
        return _content
    }
    var timeSent : Int64 {
        return _timeSent
    }
    var senderId : String {
        return _senderId
    }
    var isMultimedia : Bool {
    return _isMultimedia
    }
    var mediaUrl : String {
    return _mediaUrl
    }


    
  init(content: String, timeSent: Int64, senderId: String, isMultimedia: Bool, mediaUrl: String ) {
        self._content = content
        self._timeSent = timeSent
        self._senderId = senderId
        self._isMultimedia = isMultimedia
        self._mediaUrl = mediaUrl
    }
    
    
}
