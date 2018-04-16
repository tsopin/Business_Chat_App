//
//  ListOfContactsTableVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-09.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ListOfContactsVC: UIViewController {
  
  @IBOutlet weak var contactsTableView: UITableView!
  
  var refreshControl: UIRefreshControl!
  var contactsArray = [Chat]()
  var choosenContactArray =  [String]()
  var chatMessages = [Message]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contactsTableView.delegate = self
    contactsTableView.dataSource = self
    navigationItem.leftBarButtonItem = editButtonItem
    refreshControl = UIRefreshControl()
    contactsTableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refreshPull), for: UIControlEvents.valueChanged)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    offlineMode()
    downloadMessages()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  @objc func refreshPull() {
    DispatchQueue.main.async {
      
      self.refreshControl.endRefreshing()
      self.downloadMessages()
    }
  }
  
  func downloadMessages(){

    UserServices.instance.REF_USERS.child(currentUserId!).child("activePersonalChats").observe( .childAdded) { (df) in
      ChatServices.instance.getMyChatsIds(isGroup: false) { (ids) in
        ChatServices.instance.getMyChats(forIds: ids, handler: { (returnedChats) in
          self.contactsArray = returnedChats
//            .sorted { $0.lastMessage > $1.lastMessage }
//          DispatchQueue.main.async {
            self.contactsTableView.reloadData()
//          }
        })
      }
    }
    
    UserServices.instance.REF_USERS.child(currentUserId!).child("activerPersonalChats").observe(.childRemoved) { (snapshot) in
      DispatchQueue.main.async {
        self.contactsTableView.reloadData()
      }
    }
  }
}

extension ListOfContactsVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contactsArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = contactsTableView.dequeueReusableCell(withIdentifier: "personalChatCell", for: indexPath) as? PersonalChatCell else {return UITableViewCell()}
    
    let contact = contactsArray[indexPath.row]
    let lastMessage = contactsArray[indexPath.row].lastMessage
    var date = String()

   


    UserServices.instance.getUserData(byUserId: contact.chatName) { (userData) in
    ChatServices.instance.REF_CHATS.child(contact.key).child("lastMessage").observe(.value) { (popo) in
      
      guard let last = popo.value as? String else {return}
       date = self.getDateFromInterval(timestamp: Double(last))!
    
   
      
      var statusImage = UIImage()
      let contactEmail = userData.0
      let contactName = userData.1
      let imageUrl = userData.3
      let contactStatus = userData.2
      
      switch contactStatus {
      case "online":
        statusImage = UIImage(named: "status_online")!
      case "dnd":
        statusImage = UIImage(named: "status_dnd")!
      case "away":
        statusImage = UIImage(named: "status_away")!
      default:
        statusImage = UIImage(named: "status_offline")!
      }
      cell.configeureCell(contactName: contactName, contactEmail: contactEmail, lastMessage: date, statusImage: statusImage, imageUrl: imageUrl)
    }
    }
    return cell
  }
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    if editing{
      self.contactsTableView.setEditing(true, animated: animated)
    } else {
      self.contactsTableView.setEditing(false, animated: animated)
    }
  }
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //    method for chats deleting
    
    ChatServices.instance.deleteChatFromUser(isGroup: false, chatId: contactsArray[indexPath.row].key)
    contactsArray.remove(at: indexPath.row)
    contactsTableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
  // TODO:  Extra actions on Trailing Swipe
  // Show user profile from List of contacts
  //  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
  ////    let info = UIContextualAction(style: UIContextualAction.Style.normal, title: "User Info") { (action, view, _) in
  ////      print("ShowUserInfo")
  ////
  ////    }
  //    let delete = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Delete Chat") { (action, view, success) in
  //
  //      ChatServices.instance.deleteChatFromUser(isGroup: false, chatId: self.contactsArray[indexPath.row].key)
  //      self.contactsArray.remove(at: indexPath.row)
  //      self.contactsTableView.deleteRows(at: [indexPath], with: .fade )
  //      success(true)
  //      print("Delete")
  //    }
  //    let config = UISwipeActionsConfiguration(actions: [delete])
  //    config.performsFirstActionWithFullSwipe = true
  //    return config
  //  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showPersonalChat" {
      let indexPath = contactsTableView.indexPathForSelectedRow
      guard let personalChatVC = segue.destination as? PersonalChatVC else {return}
      personalChatVC.initData(forChat: contactsArray[(indexPath?.row)!])
    }
  }
  
  func offlineMode() {
    let colors = Colours()
    let network = Services.instance.myStatus()
    let nav = self.navigationController?.navigationBar
    
    if network == false {
      nav?.barTintColor = colors.colourMainPurple
      self.navigationItem.title = "Chats - Offline Mode"
    } else {
      nav?.barTintColor = UIColor.white
      self.navigationItem.title = "Chats"
    }
    
  }
  
}



