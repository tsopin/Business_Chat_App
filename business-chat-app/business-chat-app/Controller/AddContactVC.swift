//
//  AddContactVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-10.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase


class AddContactVC: UIViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    @IBOutlet weak var tableView: UITableView!
    
let currentUser = (Auth.auth().currentUser?.uid)! 
    
    @IBAction func doneBtn(_ sender: Any) {
        

            DataServices.instance.getIds(forUsernames: chosenUserArray, handler: { (idsArray) in
                var userIds = idsArray
                userIds.append(self.currentUser)

                DataServices.instance.addContact(forUsersIds: userIds, handler: { (contactCreated) in

                    if contactCreated {
//                        self.dismiss(animated: true, completion: nil)

                    }else {
                        print("Contact Adding Error")
                    }
                })
            })

   
            
//            DataServices.instance.getIds(forUsernames: chosenUserArray, handler: { (idsArray) in
//                var userIds = idsArray
//                userIds.append((Auth.auth().currentUser?.uid)!)
//
//                DataServices.instance.createChat(withChatName: "self.titleTextfield.text!", forUsersIds: userIds, handler: { (chatCreated) in
//                    if chatCreated {
//                        self.dismiss(animated: true, completion: nil)
//
//                    }else {
//                        print("Group Creation Error")
//                    }
//                })
//            })
//
        
        
        
        
        
    }
    
    
//    @IBAction func closeBtn(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    
    var usersArray = [User]()
    var chosenUserArray = [String]()
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneButton.isEnabled = false
        
        DataServices.instance.REF_USERS.observe(.value) { (snapshot) in
            DataServices.instance.getAllUsers{ (returnedUsersArray) in
                self.usersArray = returnedUsersArray
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        print(currentUser)
    }
    

    
    
}

extension AddContactVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else {return UITableViewCell() }
        
//        let profileImage = UIImage(named: "notMe")
//        if chosenUserArray.contains(usersArray[indexPath.row]) {
//
//
//            cell.cronfigureCell(email: usersArray[indexPath.row], isSelected: true)
//        }else{
        let user = usersArray[indexPath.row]
        cell.cronfigureCell(email: user.email, userName: user.userName, isSelected: false)
            
//        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else {return}
        
        if !chosenUserArray.contains(cell.emailLabel.text!) {
            chosenUserArray.append(cell.emailLabel.text!)
            
            doneButton.isEnabled = true
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLabel.text! })
            if chosenUserArray.count >= 1 {
                
            } else {
       
                doneButton.isEnabled = false
            }
        }
        
        
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersArray.count
        
        
        
        
        
    }
    
}

extension AddContactVC: UITextFieldDelegate {
    
}
