//
//  MainViewController.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        
        let registerView:RegisterViewController = RegisterViewController()
        
        navigationController?.pushViewController(registerView, animated: true )
        
        //        let registerView = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        //        registerView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //        self.present(registerView, animated: true, completion: nil)
        
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        
//        let logInView = LoginViewController(nibName: "LoginViewController", bundle: nil)
//        logInView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        self.present(logInView, animated: true, completion: nil)
        
        let logInView:LoginViewController = LoginViewController()
        
        navigationController?.pushViewController(logInView, animated: true )
        //        self.present(logInView, animated: true, completion: nil)
        
    }
    
}
