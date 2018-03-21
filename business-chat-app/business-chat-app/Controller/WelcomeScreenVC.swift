//
//  MainViewController.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class WelcomeScreenVC: UIViewController {
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBtn.layer.cornerRadius = 5
		
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.presentStoryboard()
                
            }
            
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        register()
        
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        
        signIn()
        
    }
    
    
    func register() {
        
        let registerView = RegisterScreenVC(nibName: "RegisterViewController", bundle: nil)
        registerView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(registerView, animated: true, completion: nil)
        
    }
    
    func signIn() {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                self.alert(message: (error?.localizedDescription)!)
            } else {
                print("Log in Successfull!")
                self.performSegue(withIdentifier: "goToMain", sender: self)
                
            }
        }
    }    
}
