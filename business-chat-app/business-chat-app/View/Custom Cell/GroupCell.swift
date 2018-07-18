//
//  GroupCell.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-15.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
  
  @IBOutlet weak var groupName: UILabel!
  @IBOutlet weak var numberOfMembers: UILabel!
  
  func configureCell(groupName: String, numberOfMembers: String) {
    self.groupName.text = groupName
    self.numberOfMembers.text = "\(numberOfMembers) participants"
  }
}
