//
//  UserProfileVC.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 21/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class UserProfileVC: UITableViewController {
	
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var userEmailLabel: UILabel!
	
	var chatName = ""
	var userId = ""
	
	override func viewWillAppear(_ animated: Bool) {
		
		// get user by chatName (if from Chat) or by userId if from Group
		if chatName != "" {
			Services.instance.getUserName(byUserId: chatName) { (username) in
				self.title = username
				self.usernameLabel.text = username
			}

			Services.instance.getUserEmail(byUserId: chatName) { (email) in
				self.userEmailLabel.text = email
			}
		} else {
			Services.instance.getUserName(byUserId: userId) { (username) in
				self.title = username
				self.usernameLabel.text = username
			}
			Services.instance.getUserEmail(byUserId: userId) { (email) in
				self.userEmailLabel.text = email
			}
		}
		
		
		
	}

	
    override func viewDidLoad() {
        super.viewDidLoad()
		// make rounded profile image
		profileImageView.layer.masksToBounds = true
		profileImageView.layer.cornerRadius = 60
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	

    // MARK: - Table view methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return section == 0 ? 1 : 2
    }

	

}
