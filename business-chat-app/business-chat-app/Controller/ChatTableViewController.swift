//
//  ChatTableViewController.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class ChatTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    
    var messagesArray : [Message] = [Message]()
    let now = NSDate()
    let dateFormatter = DateFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Delegate and datasource
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        
        //Delegate of the text field
        
        textField.delegate = self
        
        //Set the tapGesture
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        
        chatTableView.addGestureRecognizer(tapGesture)
        
        chatTableView.register(UINib(nibName: "CustomMessageIn", bundle: nil), forCellReuseIdentifier: "customMessageIn")
        
        configureTableView()
        getMessages()
        chatTableView.separatorStyle = .none
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        UIView.animate(withDuration: 1) {
            
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageIn", for: indexPath) as! CustomMessageIn
        
        cell.messageBody.text = messagesArray[indexPath.row].content
        cell.senderName.text = messagesArray[indexPath.row].userName
        cell.userPic.image = UIImage(named: "userPic")
        cell.messageTime.text = messagesArray[indexPath.row].timeSent
        
//        if cell.senderName.text == Auth.auth().currentUser?.email as String! {
//            cell.userPic.backgroundColor = UIColor.blue
//            cell.messageBackground.backgroundColor = UIColor.blue
//        } else {
//            cell.userPic.backgroundColor = UIColor.brown
//            cell.messageBackground.backgroundColor = UIColor.red
//        }
        
        return cell
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messagesArray.count
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let currentDate = dateFormatter.string(from: now as Date)
        
        textField.endEditing(true)
        
        
        textField.isEnabled = false
        sendBtn.isEnabled = false
        
        if textField.text == "" {
            
            print("Empty Message")
            self.textField.isEnabled = true
            self.sendBtn.isEnabled = true
            
            
        } else {
        
        let messageDB = Database.database().reference().child("messages")
        let messageDictionary = ["email": Auth.auth().currentUser?.email, "content": textField.text!, "timeSent" : currentDate, "userName": Auth.auth().currentUser?.email]
        
        messageDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                print("Message saved")
                
                self.textField.isEnabled = true
                self.sendBtn.isEnabled = true
                self.textField.text = ""
            }
        }
        }
       
    }
    
    
     //RetrieveMessages method
    func getMessages() {
        
        let messageDB = Database.database().reference().child("messages")
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let content = snapshotValue["content"]!
            let email = snapshotValue["email"]!
            let timeSent = snapshotValue["timeSent"]!
            let userName = snapshotValue["userName"]!
            
            let message = Message()
            message.content = content
            message.email = email
            message.timeSent = timeSent
            message.userName = userName
            
            self.messagesArray.append(message)
            self.configureTableView()
            self.chatTableView.reloadData()
        }
        
    }
    
    @objc func tableViewTapped() {
        chatTableView.endEditing(true)
    }
    func configureTableView() {
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 120.0
    }
    
}
