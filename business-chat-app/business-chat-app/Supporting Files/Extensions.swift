//
//  Extensions.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-16.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit

extension UIView {
  
  func bindToKeyboard() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboradWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
  }
  
  @objc func keyboradWillChange(_ notification: NSNotification) {
    
    let duration =  notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
    let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
    let beginnigFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
    let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let deltaY = endFrame.origin.y - beginnigFrame.origin.y
    
    UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
      self.frame.origin.y += deltaY
    }, completion: nil)
    
  }
  
  func pushTransition(_ duration:CFTimeInterval) {
    let animation:CATransition = CATransition()
    animation.timingFunction = CAMediaTimingFunction(name:
      kCAMediaTimingFunctionEaseInEaseOut)
    animation.type = kCATransitionPush
    animation.subtype = kCATransitionFromTop
    animation.duration = duration
    layer.add(animation, forKey: kCATransitionPush)
  }
  
  func setGradient(_ topColour: CGColor, _ bottomColour: CGColor) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.bounds
    gradientLayer.colors = [topColour, bottomColour]
    self.layer.insertSublayer(gradientLayer, at: 0)
  }
  
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  func presentStoryboard() {
    
    
    
    let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "MainTabVC") as UIViewController
    self.present(vc, animated: true, completion: nil)
    print("GoGoGo")
  }
  
  func alert(message: String) {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
    
  }
  func getDateFromInterval(timestamp: Double?) -> String? {
    
    if let timestamp = timestamp {
      let date = Date(timeIntervalSinceReferenceDate: timestamp)
      let dateFormatter = DateFormatter()
      let timeSinceDateInSeconds = Date().timeIntervalSince(date)
      let secondInDays: TimeInterval = 24*60*60
      if timeSinceDateInSeconds > 7 * secondInDays {
        dateFormatter.dateFormat = "MM/dd/yy"
      } else if timeSinceDateInSeconds > secondInDays {
        dateFormatter.dateFormat = "EEEE"
      } else {
        dateFormatter.dateFormat = "h:mm a, EEEE"
      }
      return dateFormatter.string(from: date)
    } else {
      return nil
    }
    
  }
  
}

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }
}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
  
  func loadImageUsingCacheWithUrlString(_ urlString: String) {
    
    self.image = nil
    
    //check cache for image first
    if let cachedImage = imageCache.object(forKey: urlString as NSString) {
      self.image = cachedImage
      return
    }
    
    //otherwise fire off a new download
    let url = URL(string: urlString)
    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
      
      //download hit an error so lets return out
      if error != nil {
        print(error!)
        return
      }
      
      DispatchQueue.main.async(execute: {
        
        if let downloadedImage = UIImage(data: data!) {
          imageCache.setObject(downloadedImage, forKey: urlString as NSString)
          
          self.image = downloadedImage
        }
      })
      
    }).resume()
  }
}

