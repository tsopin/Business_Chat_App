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
  let dataServices = Services()
  
  @IBAction func doneBtn(_ sender: Any) {
    
    UserServices.instance.getUsersIds(forUsernames: chosenUserArray, handler: { (idsArray) in
      
      let userIds = idsArray
      
      UserServices.instance.addContact(forUsersIds: userIds, handler: { (contactCreated) in
        
        if contactCreated {
          self.presentStoryboard()
        }else {
          print("Contact Adding Error")
        }
      })
      
      ChatServices.instance.createChat(forChatName: "default", forMemberIds: userIds, forGroupChat: false, handler: { (chatCreated) in
        if chatCreated {
          
//          UserServices.instance.addChatToUser(isGroup: false)
          
        } else {
          print("Chat Creation Error")
        }
      })
    })
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    doneButton.isEnabled = false
    
    UserServices.instance.REF_USERS.observe(.value) { (snapshot) in
      UserServices.instance.getAllUsers{ (returnedUsersArray) in
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
  deinit{
    
  }
}


extension AddContactVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? SearchUserForContactCell else {return UITableViewCell() }
    
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

