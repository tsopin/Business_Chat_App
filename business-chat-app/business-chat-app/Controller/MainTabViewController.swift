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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    print("connect \(connect)")
//    if !connect {
      self.tabBar.tintColor = colours.colourMainBlue
      self.tabBar.unselectedItemTintColor = colours.colourLightBlue

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
