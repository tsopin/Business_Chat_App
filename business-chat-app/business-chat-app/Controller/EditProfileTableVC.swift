//
//  EditProfileTableVC.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 19/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase


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
		
		userEmailLabel.text = currentEmail
		Services.instance.getmyInfo(handler: { (myName) in
			self.usernameTextField.text = myName
		})
        Services.instance.getUserImage(byUserId: currentUserId!, handler: { (returnedImage) in
            
            let newUrl = returnedImage.absoluteString
            self.profileImageView.loadImageUsingCacheWithUrlString(newUrl)
        
        })
    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
	
	// Textfield methods
	
	// Add "Save" button to navigation bar when editing begins
	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveDetails))
	}
	
	
    
    @IBAction func chooseImage(_ sender: UIButton) {
        
        
        
        
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
        
        print("CHOCHO")

        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.image = image
        
        
        
                Services.instance.uploadUserImage(withImage: image, completion: { (imageUrl) in
        
                    Services.instance.createDBUser(uid: self.currentUserId!, userData: ["avatar" : true])
                
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
			Services.instance.createDBUser(uid: currentUserId!, userData: ["username" : userName])
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

