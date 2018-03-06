//
//  RegisterViewController.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        regButton.layer.cornerRadius = 5 
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        let email = emailTextfield.text!
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        
        
        let password = passwordTextfield.text!
        let trimmedPassword = password.trimmingCharacters(in: .whitespaces)
        
        Auth.auth().createUser(withEmail: "\(trimmedEmail)", password: "\(trimmedPassword)") {
            (user, error) in
            
            if error != nil
            { print("Error")
                print(password)
                
            } else {
                print("Success")
                
                let chatList:ChatTableViewController = ChatTableViewController()
                
                self.navigationController?.pushViewController(chatList, animated: true )
            }
            
            
        }
        
        
        
    }
    @IBAction func cancelBtn(_ sender: Any) {
        
      self.dismiss(animated: true, completion: nil)
        
        
    }
}
