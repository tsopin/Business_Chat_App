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
  @IBOutlet weak var userEmailTextField: UITextField!
  
  let currentEmail = Auth.auth().currentUser?.email
  let currentUserId = Auth.auth().currentUser?.uid
  var userName = String()
  var userEmail = String()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // make rounded profile image
    profileImageView.layer.masksToBounds = true
    profileImageView.layer.cornerRadius = 60
    
    usernameTextField.delegate = self
	userEmailTextField.delegate = self
    imagePickerContorller.delegate = self
    self.hideKeyboardWhenTappedAround()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UserServices.instance.getUserData(byUserId: currentUserId!) { (userData) in
      self.usernameTextField.text = userData.1
      self.userEmailTextField.text = userData.0
      
      if userData.3 == "NoImage" {
        self.profileImageView.image = UIImage.makeLetterAvatar(withUsername: userData.1)
      } else {
        self.profileImageView.kf.setImage(with: URL(string: userData.3))
      }
    }
  }
  
	// MARK: -- Textfield methods --
  
  // Add "Save" button to navigation bar when editing begins
  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveDetails))
  }
	
	
	// MARK: -- Profile image --
	
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
  
	// MARK: -- Save user details --
  
  @objc func saveDetails() {
    
    if usernameTextField.text != "" && userEmailTextField.text != "" {
		
	// Chage username
      userName = usernameTextField.text!
      UserServices.instance.createDBUser(uid: currentUserId!, userData: ["username" : userName])
		
	// Change user email
		userEmail = userEmailTextField.text!
		changeEmail(userEmail)

    } else {
      print("empty username or email!")
    }
  }
	
	// Try to change email
	
	func changeEmail(_ newEmail: String) {
		Auth.auth().currentUser?.updateEmail(to: userEmail) { (error) in
			if (error != nil) {
				self.reLogIn()
			} else {
				UserServices.instance.REF_USERS.child("\(self.currentUserId!)/email").setValue(newEmail)
				SVProgressHUD.showSuccess(withStatus: "Profile updated!")
				self.navigationController?.popViewController(animated: true)
				SVProgressHUD.dismiss(withDelay: 1)
			}
		}
	}
	
	
	
	// If User needs to re-authenticate in order to change email, this method is called and change email retried
	func reLogIn() {
		
		var password = String()
		
		let alert = UIAlertController(title: "Confirmation required", message: "Please enter your password", preferredStyle: .alert)
		alert.addTextField { (textField) in
			textField.placeholder = "Password"
			textField.textContentType = UITextContentType.password
			textField.isSecureTextEntry = true
		}
		let loginAction = UIAlertAction(title: "Sign in", style: .default) { (action) in
			let passwordField = alert.textFields![0]
			password = passwordField.text!
			
			Auth.auth().signIn(withEmail: self.currentEmail!, password: password, completion: { (user, error) in
				if let error = error {
					print(error.localizedDescription)
					self.alert(message: error.localizedDescription)
				}
				if user != nil {
					self.changeEmail(self.userEmail)
				}
			})
		}

		let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
		alert.addAction(loginAction)
		alert.addAction(cancel)
		
		self.present(alert, animated: true, completion: nil)

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
	
  deinit{
    
  }
}

