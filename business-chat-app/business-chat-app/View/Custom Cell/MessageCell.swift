//
//  MessageCell.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-06.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {
    
    
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var userPic: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    
}


