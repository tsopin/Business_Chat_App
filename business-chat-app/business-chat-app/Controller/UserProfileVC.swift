//
//  UserProfileVC.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 21/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class UserProfileVC: UITableViewController {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var userEmailLabel: UILabel!
  
  var chatName = ""
  var userId = ""
  
  override func viewWillAppear(_ animated: Bool) {
    
    UserServices.instance.getUserData(byUserId: chatName) { (userData) in
      self.usernameLabel.text = userData.1
      self.userEmailLabel.text = userData.0
      if userData.3 == "NoImage" {
        self.profileImageView.image = UIImage.makeLetterAvatar(withUsername: userData.1)
      } else {
        self.profileImageView.kf.setImage(with: URL(string: userData.3))
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // make rounded profile image
    profileImageView.layer.masksToBounds = true
    profileImageView.layer.cornerRadius = 105
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - Table view methods
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return section == 0 ? 1 : 2
  }
}
