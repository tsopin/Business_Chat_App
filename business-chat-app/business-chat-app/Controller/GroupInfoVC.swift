//
//  GroupInfoVC.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 22/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class GroupInfoVC: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var groupInfoTableView: UITableView!
  
  var chat: Chat?
  var memberIds: [String] = []
  var groupName = ""
  
  func initData(forChat chat: Chat){
    self.chat = chat
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = chat?.chatName
    self.hideKeyboardWhenTappedAround()
    saveButton.isEnabled = false
    
    for member in (chat?.members)! {
      memberIds.append(member.key)
    }
  }
  
  // Add "Save" button to navigation bar when editing begins
  func textFieldDidBeginEditing(_ textField: UITextField) {
    saveButton.isEnabled = true
    groupName = textField.text!
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    groupName = textField.text!
  }
 
  // Save chat details
  
  @IBAction func saveGroupInfo(_ sender: UIBarButtonItem) {
    self.view.endEditing(true)
    //        let chatKey = chat?.key
    //        ChatServices.instance.REF_CHATS.child("\(chatKey!)/chatName").setValue(groupName)
    ChatServices.instance.createChat(forChatName: groupName, forMemberIds: memberIds, forGroupChat: true) { (complete) in
      
    }
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: -- Navigation --
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showGroupMemberProfile" {
      let indexPath = groupInfoTableView.indexPathForSelectedRow
      let userId = memberIds[(indexPath?.row)!]
      let userProfileVC = segue.destination as! UserProfileVC
      userProfileVC.userId = userId
    }
  }
}


// MARK: -- TableView implementation --
extension GroupInfoVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "Group name" : "Group members"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 1 : memberIds.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "groupNameCell") as! GroupNameCell
      cell.groupNameTextField.text = chat?.chatName
      cell.groupNameTextField.delegate = self
      return cell
    } else {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "groupMemberCell") as! GroupMemberCell
      
      UserServices.instance.getUserData(byUserId: memberIds[indexPath.row], handler: { (userData) in
        cell.usernameLabel.text = userData.1
        cell.userEmailLabel.text = userData.0
      })
      
      
      //                Services.instance.getUserName(byUserId: memberIds[indexPath.row], handler: { (username) in
      //                    cell.usernameLabel.text = username
      //                })
      //                Services.instance.getUserEmail(byUserId: memberIds[indexPath.row], handler: { (email) in
      //                    cell.userEmailLabel.text = email
      //                })
      return cell
      
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.section == 0 ? 44 : 70
  }

}



