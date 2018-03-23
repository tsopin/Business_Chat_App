//
//  ListOfContactsTableVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-09.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase


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
        
        Services.instance.REF_CHATS.observe(.value) { (snapshot) in
            Services.instance.getMyContacts { (returnedUsersArray) in
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
        Services.instance.getAllMessagesFor(desiredChat: contactsArray[indexPath.row]) { (returnedMessage) in
            
            let amount = returnedMessage.count - 1
            
            
            
            var date = String()
            
            var dateToGo = String()
            
            if returnedMessage.indices.contains(amount) {
                
                dateToGo = returnedMessage[amount].timeSent
                date = self.getDateFromInterval(timestamp: Double(dateToGo))!
                
            } else {
                
                date = "No messages yet"
            }
            
//            Services.instance.getUserImage(byUserId: contact.chatName, handler: { (returnedImage) in
                Services.instance.getUserName(byUserId: contact.chatName) { (userName) in
                    Services.instance.getUserEmail(byUserId: contact.chatName) { (userEmail) in
                        Services.instance.getUserStatus(byUserId: contact.chatName) { (userStatus) in
                            
                            var statusImage = UIImage()
                            
                            if userStatus == "online" {
                                statusImage = UIImage(named: "status_online")!
                            }
                            else if userStatus == "offline" {
                                statusImage = UIImage(named: "status_offline")!
                            }
                            else if userStatus == "dnd" {
                                statusImage = UIImage(named: "status_dnd")!
                            }
                            else if userStatus == "away" {
                                statusImage = UIImage(named: "status_away")!
                            }
                            
                            
                            cell.configeureCell(contactName: userName, contactEmail: userEmail, lastMessage: date, statusImage: statusImage)
                        }
                    }
                }
//            })
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



