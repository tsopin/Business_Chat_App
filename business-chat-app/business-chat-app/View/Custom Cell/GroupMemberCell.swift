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
	@IBOutlet weak var userPic: UIImageView!
	
	func configureCell(username: String, userEmail: String, imageUrl: String) {
		self.usernameLabel.text = username
		self.userEmailLabel.text = userEmail
		
		if imageUrl == "NoImage" {
			self.userPic.image = UIImage.makeLetterAvatar(withUsername: username)
		} else {
			self.userPic.kf.setImage(with: URL(string: imageUrl))
		}
		
		userPic.layer.masksToBounds = true
		userPic.layer.cornerRadius = 20
	}
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
