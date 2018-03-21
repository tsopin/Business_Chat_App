////
////  AuthService.swift
////  business-chat-app
////
////  Created by Timofei Sopin on 2018-03-13.
////  Copyright © 2018 Brogrammers. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//class AuthService {
//
//    static let instance = AuthService()
//
//    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            guard let user = user else {
//                userCreationComplete(false, error)
//                return
//            }
//
//            let userData = ["provider": user.providerID, "email": user.email]
//            Services.instance.createDBUser(uid: user.uid, userData: userData)
//            userCreationComplete(true, nil)
//        }
//    }
//
//
//    func loginUser(withEmail email: String, andPassword password: String, userLoginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//            if error != nil {
//                userLoginComplete(false, error)
//                return
//            }
//            userLoginComplete(true, nil)
//        }
//    }
//
//}
//
