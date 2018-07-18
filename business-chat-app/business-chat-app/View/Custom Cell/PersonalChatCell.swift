//
//  PersonalChatCell.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-18.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Kingfisher
import LetterAvatarKit

class PersonalChatCell: UITableViewCell {
  
  @IBOutlet weak var contactName: UILabel!
  @IBOutlet weak var lastMessageBody: UILabel!
  @IBOutlet weak var lastMessage: UILabel!
  @IBOutlet weak var statusImage: UIImageView!
  @IBOutlet weak var userpicImage: UIImageView!
  
  func configureCell(contactName: String, lastMessageBody: String, lastMessage: String, statusImage: UIImage, imageUrl: String) {
    
    if imageUrl == "NoImage" {
      userpicImage.image = UIImage.makeLetterAvatar(withUsername: contactName)
    } else {
      userpicImage.kf.setImage(with: URL(string: imageUrl))
    }
    
//    self.lastMessageBody.isHidden = true
    userpicImage.layer.masksToBounds = true
    userpicImage.layer.cornerRadius = 30
    
    self.contactName.text = contactName
    self.lastMessageBody.text = lastMessageBody
    self.lastMessage.text = lastMessage
    self.statusImage.image = statusImage
  }
}
