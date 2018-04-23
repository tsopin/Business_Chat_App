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

  var allUsersArray = [User]()

  var refreshControl: UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    groupsTableView.delegate = self
    groupsTableView.dataSource = self
    refreshControl = UIRefreshControl()
    groupsTableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refreshPull), for: UIControlEvents.valueChanged)
    navigationItem.leftBarButtonItem = editButtonItem
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.popToRootViewController(animated: true)
    offlineMode()
    getChatList()

  }
  
  @objc func refreshPull() {
    DispatchQueue.main.async {
      
      self.refreshControl.endRefreshing()
      self.getChatList()
    }
  }
  
  func getChatList(){
    
    UserServices.instance.REF_USERS.child(currentUserId!).child("activeGroupChats").observe( .childAdded) { (df) in
      ChatServices.instance.getMyChatsIds(isGroup: true) { (ids) in
        ChatServices.instance.getMyChats(forIds: ids, handler: { (returnedChats) in
          self.groupsArray = returnedChats.sorted { $0.lastMessage > $1.lastMessage }
//          DispatchQueue.main.async {
            self.groupsTableView.reloadData()
//          }
        })
      }
    }
    
    UserServices.instance.REF_USERS.child(currentUserId!).child("activerPersonalChats").observe(.childRemoved) { (snapshot) in
      DispatchQueue.main.async {
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
		groupChatVC.title = groupsArray[(indexPath?.row)!].chatName
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
    ChatServices.instance.deleteChatFromUser(isGroup: true, chatId: groupsArray[indexPath.row].key)
    groupsArray.remove(at: indexPath.row)
    groupsTableView.deleteRows(at: [indexPath], with: .automatic)
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

