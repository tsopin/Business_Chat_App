//
//  MultimediaMessageOut.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-04-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Kingfisher

class MultimediaMessageOut: UITableViewCell {
  
  @IBOutlet weak var messageTime: UILabel!
  @IBOutlet weak var senderName: UILabel!
  @IBOutlet weak var messageBodyImage: UIImageView!
  
  
  
  func configeureCell(messageImage: String, messageTime: String, senderName: String) {
    self.messageTime.text = messageTime
    self.senderName.text = senderName
    messageBodyImage.kf.setImage(with: URL(string: messageImage))
  }
  
}
