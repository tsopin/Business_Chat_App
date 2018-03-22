//
//  GroupMemberCell.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 22/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class GroupMemberCell: UITableViewCell {
	
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var userEmailLabel: UILabel!
	@IBOutlet weak var userImageView: UIImageView!
	
	func configureCell(username: String, userEmail: String, userPic: UIImage) {
		self.usernameLabel.text = username
		self.userEmailLabel.text = userEmail
		self.userImageView.image = userPic
	}
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
