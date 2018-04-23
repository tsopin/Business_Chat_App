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
  var selectedUsersArray = [User]()
  var filteredUsersArray = [User]()

  
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
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    searchController.isActive = false
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
	
	tableView.delegate = self
	tableView.dataSource = self
    self.hideKeyboardWhenTappedAround()
	
	
  }
  
  
  
  @IBAction func doneButtonPressed(_ sender: Any) {
    
    var groupName = ""
    if groupNameTextfield.text != "" {
      groupName = groupNameTextfield.text!
    } else {
      groupName = "New group"
    }
	
	var chosenUsersArray = [String]()
	for user in selectedUsersArray {
		chosenUsersArray.append(user.email)
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
    navigationController?.dismiss(animated: true, completion: nil)
    self.navigationController?.popToRootViewController(animated: true)
  }
  deinit{
    
  }
}


// MARK: -- TableView setup --

extension AddGroupVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
  

	func numberOfSections(in tableView: UITableView) -> Int {
		return selectedUsersArray.count > 0 ? 2 : 1
	  }
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if numberOfSections(in: tableView) > 1 {
			switch section {
			case 0:
				return selectedUsersArray.count
			case 1:
				return isFiltering() ? filteredUsersArray.count : usersArray.count
			default:
				return usersArray.count
			}
		} else {
			return isFiltering() ? filteredUsersArray.count : usersArray.count
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if numberOfSections(in: tableView) > 1 {
			return section == 0 ? "Selected contacts" : "All contacts"
		} else {
			return "All contacts"
		}
		
	}
	
	
  	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// check if there are more than one sections in tableview
		if numberOfSections(in: tableView) > 1 {
			if indexPath.section == 0 {
				guard let cell = tableView.dequeueReusableCell(withIdentifier: "userForGroupCell") as? SearchUserForGroupCell else {return UITableViewCell() }
				cell.configureCell(email: selectedUsersArray[indexPath.row].email, userName: selectedUsersArray[indexPath.row].userName, imageUrl: selectedUsersArray[indexPath.row].avatarUrl!, isSelected: true)
				return cell
			} else {
				guard let cell = tableView.dequeueReusableCell(withIdentifier: "userForGroupCell") as? SearchUserForGroupCell else {return UITableViewCell() }
				if isFiltering() {
					cell.configureCell(email: filteredUsersArray[indexPath.row].email, userName: filteredUsersArray[indexPath.row].userName, imageUrl: filteredUsersArray[indexPath.row].avatarUrl!, isSelected: false)
				} else {
					cell.configureCell(email: usersArray[indexPath.row].email, userName: usersArray[indexPath.row].userName, imageUrl: usersArray[indexPath.row].avatarUrl!, isSelected: false)
				}
				return cell
			}
		} else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "userForGroupCell") as? SearchUserForGroupCell else {return UITableViewCell() }
			if isFiltering() {
				cell.configureCell(email: filteredUsersArray[indexPath.row].email, userName: filteredUsersArray[indexPath.row].userName, imageUrl: filteredUsersArray[indexPath.row].avatarUrl!, isSelected: false)
			} else {
				cell.configureCell(email: usersArray[indexPath.row].email, userName: usersArray[indexPath.row].userName, imageUrl: usersArray[indexPath.row].avatarUrl!, isSelected: false)
			}
			return cell
		}
	
  }
	

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if numberOfSections(in: tableView) == 1 {
			let selectedUser = isFiltering() ? filteredUsersArray[indexPath.row] : usersArray[indexPath.row]
			selectedUsersArray.append(selectedUser)
			doneBtn.isEnabled = true
		} else {
			if indexPath.section == 0 {
				selectedUsersArray.remove(at: indexPath.row)
				if selectedUsersArray.count == 0 {
					doneBtn.isEnabled = false
				}
			} else {
				let selectedUser = isFiltering() ? filteredUsersArray[indexPath.row] : usersArray[indexPath.row]
				if !selectedUsersArray.contains(selectedUser) {
					selectedUsersArray.append(selectedUser)
				}
			}
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


