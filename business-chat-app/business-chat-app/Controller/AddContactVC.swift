//
//  AddContactVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-10.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase


class AddContactVC: UIViewController, UISearchResultsUpdating {
	
  
  @IBOutlet weak var doneButton: UIBarButtonItem!
  
  
  @IBOutlet weak var tableView: UITableView!
  
  let currentUserId = (Auth.auth().currentUser?.uid)!
  let currentUserEmail = (Auth.auth().currentUser?.email)!
  var usersArray = [User]()
  var filteredUsersArray = [User]()
  var chosenUserArray = [String]()
  var chatsArray = [String]()
  let dataServices = Services()
	
  let searchController = UISearchController(searchResultsController: nil)
  
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
	

	func createChat() {
		
		UserServices.instance.getUsersIds(forUsernames: chosenUserArray, handler: { (idsArray) in
			let userIds = idsArray
			UserServices.instance.addContact(forUsersIds: userIds, handler: { (contactCreated) in
				if contactCreated {
					// self.presentStoryboard()
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
		//self.presentStoryboard()
		self.navigationController?.popToRootViewController(animated: true)
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
	print("total users: \(usersArray.count)")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
	
	// Set up the Search Controller
	searchController.searchResultsUpdater = self
	searchController.obscuresBackgroundDuringPresentation = false
	searchController.searchBar.placeholder = "Find contact and select"
	navigationItem.searchController = searchController
	navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
	navigationItem.hidesSearchBarWhenScrolling = false
	definesPresentationContext = true
	
    tableView.delegate = self
    tableView.dataSource = self
    hideKeyboardWhenTappedAround()
  }
  deinit{
    
  }

	// MARK: -- Search --
	
	func updateSearchResults(for searchController: UISearchController) {
		// filterContentForSearchText(searchController.searchBar.text!)
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


extension AddContactVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? SearchUserForContactCell else {return UITableViewCell() }
    
		let user = isFiltering() ? filteredUsersArray[indexPath.row] : usersArray[indexPath.row]
	cell.configureCell(email: user.email, userName: user.userName, imageUrl: user.avatarUrl!, isSelected: false)
		return cell
  }
  

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? SearchUserForContactCell else {return}
		chosenUserArray.append(cell.emailLabel.text!)
		createChat()
	}
	
	
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	if isFiltering() {
		return filteredUsersArray.count
	} else {
    	return usersArray.count
	}
  }
}

extension AddContactVC: UITextFieldDelegate {
  
}

