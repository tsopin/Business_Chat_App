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
    
    
    var contactsArray = [Chat]()
    var choosenContactArray =  [String]()
    var chatMessages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        
        ChatServices.instance.REF_CHATS.observe(.value) { (snapshot) in
            ChatServices.instance.getMyPersonalChats { (returnedUsersArray) in
                self.contactsArray = returnedUsersArray
                                DispatchQueue.main.async {
                self.contactsTableView.reloadData()
                                }
            
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
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
        MessageServices.instance.getAllMessagesFor(desiredChat: contactsArray[indexPath.row]) { (returnedMessage) in
            
            let amount = returnedMessage.count - 1

            var date = String()
            
            var dateToGo = String()
            
            if returnedMessage.indices.contains(amount) {
                
                dateToGo = returnedMessage[amount].timeSent
                date = self.getDateFromInterval(timestamp: Double(dateToGo))!
                
            } else {
                
                date = "No messages yet"
            }
            
            UserServices.instance.getUserData(byUserId: contact.chatName) { (userData) in
                
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
              default:
                statusImage = UIImage(named: "status_offline")!
              }
              
              cell.configeureCell(contactName: contactName, contactEmail: contactEmail, lastMessage: date, statusImage: statusImage, imageUrl: imageUrl)
            }
            
        }
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPersonalChat" {
            let indexPath = contactsTableView.indexPathForSelectedRow
            guard let personalChatVC = segue.destination as? PersonalChatVC else {return}
            personalChatVC.initData(forChat: contactsArray[(indexPath?.row)!])
        }
    }
}



