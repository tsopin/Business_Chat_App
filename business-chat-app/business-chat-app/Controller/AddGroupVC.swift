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
  
  var usersArray = [User]()
  var chosenUsersArray = [String]()
  var filteredUsersArray = [User]()
  // var Array = [String]()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    doneBtn.isEnabled = false
	
		UserServices.instance.REF_USERS.observe(.value) { (snapshot) in
			UserServices.instance.getAllUsers{ (returnedUsersArray) in
				self.usersArray = returnedUsersArray
				self.tableView.reloadData()
			}
		}
	}
  
  override func viewDidLoad() {
    super.viewDidLoad()
	
    
    // Set up the Search Controller
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Find by email and select"
    navigationItem.searchController = searchController
	navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
	navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = false
    
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
    
    UserServices.instance.getUsersIds(forUsernames: chosenUsersArray, handler: { (idsArray) in
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
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return isFiltering() ? filteredUsersArray.count : usersArray.count
	}
	
	
  	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "userForGroupCell") as? SearchUserForGroupCell else {return UITableViewCell() }
		
	let user = isFiltering() ? filteredUsersArray[indexPath.row] : usersArray[indexPath.row]
    
    if chosenUsersArray.contains(user.email) {
      cell.configureCell(email: user.email, userName: user.userName , isSelected: true)
    } else {
      cell.configureCell(email: user.email, userName: user.userName, isSelected: false)
	}

	return cell
  }
	
	
	
	
  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    guard let cell = tableView.cellForRow(at: indexPath) as? SearchUserForGroupCell else {return}
//
//    if !chosenUsersArray.contains(cell.email.text!) {
//      chosenUsersArray.append(cell.email.text!)
//      // invitedUsers.text = chosenUserArray.joined(separator: ", ")
//      doneBtn.isEnabled = true
//    } else {
//      chosenUsersArray = chosenUsersArray.filter({ $0 != cell.email.text! })
//      if chosenUsersArray.count >= 1 {
//        // invitedUsers.text = chosenUserArray.joined(separator: ", ")
//      } else {
//        // invitedUsers.text = "Add people to your Group"
//        self.doneBtn.isEnabled = false
//      }
//    }
//  }
	

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? SearchUserForGroupCell else {return}
		let selectedUserEmail = cell.email.text

		if chosenUsersArray.contains(selectedUserEmail!) {
			chosenUsersArray = chosenUsersArray.filter({ $0 != cell.email.text! })
			cell.setSelected(false, animated: true)
			if chosenUsersArray.count < 1 {
				doneBtn.isEnabled = false
			}
		} else {
			chosenUsersArray.append(selectedUserEmail!)
			cell.setSelected(true, animated: true)
			doneBtn.isEnabled = true
		}
		tableView.reloadData()
	}
	
	
	
	
  
  // MARK: -- Search --
	
	
	  func updateSearchResults(for searchController: UISearchController) {
		filterContentForSearchText(searchController.searchBar.text!)
	  }
	
	// search in email or username
	func filterContentForSearchText(_ searchText: String, scope: String = "All") {
		filteredUsersArray = usersArray.filter({ (user: User) -> Bool in
			return user.email.lowercased().contains(searchText.lowercased()) || user.userName.lowercased().contains(searchText.lowercased())
		})
		tableView.reloadData()
	}
	
	// check if currently performing search to update table view accordingly
	func isFiltering() -> Bool {
		return searchController.isActive && !(searchController.searchBar.text?.isEmpty)!
	}
  
  
  
}


