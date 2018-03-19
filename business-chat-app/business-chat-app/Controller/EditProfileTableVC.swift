//
//  EditProfileTableVC.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 19/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class EditProfileTableVC: UITableViewController, UITextFieldDelegate {
	
	
	@IBOutlet weak var profilePicture: UIImageView!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var userEmailLabel: UILabel!
	
	let currentEmail = Auth.auth().currentUser?.email
	let currentUserId = Auth.auth().currentUser?.uid
	var currentUserName = String()
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
		userEmailLabel.text = currentEmail
		Services.instance.getmyInfo(handler: { (myUserName) in
			self.usernameTextField.text = myUserName
		})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return section == 0 ? 1 : 2
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
