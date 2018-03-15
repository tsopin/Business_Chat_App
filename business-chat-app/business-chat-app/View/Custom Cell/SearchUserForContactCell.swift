//
//  UserCell.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-13.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class SearchUserForContactCell: UITableViewCell {
    
    @IBOutlet weak var chekImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
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
    
    func cronfigureCell(email: String, userName: String, isSelected: Bool) {
    
        self.emailLabel.text = email
        self.userName.text = userName
        
        if isSelected {
            self.chekImage.isHidden = false
            
        } else {
            self.chekImage.isHidden = true
        }
        
        
        
    }
    
    
    
}

