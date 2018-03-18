//
//  AddGroupVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-15.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class AddGroupVC: UIViewController {
    @IBOutlet weak var groupNameTextfield: UITextField!
    @IBOutlet weak var invitedUsers: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var searchUserTextfield: UITextField!
    
//    let currentUserId = Auth.auth().currentUser?.uid
//    let currentUserEmail = (Auth.auth().currentUser?.email)!
    let dataServices = Services()
    var userArray = [User]()
    var chosenUserArray = [String]()
    var Array = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        searchUserTextfield.delegate = self
        searchUserTextfield.addTarget(self, action: #selector(textViewDidChangeSelection), for: .editingChanged)
    }
    
    @objc func textViewDidChangeSelection(_ textView: UITextView) {
        if searchUserTextfield.text == "" {
            userArray = []
            tableView.reloadData()
        } else {
            Services.instance.getUserInfoByEmail(forSearchQuery: searchUserTextfield.text!, handler: { (returnedEmailArray) in
                self.userArray = returnedEmailArray
                self.tableView.reloadData()
            })
        }
    }


    @IBAction func doneButtonPressed(_ sender: Any) {
        
        Services.instance.getUsersIds(forUsernames: chosenUserArray, handler: { (idsArray) in
            var userIds = idsArray
            userIds.append(currentUserId!)
            
            Services.instance.createGroupChat(forChatName: self.groupNameTextfield.text!, forMemberIds: userIds, forGroupChat: true, handler: { (chatCreated) in
                if chatCreated {
                    
                    self.dataServices.addGroupChatsToUser()
                }else {
                    print("Chat Creation Error")
                }
            })
        })
        presentStoryboard()
    }
    
}


extension AddGroupVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userForGroupCell") as? SearchUserForGroupCell else {return UITableViewCell() }
        
        if chosenUserArray.contains(userArray[indexPath.row].email) {
            cell.cronfigureCell(email: userArray[indexPath.row].email, userName: userArray[indexPath.row].userName , isSelected: true)
        }else{
            cell.cronfigureCell(email: userArray[indexPath.row].email, userName: userArray[indexPath.row].userName, isSelected: false)}
        return cell
    }
    

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchUserForGroupCell else {return}
        
        if !chosenUserArray.contains(cell.email.text!) {
            chosenUserArray.append(cell.email.text!)
            invitedUsers.text = chosenUserArray.joined(separator: ", ")
            doneBtn.isEnabled = true
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.email.text! })
            if chosenUserArray.count >= 1 {
                invitedUsers.text = chosenUserArray.joined(separator: ", ")
            } else {
                invitedUsers.text = "Add people to your Group"
                self.doneBtn.isEnabled = false
            }
        }
    
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userArray.count
   
    }
    
    
//    func presentStoryboard() {
//        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabViewController") as UIViewController
//        self.present(vc, animated: true, completion: nil)
//        print("GoGoGo")
//    }
    
}


