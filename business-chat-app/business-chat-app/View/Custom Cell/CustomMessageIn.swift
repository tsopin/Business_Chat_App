//
//  CustomMessageIn.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-05.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class CustomMessageIn: UITableViewCell {
  let colours = Colours()
  
  @IBOutlet weak var senderName: UILabel!
  @IBOutlet weak var userPic: UIImageView!
  
  @IBOutlet weak var messageTime: UILabel!
  
  @IBOutlet weak var messageBody: UILabel!
  
  @IBOutlet weak var messageBackground: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func configeureCell(senderName: String, messageTime: String, messageBody: String, messageBackground: UIColor, isGroup: Bool ) {
    
    
    
    
    self.senderName.text = senderName
    self.messageTime.text = messageTime
    self.messageBody.text = messageBody
    self.messageBackground.backgroundColor = messageBackground
    self.userPic.isHidden = !isGroup
    self.userPic.layer.masksToBounds = true
    self.userPic.layer.cornerRadius = 20
    self.userPic.layer.borderWidth = 1
    self.userPic.layer.borderColor = UIColor.white.cgColor
    self.senderName.isHidden = !isGroup
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.senderName.text = nil
    self.messageTime.text = nil
    self.messageBody.text = nil
  }
  
}
