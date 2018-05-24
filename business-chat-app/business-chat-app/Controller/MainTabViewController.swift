//
//  MainTabViewController.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-03.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
  
  let colours = Colors()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Services.instance.presenceSystem()
    
    self.tabBar.tintColor = colours.colourMainBlue
    self.tabBar.unselectedItemTintColor = UIColor.lightGray
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
