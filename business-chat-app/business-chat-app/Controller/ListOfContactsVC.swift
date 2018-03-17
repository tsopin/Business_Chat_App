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
    
    
    var contactsArray = [Group]()
    var choosenContactArray =  [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        DataServices.instance.REF_CHATS.observe(.value) { (snapshot) in
            DataServices.instance.getMyContacts { (returnedUsersArray) in
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
            let userName = group.groupName
            let numberOfMembers = group.memberCount
        
        
        
            cell.numberOfMembers.text = "\(numberOfMembers)"
            cell.groupName.text = userName
        
        
        return cell
    }
    
    
}



