//
//  DataService.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-13.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import Foundation
import Firebase

let DATABASE = Database.database().reference()
let currentUser = Auth.auth().currentUser?.uid

class DataServices {
    static let instance = DataServices()
    
    
    private var _REF_DATABASE = DATABASE
    private var _REF_USERS = DATABASE.child("users")
//    private var _REF_CHATS = DATABASE

    var REF_DATABASE: DatabaseReference {
        return _REF_DATABASE
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getAllUsers(handler: @escaping (_ groupsArray: [User]) -> ()) {
        
        var usersArray = [User]()
        REF_DATABASE.observeSingleEvent(of: .childAdded) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                
                    
                
                    let userName = user.childSnapshot(forPath: "username").value as! String
                    let email = user.childSnapshot(forPath: "email").value as! String
                

                let user = User(userName: userName, email: email)
                    
                    usersArray.append(user)
                
            }
            handler(usersArray)
        }
        
        
    }
    func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            
            var idArray = [String]()
            
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                
                let email = user.childSnapshot(forPath: "email").value as! String
                if usernames.contains(email) {
                    idArray.append(user.key)
                }
                
            }
            
            handler(idArray)
        }
    }
    
    func addContact(forUsersIds ids: [String], handler: @escaping (_ contactAdded: Bool) -> ()) {
        
        REF_USERS.child((Auth.auth().currentUser?.uid)!).updateChildValues(["contactList": ids])
        handler(true)
        
    }
    
    func getMyContacts(handler: @escaping (_ groupsArray: [User]) -> ()) {
        
//        var contactListArray = [User]()
//        REF_USERS.observeSingleEvent(of: .value) { (contactSnapshot) in
//            guard let contactSnapshot = contactSnapshot.children.allObjects as? [DataSnapshot] else {return}
//
//            for contact in contactSnapshot {
//                let contactArray = contact.childSnapshot(forPath: "contactList").value as! [String]
//                if contactArray.contains(currentUser!) {
//
//                    let userName = contact.childSnapshot(forPath: "userName").value as! String
//                    let email = contact.childSnapshot(forPath: "email").value as! String
//
//
//                    let contact = User(userName: userName, email: email)
//
//                    contactListArray.append(contact)
//                }
//            }
//            handler(contactListArray)
//        }
        
        
    }
    
//    func getAllFeedUsers(handler: @escaping (_ users: [User])-> ()) {
//        var usersArray = [User]()
//        REF_USERS.observeSingleEvent(of: .value) { (allUsersSnapshot) in
//            guard let allUsersSnapshot = allUsersSnapshot.children.allObjects as? [DataSnapshot] else {return}
//            
//            for user in allUsersSnapshot {
//                
//                let userName = user.childSnapshot(forPath: "userName").value as! String
//                let email = user.childSnapshot(forPath: "email").value as! String
//                let contactList = user.childSnapshot(forPath: "contactList").value as! [String]
//                let users = User(userName: userName, email: email)
//                usersArray.append(users)
//            }
//            
//            handler(usersArray)
//            
//            
//        }
//        
//    }
    
    
}
