//
//  ListOfGroupsVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class ListOfGroupsVC: UIViewController {
    

    @IBOutlet weak var groupsTableView: UITableView!
    
    var groupsArray = [Chat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        offlineMode()
        ChatServices.instance.REF_CHATS.observe(.value) { (snapshot) in
            ChatServices.instance.getMyGroups { (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                self.groupsTableView.reloadData()
            }
        }
    }
    
    deinit{
        
    }
}

extension ListOfGroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupsTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell else {return UITableViewCell()}
        
        let group = groupsArray[indexPath.row]
        
        cell.configeureCell(groupName: group.chatName, numberOfMembers: group.memberCount )
        
        return cell
    }
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showGroupChat" {
			let indexPath = groupsTableView.indexPathForSelectedRow
			guard let groupChatVC = segue.destination as? GroupChatVC else {return}
			groupChatVC.initData(forChat: groupsArray[(indexPath?.row)!])
		}
	}
	
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    if editing{
      self.groupsTableView.setEditing(true, animated: animated)
    } else {
      self.groupsTableView.setEditing(false, animated: animated)
    }
  }
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //    method for chats deleting
  }
   
  func offlineMode() {
    let colors = Colours()
    let network = Services.instance.myStatus()
    let nav = self.navigationController?.navigationBar
    
    if network == false {
      nav?.barTintColor = colors.colourMainPurple
      self.navigationItem.title = "Groups - Offline"
    } else {
      nav?.barTintColor = UIColor.white
      self.navigationItem.title = "Groups"
    }
    
  }
    
}

