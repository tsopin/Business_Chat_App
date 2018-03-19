//
//  SettingsTableTableViewController.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 18/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableTableViewController: UITableViewController {
	
	
	@IBOutlet weak var userNameTextField: UILabel!
	@IBOutlet weak var emailTextField: UILabel!
	
	
	
	let currentUserId = Auth.auth().currentUser?.uid
	let currentEmail = Auth.auth().currentUser?.email
	var currentUserName = String()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.hideKeyboardWhenTappedAround()
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		emailTextField.text = currentEmail
		Services.instance.getmyInfo(handler: { (myName) in
			self.userNameTextField.text = myName
		})
	}
	
	
	
	
	// Log out
	
	@IBAction func logOutBtn(_ sender: Any) {
		
		let actionSheets = UIAlertController(title: "Log Out", message: "Are you sure you want to logout?" , preferredStyle: .actionSheet)
		
		let action1 = UIAlertAction(title: "Log Out", style: .destructive , handler: {
			(alert: UIAlertAction!) -> Void in
			
			do {
				try Auth.auth().signOut()
				print("LogOut")
				self.dismiss(animated: true, completion: nil)
			}
			catch {
				print("Error")
			}
			
		} )
		let cancel = UIAlertAction(title: "Cancel ", style: .cancel, handler: {
			(alert: UIAlertAction!) -> Void in
			
		} )
		
		actionSheets.addAction(action1)
		actionSheets.addAction(cancel)
		self.present(actionSheets, animated: true, completion: nil)
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
