//
//  AddGroupVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-15.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class AddGroupVC: UIViewController, UISearchResultsUpdating {
  @IBOutlet weak var groupNameTextfield: UITextField!
  // @IBOutlet weak var invitedUsers: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var doneBtn: UIBarButtonItem!
  
  let searchController = UISearchController(searchResultsController: nil)
  
  var userArray = [User]()
  var chosenUserArray = [String]()
  var Array = [String]()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    doneBtn.isEnabled = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up the Search Controller
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Find by email and select"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
    self.hideKeyboardWhenTappedAround()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  
  
  @IBAction func doneButtonPressed(_ sender: Any) {
    
    var groupName = ""
    if groupNameTextfield.text != "" {
      groupName = groupNameTextfield.text!
    } else {
      groupName = "New group"
    }
    
    UserServices.instance.getUsersIds(forUsernames: chosenUserArray, handler: { (idsArray) in
      var userIds = idsArray
      userIds.append(currentUserId!)
      
      ChatServices.instance.createChat(forChatName: groupName, forMemberIds: userIds, forGroupChat: true, handler: { (chatCreated) in
        if chatCreated {
          
//          UserServices.instance.addChatToUser(isGroup: true)
        }else {
          print("Chat Creation Error")
        }
      })
    })
    navigationController?.popViewController(animated: true)
  }
  deinit{
    
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
      // invitedUsers.text = chosenUserArray.joined(separator: ", ")
      doneBtn.isEnabled = true
    } else {
      chosenUserArray = chosenUserArray.filter({ $0 != cell.email.text! })
      if chosenUserArray.count >= 1 {
        // invitedUsers.text = chosenUserArray.joined(separator: ", ")
      } else {
        // invitedUsers.text = "Add people to your Group"
        self.doneBtn.isEnabled = false
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return userArray.count
    
  }
  
  // MARK: -- Search --
  
  func searchBarDidBeginEditing() {
    if searchController.isActive {
      print("search in progress")
      if (searchController.searchBar.text?.isEmpty)! {
        userArray = []
        tableView.reloadData()
      } else {
        UserServices.instance.getUserInfoByEmail(forSearchQuery: self.searchController.searchBar.text!, handler: { (returnedEmailArray) in
          self.userArray = returnedEmailArray
          self.tableView.reloadData()
        })
      }
    }
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
    searchBarDidBeginEditing()
  }
  
  
  
}


