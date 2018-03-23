//
//  GroupInfoVC.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 22/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class GroupInfoVC: UIViewController, UITextFieldDelegate {
	

	
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit{
        
    }

}


// MARK: -- TableView implementation --
extension GroupInfoVC: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return section == 0 ? "Group name" : "Group members"
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? 1 : 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "groupNameCell") as! GroupNameCell
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "groupMemberCell") as! GroupMemberCell
			cell.configureCell(username: "Johnny", userEmail: "test@a.com", userPic: UIImage(named: "userpic_placeholder_small")!)
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return indexPath.section == 0 ? 44 : 70
	}
    
	
}

