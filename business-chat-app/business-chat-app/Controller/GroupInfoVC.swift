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
	
	// Only updating group name
	let chatKey = chat?.key
	ChatServices.instance.REF_CHATS.child("\(chatKey!)/chatName").setValue(groupName)
	
	// this method creates new group
//    ChatServices.instance.createChat(forChatName: groupName, forMemberIds: memberIds, forGroupChat: true) { (complete) in
//
//    }
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: -- Navigation --
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showGroupMemberProfile" {
      let indexPath = groupInfoTableView.indexPathForSelectedRow
	  let cell = groupInfoTableView.cellForRow(at: indexPath!) as! GroupMemberCell
      let userId = memberIds[(indexPath?.row)!]
      let userProfileVC = segue.destination as! UserProfileVC
      userProfileVC.chatName = userId
	  userProfileVC.title = cell.usernameLabel.text!
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
		cell.configureCell(username: userData.1, userEmail: userData.0, imageUrl: userData.3)
      })
		
      return cell
      
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.section == 0 ? 44 : 70
  }

}



