//
//  GroupChatVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-17.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

//class GroupChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
//
//    @IBOutlet var mainView: UIView!
//    @IBOutlet weak var textInputView: UIView!
//    @IBOutlet weak var chatTableView: UITableView!
//    @IBOutlet weak var textField: UITextField!
//    @IBOutlet weak var sendBtn: UIButton!
//    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var contactNameLabel: UILabel!
//
//    let customMessageIn = CustomMessageIn()
//    let customMessageOut = CustomMessageOut()
//
//    let dateFormatter = DateFormatter()
//    let now = NSDate()
//
//    var chat: Chat?
//    var chatMessages = [Message]()
//    func initData(forChat chat: Chat){
//        self.chat = chat
//
//    }
//
//    //
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        contactNameLabel.text = chat?.chatName
//
//        //        Services.instance.getEmailsFor(chat: group!) { (returnedEmails) in
//        //            self.membersLbl.text = returnedEmails.joined(separator: ", ")
//        //
//        //        }
//        Services.instance.REF_CHATS.observe(.value) { (snapshot) in
//            Services.instance.getAllMessagesFor(desiredChat: self.chat!, handler: { (returnedChatMessages) in
//                self.chatMessages = returnedChatMessages
//                self.chatTableView.reloadData()
//
//                if self.chatMessages.count > 0 {
//                    self.chatTableView.scrollToRow(at: IndexPath(row: self.chatMessages.count - 1, section: 0) , at: .none, animated: true)
//                }
//            })
//        }
//
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        chatTableView.delegate = self
//        chatTableView.dataSource = self
//        textField.delegate = self
//
//        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//        //        chatTableView.addGestureRecognizer(tapGesture)
//        chatTableView.register(UINib(nibName: "CustomMessageIn", bundle: nil), forCellReuseIdentifier: "messageIn")
//        chatTableView.register(UINib(nibName: "CustomMessageOut", bundle: nil), forCellReuseIdentifier: "messageOut")
//
//        self.hideKeyboardWhenTappedAround()
//        configureTableView()
//        chatTableView.separatorStyle = .none
//        mainView.bindToKeyboard()
//
//
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//
//        //        UIView.animate(withDuration: 0.1) {
//        //
//        //            self.heightConstraint.constant = 325
//        //            self.view.layoutIfNeeded()
//        //        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
//
//        let outColor = UIColor(rgb: 0xe7b1c8)
//        let inColor = UIColor(rgb: 0xb7d9fb)
//        let sender = chatMessages[indexPath.row].senderId
//
//
//
//        if  sender == currentUserId {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "messageOut", for: indexPath) as! CustomMessageOut
//
//            cell.configeureCell(senderName: chatMessages[indexPath.row].senderId, messageTime: chatMessages[indexPath.row].timeSent, messageBody: chatMessages[indexPath.row].content, messageBackground: outColor)
//
//            //            cell.messageBackground.backgroundColor = outColor
//            //            cell.messageBody.text = messagesArray[indexPath.row].content
//            //            cell.senderName.text = messagesArray[indexPath.row].senderId
//            cell.userPic.image = UIImage(named: "meIcon")
//            //            cell.messageTime.text = messagesArray[indexPath.row].timeSent
//            return cell
//
//        } else {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "messageIn", for: indexPath) as! CustomMessageIn
//
//            cell.configeureCell(senderName: chatMessages[indexPath.row].senderId, messageTime: chatMessages[indexPath.row].timeSent, messageBody: chatMessages[indexPath.row].content, messageBackground: inColor)
//
//            //            cell.messageBackground.backgroundColor = inColor
//            //            cell.messageBody.text = messagesArray[indexPath.row].content
//            //            cell.senderName.text = messagesArray[indexPath.row].senderId
//            cell.userPic.image = UIImage(named: "notMe")
//            //            cell.messageTime.text = messagesArray[indexPath.row].timeSent
//            return cell
//
//        }
//    }
//
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        UIView.animate(withDuration: 0.2) {
//
//            self.heightConstraint.constant = 60
//            self.view.layoutIfNeeded()
//
//        }
//    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return chatMessages.count
//    }
//
//    @IBAction func backBtn(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    @IBAction func sendButton(_ sender: Any) {
//
//        dateFormatter.dateFormat = "MMM d, h:mm a"
//        let currentDate = dateFormatter.string(from: now as Date)
//
//        if textField.text != "" {
//            sendBtn.isEnabled = false
//            Services.instance.sendMessage(withContent: textField.text!, withTimeSent: currentDate, forSender: currentUserId! , withChatId: chat?.key, sendComplete: { (complete) in
//                if complete {
//                    self.textField.isEnabled = true
//                    self.sendBtn.isEnabled = true
//                    self.textField.text = ""
//                    print("Message saved")
//                }
//            })
//
//        }
//
//    }
//
//
//    //RetrieveMessages method
//    //    func getMessages() {
//    //
//    //        let messageDB = Database.database().reference().child("messages_Test")
//    //        messageDB.observe(.childAdded) { (snapshot) in
//    //
//    //            let snapshotValue = snapshot.value as! Dictionary<String,String>
//    //
//    //            let content = snapshotValue["content"]!
//    //            let timeSent = snapshotValue["timeSent"]!
//    //            let senderId = snapshotValue["senderId"]!
//    //
//    //            let message = Message(content: content, timeSent: timeSent, senderId: senderId)
//    //            self.messagesArray.append(message)
//    //            self.configureTableView()
//    //            self.chatTableView.reloadData()
//    //        }
//    //    }
//
//
//    @objc func tableViewTapped() {
//        chatTableView.endEditing(true)
//    }
//
//    func configureTableView() {
//        chatTableView.rowHeight = UITableViewAutomaticDimension
//        chatTableView.estimatedRowHeight = 120.0
//
//        //        print("Cell set")
//    }
//
//}

