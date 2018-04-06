//
//  WebCellOut.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-04-06.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import WebKit

class WebCellOut: UITableViewCell {
  
  @IBOutlet weak var messageTime: UILabel!
  @IBOutlet weak var senderName: UILabel!
  @IBOutlet weak var bodyColor: UIView!
  @IBOutlet weak var webView: WKWebView!
  
  
  
  func configeureCell(mediaUrl: String, messageTime: String, senderName: String) {
    self.messageTime.text = messageTime
    self.senderName.text = senderName
    
    let trimmedUrl = mediaUrl.replacingOccurrences(of: " ", with: "")
    
    if trimmedUrl.lowercased().range(of:"http") != nil {
      
    }
    
    
    
    let url = URL(string: "http://\(trimmedUrl)")
    let request = URLRequest(url: url!)
    
    self.webView.load(request)

    bodyColor.layer.cornerRadius = 16
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    self.messageTime.text = nil
    self.senderName.text = nil
//    self.webView.c = nil
  }
}
