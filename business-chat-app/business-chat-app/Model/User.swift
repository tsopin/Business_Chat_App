//
//  User.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-13.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class User {
    
    private var _userName: String
    private var _email: String
//    private var _activeChats: [String]
    //    private var _contactList: [String]
    
    var userName: String {
        return _userName
    }
    var email: String {
        return _email
    }
//    var activeChat: [String] {
//        return _activeChats
//    }
    //    var contactList: [String]? {
    //        return _contactList
    //    }
    
    init(userName: String, email: String) {
        self._userName = userName
        self._email = email
//        self._activeChats = activeChat
        //        self._contactList = contactList
        
    }
    
    
}
