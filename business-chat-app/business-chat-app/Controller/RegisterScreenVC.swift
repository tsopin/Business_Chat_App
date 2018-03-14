//
//  RegisterViewController.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class RegisterScreenVC: UIViewController {
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordConfirmTextfield: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        regButton.layer.cornerRadius = 5 
        self.hideKeyboardWhenTappedAround() 
    
    }
    

    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        
        let email = emailTextfield.text
        let userName = usernameTextfield.text
        let password = passwordTextfield.text
        let confirmPassword = passwordConfirmTextfield.text

        if  password == confirmPassword && userName != nil && email != nil  {
            
            userRegister(userCreationComplete: { (success, loginError) in
                if success {
//                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: loginError?.localizedDescription))
                }})
            
        }
        
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        

    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func presentStoryboard() {
        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabViewController") as UIViewController
        self.present(vc, animated: true, completion: nil)
        print("GoGoGo")
    }
    
    func userRegister(userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        let userName = usernameTextfield.text!
        let password = passwordTextfield.text!
        let email = emailTextfield.text!
//        let usersDB = Database.database().reference().child("users")
        
//        let idDb = Database.database().reference().child("users").child("contactList")
//        let userId = idDb.childByAutoId().key

//        let usersDictionary = ["email": email, "username": userName ] as [String : Any]
       
        Auth.auth().createUser(withEmail: "\(email)", password: "\(password)") { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["username": userName, "email": email]
            DataServices.instance.createDBUser(uid: user.uid, userData: userData)
            userCreationComplete(true, nil)
        }
        
            
//            {
//            (user, error) in
//
//            if error != nil
//            { print("Error")
//
//            } else {
//                print("Success")
//                self.presentStoryboard()
//
//                usersDB.childByAutoId().setValue(usersDictionary) {
//                    (error, reference) in
//
//                    if error != nil {
//                        print(error!)
//                    } else {
//                        print("User saved")
//                    }
//                }
//            }
//        }
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
