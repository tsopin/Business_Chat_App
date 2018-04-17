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
  @IBOutlet weak var bodyColor: UIView!
  
  
  
  func configeureCell(messageImage: String, messageTime: String, senderName: String) {
    self.messageTime.text = messageTime
    self.senderName.text = senderName
    self.senderName.isHidden = true

    messageBodyImage.kf.setImage(with: URL(string: messageImage))
    messageBodyImage.layer.cornerRadius = 14
    messageBodyImage.layer.borderWidth = 1
    messageBodyImage.layer.borderColor = UIColor.white.cgColor
    bodyColor.layer.cornerRadius = 16
//    bodyColor.layer.borderWidth = 1
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.messageTime.text = nil
    self.senderName.text = nil
    self.messageBodyImage.image = nil
  }
}
