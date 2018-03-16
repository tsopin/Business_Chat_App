//
//  AddContactVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-10.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase


class AddContactVC: UIViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let currentUserId = (Auth.auth().currentUser?.uid)!
    let currentUserEmail = (Auth.auth().currentUser?.email)!
    var usersArray = [User]()
    var chosenUserArray = [String]()
    var chatsArray = [String]()
    let dataServices = DataServices()
    
    @IBAction func doneBtn(_ sender: Any) {
        
        
        DataServices.instance.getUsersIds(forUsernames: chosenUserArray, handler: { (idsArray) in
            let userIds = idsArray
//            userIds.append(self.currentUserId)
            
            DataServices.instance.addContact(forUsersIds: userIds, handler: { (contactCreated) in
                
                if contactCreated {
                    self.presentStoryboard()
                }else {
                    print("Contact Adding Error")
                }
            })
        })
        
        DataServices.instance.getUsersIds(forUsernames: chosenUserArray, handler: { (idsArray) in
            let userIds = idsArray
            var newIds = [String:String]()
            
            for i in idsArray{
                newIds[i] = self.currentUserId
            }
            
//            userIds = userIds.filter{$0 != "Hello"}
//            userIds.append(self.currentUserId)
            
            
            
            for eachMember in idsArray {
            
            DataServices.instance.createPersonalChat(forChatName: self.currentUserEmail, forMemberIds: newIds, forGroupChat: false, handler: { (chatCreated) in
                if chatCreated {
                    self.dataServices.addPersonalChatsToUser()
                    
                }else {
                    print("Chat Creation Error")
                }
            })
        }
        })
        
    }
    
//        @IBAction func closeBtn(_ sender: Any) {
//            self.dismiss(animated: true, completion: nil)
//        }
    
    
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneButton.isEnabled = false
        
        DataServices.instance.REF_USERS.observe(.value) { (snapshot) in
            DataServices.instance.getAllUsers{ (returnedUsersArray) in
                self.usersArray = returnedUsersArray
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        hideKeyboardWhenTappedAround()
    }
    
    func presentStoryboard() {
        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabViewController") as UIViewController
        self.present(vc, animated: true, completion: nil)
        print("GoGoGo")
    }
    
    
}

extension AddContactVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? SearchUserForContactCell else {return UITableViewCell() }
        
        //        let profileImage = UIImage(named: "notMe")
        //        if chosenUserArray.contains(usersArray[indexPath.row]) {
        //
        //
        //            cell.cronfigureCell(email: usersArray[indexPath.row], isSelected: true)
        //        }else{
        let user = usersArray[indexPath.row]
        cell.cronfigureCell(email: user.email, userName: user.userName, isSelected: false)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchUserForContactCell else {return}
        
        if !chosenUserArray.contains(cell.emailLabel.text!) {
            chosenUserArray.append(cell.emailLabel.text!)
            
            doneButton.isEnabled = true
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLabel.text! })
            if chosenUserArray.count >= 1 {
                
            } else {
                
                doneButton.isEnabled = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersArray.count
    }
}

extension AddContactVC: UITextFieldDelegate {
    
}
