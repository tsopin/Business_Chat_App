//
//  UserProfileVC.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 21/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import SimpleImageViewer

class UserProfileVC: UITableViewController {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var userEmailLabel: UILabel!
  @IBOutlet weak var lastSeenLabel: UILabel!
  
  var chatName = ""
  var userId = ""
  let colors = Colors()
  
  override func viewWillAppear(_ animated: Bool) {
    
    UserServices.instance.getUserData(byUserId: chatName) { (userData) in
      self.usernameLabel.text = userData.userName
      self.userEmailLabel.text = userData.email
      self.lastSeenLabel.text = self.getDateFromInterval(timestamp: Int64(userData.lastSeen))
      if userData.imageUrl == "NoImage" {
        self.profileImageView.image = UIImage.makeLetterAvatar(withUsername: userData.userName)
      } else {
        self.profileImageView.kf.setImage(with: URL(string: userData.imageUrl))
      }
    }
  }
  
  @IBAction func showUserPhoto(_ sender: Any) {
    
    let configuration = ImageViewerConfiguration { config in
      config.imageView = profileImageView
    }
    present(ImageViewerController(configuration: configuration), animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // make rounded profile image
    navigationItem.backBarButtonItem?.tintColor = colors.colourMainBlue
    profileImageView.layer.masksToBounds = true
    profileImageView.layer.cornerRadius = 105
  }

  
  // MARK: - Table view methods
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 1 : 3
  }
}
