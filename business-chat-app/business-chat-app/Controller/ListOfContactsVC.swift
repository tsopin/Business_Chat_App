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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        Services.instance.REF_CHATS.observe(.value) { (snapshot) in
            Services.instance.getMyContacts { (returnedUsersArray) in
                self.contactsArray = returnedUsersArray
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
        guard let cell = contactsTableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? GroupCell else {return UITableViewCell()}
        
            let group = contactsArray[indexPath.row]
            let userName = group.chatName
            let numberOfMembers = group.memberCount
        
            cell.numberOfMembers.text = "\(numberOfMembers)"
            cell.groupName.text = userName
        
//        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let personalChatVC = storyboard?.instantiateViewController(withIdentifier: "personalChatVC") as? PersonalChatVC else {return}
        personalChatVC.initData(forChat: contactsArray[indexPath.row])
        present(personalChatVC, animated: true, completion: nil)
    }
    
}



