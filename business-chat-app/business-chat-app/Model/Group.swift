//
//  Group.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-15.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class Group {
    
    private var _groupName: String
    private var _memberCount: Int
    private var _members: [String]
    
    var groupName: String {
        return _groupName
    }
    
    var memberCount: Int {
        return _memberCount
    }
    var members: [String] {
        return _members
    }
    
    init(name: String, members: [String], memberCount: Int ) {
        self._groupName = name
        self._members = members
        self._memberCount = memberCount
    }
    
    
}
