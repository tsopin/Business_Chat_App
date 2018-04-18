//
//  CustomMessageOut.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-06.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class CustomMessageOut: UITableViewCell {
    
    @IBOutlet weak var userPic: UIImageView!
    
    @IBOutlet weak var senderName: UILabel!
    
    @IBOutlet weak var messageTime: UILabel!
    
    @IBOutlet weak var messageBody: UILabel!
    
    @IBOutlet weak var messageBackground: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  func configeureCell(senderName: String, messageTime: String, messageBody: String, messageBackground: UIColor, isGroup: Bool) {
        self.senderName.text = senderName
        self.messageTime.text = messageTime
        self.messageBody.text = messageBody
        self.messageBackground.backgroundColor = messageBackground
        self.userPic.isHidden = true
        self.senderName.isHidden = true
    }
  override func prepareForReuse() {
    super.prepareForReuse()
    self.senderName.text = nil
    self.messageTime.text = nil
    self.messageBody.text = nil
    self.messageBackground.backgroundColor = nil
  }
  
}
