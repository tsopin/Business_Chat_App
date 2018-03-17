//
//  SettingsViewController.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-05.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class SettingsScreenVC: UIViewController {
    
    
    @IBOutlet weak var userNameTextField: UILabel!
    
    @IBOutlet weak var emailTextField: UILabel!
    
    @IBOutlet weak var userIdTextField: UILabel!
    
 
    let currentUserId = Auth.auth().currentUser?.uid
    let currentEmail = Auth.auth().currentUser?.email
    var currentUserName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userIdTextField.text = currentUserId
        emailTextField.text = currentEmail
        DataServices.instance.getmyInfo(handler: { (myName) in
            self.userNameTextField.text = myName
        })
    }

 
    @IBAction func logOutBtn(_ sender: Any) {
        
        let actionSheets = UIAlertController(title: "Log Out", message: "Are you sure you want to logout?" , preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Log Out", style: .destructive , handler: {
            (alert: UIAlertAction!) -> Void in
            
            do {
                try Auth.auth().signOut()
                print("LogOut")
                self.dismiss(animated: true, completion: nil)
            }
            catch {
                print("Error")
            }
            
        } )
        let cancel = UIAlertAction(title: "Cancel ", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        } )
        
        actionSheets.addAction(action1)
        actionSheets.addAction(cancel)
        self.present(actionSheets, animated: true, completion: nil)
        
    }
}
