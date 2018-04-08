//
//  EditProfileTableVC.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 19/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class EditProfileTableVC: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  let imagePickerContorller = UIImagePickerController()
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var userEmailLabel: UILabel!
  
  let colours = Colours()
  
  let currentEmail = Auth.auth().currentUser?.email
  let currentUserId = Auth.auth().currentUser?.uid
  var userName = String()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // make rounded profile image
    profileImageView.layer.masksToBounds = true
    profileImageView.layer.cornerRadius = 60
    
    usernameTextField.delegate = self
    imagePickerContorller.delegate = self
    self.hideKeyboardWhenTappedAround()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UserServices.instance.getUserData(byUserId: currentUserId!) { (userData) in
      self.usernameTextField.text = userData.1
      self.userEmailLabel.text = userData.0
      //      let placeHolder = UIImage(named: "userpic_placeholder_small")
      
      if userData.3 == "NoImage" {
        self.profileImageView.image = UIImage.makeLetterAvatar(withUsername: userData.1)
      } else {
        self.profileImageView.kf.setImage(with: URL(string: userData.3))
      }
    }
  }
  
  // Textfield methods
  
  // Add "Save" button to navigation bar when editing begins
  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveDetails))
  }
  
  @IBAction func deletePhotoButton(_ sender: Any) {
    
    let userData = ["avatar":false, "avatarURL":nil]
    
    UserServices.instance.createDBUser(uid: self.currentUserId!, userData: userData as Any as! Dictionary<String, Any>)
  }
  
  
  @IBAction func chooseImage(_ sender: UIButton) {
    
    let connectionStatus = Services.instance.myStatus()
    
    if connectionStatus {
      let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
      
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
      
      print("EST SET")
      
    } else {
      profileImageView.isHighlighted = false
      print("NET SETI")
    }
    
 
    
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    SVProgressHUD.show(withStatus: "Uploading Image")
    profileImageView.image = image
    
    Services.instance.uploadUserImage(withImage: image, completion: { (imageUrl) in
      UserServices.instance.createDBUser(uid: self.currentUserId!, userData: ["avatar" : true, "avatarURL" : imageUrl])
      SVProgressHUD.showSuccess(withStatus: "Image Successfully Uploaded")
      SVProgressHUD.dismiss()
      
    })
    
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  // Save user details
  
  @objc func saveDetails() {
    
    if usernameTextField.text != "" {
      print(usernameTextField.text!)
      userName = usernameTextField.text!
      UserServices.instance.createDBUser(uid: currentUserId!, userData: ["username" : userName])
      navigationController?.popViewController(animated: true)
    } else {
      print("empty username!")
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view methods
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // currently two, but could be more
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning number of rows in sections should be updated if there are more user details added
    return section == 0 ? 1 : 2
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UITableViewHeaderFooterView()
    headerView.textLabel?.font = UIFont(name: "Avenir-Medium", size: 20)
    headerView.textLabel?.textColor = colours.colourMainBlue
    return headerView
  }
  
  deinit{
    
  }
}

