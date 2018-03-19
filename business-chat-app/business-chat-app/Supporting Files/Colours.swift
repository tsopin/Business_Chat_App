//
//  Colours.swift
//  business-chat-app
//
//  Created by Sergey Kozak on 19/03/2018.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Foundation

 class Colours {
	
	let colourMainBlue: UIColor
	let colourMainPurple: UIColor
	let colourLightBlue: UIColor
	let colourLightestBlue: UIColor
	
	let fontMainAvenir: UIFont
	
	init() {
		self.colourMainBlue = UIColor(red: 8.0/255.0, green: 72.0/255.0, blue: 135.0/255.0, alpha: 1.0)
		self.colourMainPurple = UIColor(red: 143.0/255.0, green: 45.0/255.0, blue: 86.0/255.0, alpha: 1.0)
		self.colourLightBlue = UIColor(red: 80.0/255.0, green: 125.0/255.0, blue: 188.0/255.0, alpha: 1.0)
		self.colourLightestBlue = UIColor(red: 161.0/255.0, green: 198.0/255.0, blue: 234.0/255.0, alpha: 1.0)
		self.fontMainAvenir = UIFont(name: "Avenir-Book", size: 17)!
	}
}
