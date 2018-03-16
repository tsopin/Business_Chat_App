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



//class ListOfContactsTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
//
//
//    @IBOutlet var contactListTableView: UITableView!
//
//    var contactsArray : [Contact] = [Contact]()
//    var idArray : [String] = [""]
//
//
//    override func viewDidLoad() {
//        contactListTableView.register(UINib(nibName: "CustomContactCell", bundle: nil), forCellReuseIdentifier: "CustomContactCell")
//
//        contactListTableView.separatorStyle = .none
//
//        contactListTableView.delegate = self
//        contactListTableView.dataSource = self
//        configureTableView()
//        super.viewDidLoad()
//        getUser()
//        print("OLOLO \(idArray[0])")
//
//
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    //     func numberOfSections(in tableView: UITableView) -> Int {
//    //        // #warning Incomplete implementation, return the number of sections
//    //        return 1
//    //    }
//
//
//
//
//
//    //    func getUserId() {
//    //
//    //
//    //
//    //        let userDB = Database.database().reference().child("users")
//    //
//    //
//    //        userDB.observeSingleEvent(of: .value, with: { (snapshot) in
//    //
//    //            for snap in snapshot.children {
//    //                let snapshot = snap as! DataSnapshot
//    //                let uid = snapshot.key //the uid of each user
//    //                print(uid)
//    //
//    //            }
//    //
//    //        })
//    //
//    //    }
//
//    func getUser() {
//
//
//        let userDB = Database.database().reference().child("users")
//        userDB.observe(.childAdded) { (snapshot) in
//
//            let snapshotValue = snapshot.value as! [String : AnyObject]
//
//            let userName = snapshotValue["username"]!
//            let email = snapshotValue["email"]!
//
//            let contact = Contact()
//
//            contact.userName = userName as! String
//            contact.email = email as! String
//
//
//            self.contactsArray.append(contact)
//
//            for element in self.contactsArray {
//                print(element.userName, element.email)
//            }
//
//            //            print(self.contactsArray[IndexPath].userName)
//            self.contactListTableView.reloadData()
//        }
//    }
//
//
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//            performSegue(withIdentifier: "goToChat", sender: self)
//
//
//        }
//
//
//
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
//
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomContactCell", for: indexPath) as! CustomContactCell
//
//            cell.userName.text = contactsArray[indexPath.row].userName
//            cell.userEmail.text = contactsArray[indexPath.row].email
//            cell.userPic.image = UIImage(named: "notMe")
//
//            return cell
//        }
//
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            // #warning Incomplete implementation, return the number of rows
//            return contactsArray.count
//        }
//
//        /*
//         // Override to support conditional editing of the table view.
//         override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//         // Return false if you do not want the specified item to be editable.
//         return true
//         }
//         */
//
//        /*
//         // Override to support editing the table view.
//         override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//         if editingStyle == .delete {
//         // Delete the row from the data source
//         tableView.deleteRows(at: [indexPath], with: .fade)
//         } else if editingStyle == .insert {
//         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//         }
//         }
//         */
//
//        /*
//         // Override to support rearranging the table view.
//         override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//         }
//         */
//
//        /*
//         // Override to support conditional rearranging of the table view.
//         override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//         // Return false if you do not want the item to be re-orderable.
//         return true
//         }
//         */
//
//        /*
//         // MARK: - Navigation
//
//         // In a storyboard-based application, you will often want to do a little preparation before navigation
//         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         // Get the new view controller using segue.destinationViewController.
//         // Pass the selected object to the new view controller.
//         }
//         */
//        func configureTableView() {
//            contactListTableView.rowHeight = UITableViewAutomaticDimension
//            contactListTableView.estimatedRowHeight = 120.0
//
//            print("Cell set")
//        }
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let chatVC = segue.destination as? PersonalChatTableVC {
//            let barBtn = UIBarButtonItem()
//            barBtn.title = ""
//            navigationItem.backBarButtonItem = barBtn
//        }
//    }
//
//
//        @IBAction func addContactButton(_ sender: Any) {
//        }
//
//}


