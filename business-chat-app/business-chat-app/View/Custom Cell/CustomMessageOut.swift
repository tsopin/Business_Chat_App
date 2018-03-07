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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
