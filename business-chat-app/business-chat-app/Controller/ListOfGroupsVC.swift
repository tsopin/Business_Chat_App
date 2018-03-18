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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Services.instance.REF_CHATS.observe(.value) { (snapshot) in
            Services.instance.getMyGroups { (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                self.groupsTableView.reloadData()
            }
            
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupChatVC = storyboard?.instantiateViewController(withIdentifier: "groupChatVC") as? GroupChatVC else {return}
        groupChatVC.initData(forChat: groupsArray[indexPath.row])
        present(groupChatVC, animated: true, completion: nil)
    }
    
    
}