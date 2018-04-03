//
//  MultimediaMessageIn.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-04-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Kingfisher

class MultimediaMessageIn: UITableViewCell {
  
  @IBOutlet weak var messageTime: UILabel!
  @IBOutlet weak var messageBodyImage: UIImageView!
  
  @IBOutlet weak var senderName: UILabel!
  
  func configeureCell(messageImage: String, messageTime: String, senderName: String) {
    self.messageTime.text = messageTime
    self.senderName.text = senderName
    messageBodyImage.kf.setImage(with: URL(string: messageImage))
  }
  
}
