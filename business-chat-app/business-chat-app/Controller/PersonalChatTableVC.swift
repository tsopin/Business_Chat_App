//
//  PersonalChatVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SimpleImageViewer


class PersonalChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  
  @IBOutlet weak var contactNameLabel: UILabel!
  @IBOutlet weak var lastSeenTime: UILabel!
  @IBOutlet weak var lastSeenLabel: UILabel!
  @IBOutlet weak var tabPhoto: UIImageView!
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var textInputView: UIView!
  @IBOutlet weak var chatTableView: UITableView!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var sendBtn: UIButton!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  //    @IBOutlet weak var contactNameLabel: UILabel!
  let imagePickerContorller = UIImagePickerController()
  let colours = Colours()
  
  let customMessageIn = CustomMessageIn()
  let customMessageOut = CustomMessageOut()
  
  let dateFormatter = DateFormatter()
  let now = NSDate()
  var chat: Chat?
  var chatMessages = [Message]()
  
  func initData(forChat chat: Chat){
    self.chat = chat
    
  }
  
  //
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UserServices.instance.getUserData(byUserId: (chat?.chatName)!) { (userData) in
      
      let tabImage = userData.3
      let tabName = userData.1
      let lastSeen = userData.4
      let status = userData.2
      
      switch status {
        
      case "online":
        self.lastSeenLabel.pushTransition(0.3)
        self.lastSeenLabel.text = "Online"
        self.lastSeenTime.isHidden = true
      case "away":
        self.lastSeenLabel.pushTransition(0.3)
        self.lastSeenLabel.text = "Away"
        self.lastSeenTime.isHidden = true
      case "dnd":
        self.lastSeenLabel.pushTransition(0.3)
        self.lastSeenLabel.text = "Do Not Disturb"
        self.lastSeenTime.isHidden = true
      default:
        let date = self.getDateFromInterval(timestamp: Double(lastSeen))
        self.lastSeenLabel.pushTransition(0.3)
        self.lastSeenTime.pushTransition(0.3)
        self.lastSeenLabel.text = "Last Seen:"
        self.lastSeenTime.isHidden = false
        self.lastSeenTime.text = date
      }
      
      self.contactNameLabel.text = tabName
      
      if tabImage == "NoImage" {
        self.tabPhoto.image = UIImage.makeLetterAvatar(withUsername: tabName)
      } else {
        self.tabPhoto.kf.setImage(with: URL(string: tabImage))
      }
      
      self.tabPhoto.layer.masksToBounds = true
      self.tabPhoto.layer.cornerRadius = 15
      
    }
    configureTableView()
    getMessages()
    self.heightConstraint.constant = 60
    
  }
  
  func getMessages() {
    MessageServices.instance.REF_MESSAGES.child((self.chat?.key)!).observe(.childAdded) { (snapshot) in
      MessageServices.instance.getAllMessagesFor(desiredChat: self.chat!, handler: { (returnedChatMessages) in
        
        self.chatMessages = returnedChatMessages
        self.configureTableView()
         DispatchQueue.main.async {
        self.chatTableView.reloadData()
        }
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
      self.chatTableView?.scrollToRow(at: indexPath, at: .top, animated: false)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector:#selector(PersonalChatVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector:#selector(PersonalChatVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    chatTableView.delegate = self
    chatTableView.dataSource = self
    textField.delegate = self
    imagePickerContorller.delegate = self
    
    chatTableView.register(UINib(nibName: "CustomMessageIn", bundle: nil), forCellReuseIdentifier: "messageIn")
    chatTableView.register(UINib(nibName: "CustomMessageOut", bundle: nil), forCellReuseIdentifier: "messageOut")
    
    chatTableView.register(UINib(nibName: "MultimediaMessageIn", bundle: nil), forCellReuseIdentifier: "multimediaMessageIn")
    chatTableView.register(UINib(nibName: "MultimediaMessageOut", bundle: nil), forCellReuseIdentifier: "multimediaMessageOut")
    
    //    chatTableView.register(UINib(nibName: "WebCellOut", bundle: nil), forCellReuseIdentifier: "webOut")
    
    //    self.hideKeyboardWhenTappedAround()
    chatTableView.separatorStyle = .none
    chatTableView.setContentOffset(chatTableView.contentOffset, animated: false)
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    
    //        UIView.animate(withDuration: 0.1) {
    //
    //            self.heightConstraint.constant = 325
    //            self.view.layoutIfNeeded()
    //        }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
    
    let outColor = colours.colourMainBlue
    let inColor = colours.colourMainPurple
    let sender = chatMessages[indexPath.row].senderId
    let isMedia = chatMessages[indexPath.row].isMultimedia
    let mediaUrl = chatMessages[indexPath.row].mediaUrl
    let content = chatMessages[indexPath.row].content
    
    
    // Get URL from String
    //    var url: String? = ""
    //
    //    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    //    let matches = detector.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
    //
    //    for match in matches {
    //      guard let range = Range(match.range, in: content) else { continue }
    //      url = String(content[range])
    ////      print(url)
    //    }
    
    if  sender == currentUserId {
      
      if isMedia == true {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "multimediaMessageOut", for: indexPath) as! MultimediaMessageOut
        let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
        
        cell.configeureCell(messageImage: mediaUrl, messageTime: date!, senderName: sender)
        return cell
        
      }
      
      // WebView CEll
      //        else if url != nil {
      //        let cell = tableView.dequeueReusableCell(withIdentifier: "webOut", for: indexPath) as! WebCellOut
      //        let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
      //
      //        cell.configeureCell(mediaUrl: content, messageTime: date!, senderName: sender)
      //        return cell
      //      }
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "messageOut", for: indexPath) as! CustomMessageOut
      let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
      
      cell.configeureCell(senderName: currentEmail!, messageTime: date!, messageBody: content, messageBackground: outColor!, isGroup: false)
      return cell
      
    } else {
      
      if isMedia == true {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "multimediaMessageIn", for: indexPath) as! MultimediaMessageIn
        let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
        
        cell.configeureCell(messageImage: mediaUrl, messageTime: date!, senderName: sender)
        
        return cell
      }
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "messageIn", for: indexPath) as! CustomMessageIn
      let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
      
      cell.configeureCell(senderName: chatMessages[indexPath.row].senderId, messageTime: date!, messageBody: chatMessages[indexPath.row].content, messageBackground: inColor!, isGroup: false)
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
  
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let currentCell = tableView.cellForRow(at: indexPath)
    
    if (currentCell?.isKind(of: MultimediaMessageIn.self))! {
      print("PhotoMessage In Pressed")
      let cell = tableView.cellForRow(at: indexPath) as! MultimediaMessageIn
      
      let configuration = ImageViewerConfiguration { config in
        config.imageView = cell.messageBodyImage
      }
      present(ImageViewerController(configuration: configuration), animated: true)
      
    }else if (currentCell?.isKind(of: MultimediaMessageOut.self))! {
      print("PhotoMessage Out Pressed")
      let cell = tableView.cellForRow(at: indexPath) as! MultimediaMessageOut
      
      let configuration = ImageViewerConfiguration { config in
        config.imageView = cell.messageBodyImage
      }
      present(ImageViewerController(configuration: configuration), animated: true)
    }
    
  }
  
  
  @IBAction func sendButton(_ sender: UIButton) {
    
    let date = Date()
    let currentDate = date.millisecondsSince1970
    let messageUID = ("\(currentDate)" + currentUserId!).replacingOccurrences(of: ".", with: "")
    if textField.text != "" {
      sendBtn.isEnabled = false
      MessageServices.instance.sendMessage(withContent: textField.text!, withTimeSent: "\(currentDate)", withMessageId: messageUID, forSender: currentUserId! , withChatId: chat?.key, isMultimedia: false, sendComplete: { (complete) in
        if complete {
          self.textField.isEnabled = true
          self.sendBtn.isEnabled = true
          self.textField.text = ""
          print("Message saved \(currentDate)")
        }
      })
    }
    dismissKeyboard()
  }
  
  @IBAction func photoMessageButton(_ sender: Any) {
    
    
    let actionSheet = UIAlertController(title: "Select source of Image", message: "", preferredStyle: .actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
      self.imagePickerContorller.sourceType = .camera
      self.present(self.imagePickerContorller, animated: true, completion: nil)
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
      self.imagePickerContorller.sourceType = .photoLibrary
      self.present(self.imagePickerContorller, animated: true, completion: nil)
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
    
    self.present(actionSheet, animated: true, completion: nil)
    
    print("Photo Message Uploaded")
    
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
    
    SVProgressHUD.show(withStatus: "Sending Image")
    
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    let date = Date()
    let currentDate = date.millisecondsSince1970
    let messageUID = ("\(currentDate)" + currentUserId!).replacingOccurrences(of: ".", with: "")
    
    Services.instance.uploadPhotoMessage(withImage: image, withChatKey: (self.chat?.key)!, withMessageId: messageUID, completion: { (imageUrl) in
      
      MessageServices.instance.sendPhotoMessage(isMulti: true, withMediaUrl: imageUrl, withTimeSent: "\(currentDate)", withMessageId: messageUID, forSender: currentUserId!, withChatId: self.chat?.key, sendComplete: { (complete) in
        self.textField.isEnabled = true
        self.sendBtn.isEnabled = true
        self.textField.text = ""
        print("Message saved \(currentDate)")
        SVProgressHUD.dismiss()
      })
    })
    
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  @objc func tableViewTapped() {
    chatTableView.endEditing(true)
  }
  
  func configureTableView() {
    chatTableView.rowHeight = UITableViewAutomaticDimension
    chatTableView.estimatedRowHeight = 263.0
  }
  //
  
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showUserProfile" {
      let userProfileVC = segue.destination as! UserProfileVC
      if let chatName = chat?.chatName {
        userProfileVC.chatName = chatName
      }
      userProfileVC.title = self.contactNameLabel.text!
    }
  }
  
  
  @IBAction func infoButtonPressed(_ sender: UIButton) {
    performSegue(withIdentifier: "showUserProfile", sender: self)
    print("Info Button Pressed")
  }
  
  deinit{
    
  }
  
}







