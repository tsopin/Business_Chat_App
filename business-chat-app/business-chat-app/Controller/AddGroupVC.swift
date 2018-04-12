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
  var chosenUsersArray = [String]()
  var filteredUsersArray = [User]()
  // var Array = [String]()
  
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
	navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
	navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = false
    
    self.hideKeyboardWhenTappedAround()
    tableView.delegate = self
    tableView.dataSource = self
	
	UserServices.instance.REF_USERS.observe(.value) { (snapshot) in
		UserServices.instance.getAllUsers{ (returnedUsersArray) in
			self.usersArray = returnedUsersArray
			print("loading users - \(self.usersArray.count)")
			self.tableView.reloadData()
		}
	}
	
	print("number of users after view did load \(usersArray.count)")
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


// MARK: -- TableView setup --

extension AddGroupVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
  

	func numberOfSections(in tableView: UITableView) -> Int {
		return selectedUsersArray.count > 0 ? 2 : 1
	  }
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if numberOfSections(in: tableView) > 1 {
			
			switch section {
			case 0:
				return isFiltering() ? filteredUsersArray.count : usersArray.count
			case 1:
				return selectedUsersArray.count
			default:
				return usersArray.count
			}
			
		} else {
			return 1
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return section == 0 ? "All contacts" : "Selected contacts"
	}
	
	
  	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if indexPath.section == 0 {
			
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "userForGroupCell") as? SearchUserForGroupCell else {return UITableViewCell() }
			cell.email.text = "text"
			cell.userName.text = "name"
			return cell
			
		} else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "userForGroupCell") as? SearchUserForGroupCell else {return UITableViewCell() }
			cell.configureCell(email: selectedUsersArray[indexPath.row].email, userName: selectedUsersArray[indexPath.row].userName, isSelected: true)
			return cell
		}
	
  }
	

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// guard let cell = tableView.cellForRow(at: indexPath) as? SearchUserForGroupCell else {return}
		
		let user = isFiltering() ? filteredUsersArray[indexPath.row] : usersArray[indexPath.row]
		
		if selectedUsersArray.contains(where: { (user) -> Bool in return true}) {
			
			let index = selectedUsersArray.index { (user) -> Bool in
				return true
			}
			selectedUsersArray.remove(at: index!)
			print(selectedUsersArray.count)
		} else {
			selectedUsersArray.append(user)
			print(selectedUsersArray.count)
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


