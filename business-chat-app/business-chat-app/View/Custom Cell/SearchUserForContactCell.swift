//
//  UserCell.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-13.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Kingfisher
import LetterAvatarKit

class SearchUserForContactCell: UITableViewCell {
    
    @IBOutlet weak var chekImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var userPic: UIImageView!
	
    
  var showing = false
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            
            if showing == false {
                chekImage.isHidden = false
                showing = true
                
            } else {
                self.chekImage.isHidden = true
                showing = false
            }
            
        }
    }
    
	func configureCell(email: String, userName: String, imageUrl: String, isSelected: Bool) {
		
		if imageUrl == "NoImage" {
			userPic.image = UIImage.makeLetterAvatar(withUsername: userName)
		} else {
			userPic.kf.setImage(with: URL(string: imageUrl))
		}
		
		userPic.layer.masksToBounds = true
		userPic.layer.cornerRadius = 20
    
        self.emailLabel.text = email
        self.userName.text = userName
        
        if isSelected {
            self.chekImage.isHidden = false
            
        } else {
            self.chekImage.isHidden = true
        }
        
        
        
    }
    
    
    
}

