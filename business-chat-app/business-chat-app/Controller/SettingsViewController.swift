//
//  SettingsViewController.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-05.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func logOutBtn(_ sender: Any) {
        
        let actionSheets = UIAlertController(title: "Log Out", message: "Are you sure you want to logout?" , preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Log Out", style: .destructive , handler: {
            (alert: UIAlertAction!) -> Void in
            
            do {
                try Auth.auth().signOut()
                print("LogOut")
                self.dismiss(animated: true, completion: nil)
            }
            catch {
                print("Error")
            }
            
        } )
        let cancel = UIAlertAction(title: "Cancel ", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        } )
        
        actionSheets.addAction(action1)
        actionSheets.addAction(cancel)
        self.present(actionSheets, animated: true, completion: nil)

    }
}
