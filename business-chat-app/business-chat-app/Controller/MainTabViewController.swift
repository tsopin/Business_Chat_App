//
//  MainTabViewController.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-03.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
  
  let colours = Colours()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Services.instance.presenceSystem()
    
//    let network = Services.instance.myStatus()
//    if network {
//      self.tabBar.tintColor = colours.colourMainBlue
//      self.tabBar.unselectedItemTintColor = colours.colourLightBlue
//    } else {
//      self.tabBar.tintColor = colours.colourMainPurple
//      self.tabBar.unselectedItemTintColor = colours.colourMainPurple
//    }
    
    self.tabBar.tintColor = colours.colourMainBlue
    self.tabBar.unselectedItemTintColor = colours.colourLightBlue
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
