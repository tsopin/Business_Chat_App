//
//  MainViewController.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBtn.layer.cornerRadius = 5
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                 self.performSegue(withIdentifier: "goToMain", sender: self)
            }
    
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        
        //        let registerView:RegisterViewController = RegisterViewController()
        //
        //        navigationController?.pushViewController(registerView, animated: true )
        
        let registerView = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        registerView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(registerView, animated: true, completion: nil)
        
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Log in Successfull!")
                  self.performSegue(withIdentifier: "goToMain", sender: self)
//
//                let mainView = MainTabViewController(nibName: "MainTabViewController", bundle: nil)
//                mainView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//                self.present(mainView, animated: true, completion: nil)
//
//
//                //                let contactList:MainTabViewController = MainTabViewController()
//                //
//                //                self.navigationController?.pushViewController(contactList, animated: true )
            }
        }
        
    }

}
