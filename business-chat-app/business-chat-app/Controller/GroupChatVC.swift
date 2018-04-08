//
//  GroupChatVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-17.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class GroupChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
  
  @IBOutlet var mainView: UIView!
  @IBOutlet weak var textInputView: UIView!
  @IBOutlet weak var chatTableView: UITableView!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var sendBtn: UIButton!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  
  let customMessageIn = CustomMessageIn()
  let customMessageOut = CustomMessageOut()
  
  let colours = Colours()
  
  let dateFormatter = DateFormatter()
  let now = NSDate()
  var chat: Chat?
  var chatMessages = [Message]()
  
  func initData(forChat chat: Chat){
    self.chat = chat
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
//    MessageServices.instance.REF_MESSAGES.observe(.value) { (snapshot) in
//      MessageServices.instance.getAllMessagesFor(desiredChat: self.chat!, handler: { (returnedChatMessages) in
//        self.chatMessages = returnedChatMessages
//        self.chatTableView.reloadData()
//
//        if self.chatMessages.count > 0 {
//          self.chatTableView.scrollToRow(at: IndexPath(row: self.chatMessages.count - 1, section: 0) , at: .none, animated: true)
//        }
//      })
//    }
    
    // Check chat name and set title (in case it was changed)
    ChatServices.instance.REF_CHATS.child((chat?.key)!).observeSingleEvent(of: .value) { (snapshot) in
      let value = snapshot.value as? NSDictionary
      let chatName = value!["chatName"] as? String ?? ""
      self.title = chatName
    }
  }
  
  
  func getMessages() {
    MessageServices.instance.REF_MESSAGES.child((self.chat?.key)!).observe(.childAdded) { (snapshot) in
      MessageServices.instance.getAllMessagesFor(desiredChat: self.chat!, handler: { (returnedChatMessages) in
        self.chatMessages = returnedChatMessages
        self.configureTableView()
        self.chatTableView.reloadData()
        
        self.scrollToBottom()
        
      })
    }
  }
  
  func scrollToBottom() {
    if self.chatMessages.count - 1 <= 0 {
      return
    }
    let indexPath = IndexPath(item: self.chatMessages.count - 1, section: 0)
    DispatchQueue.main.async {
      self.chatTableView?.scrollToRow(at: indexPath, at: .top, animated: true)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector:#selector(GroupChatVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector:#selector(GroupChatVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    chatTableView.delegate = self
    chatTableView.dataSource = self
    textField.delegate = self
    
    chatTableView.register(UINib(nibName: "CustomMessageIn", bundle: nil), forCellReuseIdentifier: "messageIn")
    chatTableView.register(UINib(nibName: "CustomMessageOut", bundle: nil), forCellReuseIdentifier: "messageOut")
    
    self.hideKeyboardWhenTappedAround()
    configureTableView()
    getMessages()
    chatTableView.separatorStyle = .none
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
    
    let sender = chatMessages[indexPath.row].senderId
    
    if  sender == currentUserId {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "messageOut", for: indexPath) as! CustomMessageOut
      
      let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
      
      cell.configeureCell(senderName: currentEmail!, messageTime: date!, messageBody: chatMessages[indexPath.row].content, messageBackground: colours.colourMainBlue)
      //            cell.userPic.image = UIImage(named: "meIcon")
      return cell
      
    } else {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "messageIn", for: indexPath) as! CustomMessageIn
      
      let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
      
      cell.configeureCell(senderName: chatMessages[indexPath.row].senderId, messageTime: date!, messageBody: chatMessages[indexPath.row].content, messageBackground: colours.colourMainPurple)
      
      return cell
      
    }
  }
  
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    UIView.animate(withDuration: 0.2) {
      
      self.heightConstraint.constant = 60
      self.view.layoutIfNeeded()
      
    }
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chatMessages.count
  }
  
  
  @IBAction func sendButton(_ sender: Any) {
    
    let date = Date()
    let currentDate = date.timeIntervalSince1970
    let messageUID = ("\(currentDate)" + currentUserId!).replacingOccurrences(of: ".", with: "")
    if textField.text != "" {
      sendBtn.isEnabled = false
      MessageServices.instance.sendMessage(withContent: textField.text!, withTimeSent: "\(currentDate)", withMessageId: messageUID, forSender: currentUserId! , withChatId: chat?.key, isMultimedia: false, sendComplete: { (complete) in
        if complete {
          self.textField.isEnabled = true
          self.sendBtn.isEnabled = true
          self.textField.text = ""
          print("Group Message saved")
        }
      })
    }
  }
  
  @objc func tableViewTapped() {
    chatTableView.endEditing(true)
  }
  
  
  func configureTableView() {
    chatTableView.rowHeight = UITableViewAutomaticDimension
    chatTableView.estimatedRowHeight = 120.0
  }
  
  @objc func keyboardWillShow(notification : NSNotification) {
    
    let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
    
    self.heightConstraint.constant = keyboardSize.height + 60
    UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
      
    })
  }
  
  @objc func keyboardWillHide(notification : NSNotification) {
    self.heightConstraint.constant = 0
    
  }
  
  // MARK: -- Navigation --
  
  deinit{
    
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showGroupInfo" {
      let groupInfoVC = segue.destination as! GroupInfoVC
      groupInfoVC.initData(forChat: chat!)
    }
  }
  
  
  
  
}

