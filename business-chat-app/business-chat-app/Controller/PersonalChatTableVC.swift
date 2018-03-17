//
//  ChatTableViewController.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class PersonalChatTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    let customMessageIn = CustomMessageIn()
    let customMessageOut = CustomMessageOut()
    
    var messagesArray : [Message] = [Message]()
    let now = NSDate()
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatTableView.delegate = self
        chatTableView.dataSource = self
        textField.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        chatTableView.addGestureRecognizer(tapGesture)
        chatTableView.register(UINib(nibName: "CustomMessageIn", bundle: nil), forCellReuseIdentifier: "messageIn")
        chatTableView.register(UINib(nibName: "CustomMessageOut", bundle: nil), forCellReuseIdentifier: "messageOut")
        
        self.hideKeyboardWhenTappedAround()
        configureTableView()
        getMessages()
        chatTableView.separatorStyle = .none
        textInputView.bindToKeyboard()
 
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
//        UIView.animate(withDuration: 0.1) {
//
//            self.heightConstraint.constant = 325
//            self.view.layoutIfNeeded()
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        
        let outColor = UIColor(rgb: 0xe7b1c8)
        let inColor = UIColor(rgb: 0xb7d9fb)
        let sender = messagesArray[indexPath.row].userName
        let loggedUser = Auth.auth().currentUser?.email as String!
        
        
        if  sender == loggedUser {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageOut", for: indexPath) as! CustomMessageOut
            
            cell.messageBackground.backgroundColor = outColor
            cell.messageBody.text = messagesArray[indexPath.row].content
            cell.senderName.text = messagesArray[indexPath.row].userName
            cell.userPic.image = UIImage(named: "meIcon")
            cell.messageTime.text = messagesArray[indexPath.row].timeSent
            return cell
            
        } else {
            
              let cell = tableView.dequeueReusableCell(withIdentifier: "messageIn", for: indexPath) as! CustomMessageIn

            cell.messageBackground.backgroundColor = inColor
            cell.messageBody.text = messagesArray[indexPath.row].content
            cell.senderName.text = messagesArray[indexPath.row].userName
            cell.userPic.image = UIImage(named: "notMe")
            cell.messageTime.text = messagesArray[indexPath.row].timeSent
            return cell
            
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.2) {
            
            self.heightConstraint.constant = 60
            self.view.layoutIfNeeded()
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messagesArray.count
    }

    
    @IBAction func sendButton(_ sender: Any) {
        
        dateFormatter.dateFormat = "h:mm a"
        let currentDate = dateFormatter.string(from: now as Date)
        textField.endEditing(true)
        textField.isEnabled = false
        sendBtn.isEnabled = false
        
        if textField.text == "" {
            
            print("Message is Empty")
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
            
            let message = Message(content: content, timeSent: timeSent, senderName: userName, email: email)            
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
        
        print("Cell set")
    }

}







