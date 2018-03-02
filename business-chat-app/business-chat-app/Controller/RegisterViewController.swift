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

    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error) in
            
            if error != nil
            { print("Error")
            } else {
                print("Success")
            }
        
        
    }
    


}
}
