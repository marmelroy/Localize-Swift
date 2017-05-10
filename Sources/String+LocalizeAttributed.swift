//
//  String+LocalizeAttributed.swift
//  Localize_Swift
//
//  Created by Smol on 10/05/2017.
//  Copyright © 2017 Roy Marmelstein. All rights reserved.
//

import Foundation
import UIKit

// example - #[{color:3A92C4;background:00FF00}bleue]

fileprivate extension UIColor {
	convenience init(hexa: Int) {
		let red : Int = hexa >> 16 & 0xFF
		let green : Int = hexa >> 8 & 0xFF
		let blue : Int = hexa & 0xFF
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
}

public extension String {
	internal func substring(from range : NSRange) -> String {
		let startIndex = self.index(self.startIndex, offsetBy: range.location)
		let endIndex = self.index(self.startIndex, offsetBy: range.location + range.length)
		
		let newRange = startIndex..<endIndex
		return self.substring(with: newRange)
	}
	
	public var localizedAttributed : NSMutableAttributedString {
		return self.localized().transform()
	}
	
	private func transform() -> NSMutableAttributedString {
		let mutable : NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: nil)
		
		let pattern : String = "\\#\\[\\{(.+)\\}(.+)\\]"
		let regexp = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
		
		let matches : [NSTextCheckingResult] = regexp.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
		
		for match in matches {
			let group = match.rangeAt(0)
			let styles = match.rangeAt(1)
			let text = match.rangeAt(2)

			let temp = parse(style: self.substring(from: styles))
			
			mutable.replaceCharacters(in: group, with: self.substring(from: text))
			
			mutable.addAttributes(temp, range: NSMakeRange(group.location, text.length))
		}
		
		return mutable
	}
	
	func parse(style: String) -> [String:Any]{
		var attributes : [String:Any] = [:]
		let pattern : String = "[;]?([^;:]+):([^;:}]+)"
		
		let regexp = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
		
		let matches : [NSTextCheckingResult] = regexp.matches(in: style, options: [], range: NSMakeRange(0, style.characters.count))

		for match in matches {
			let key = style.substring(from: match.rangeAt(1))
			let value = style.substring(from: match.rangeAt(2))
			
			
			let temp = self.attribute(key: key, value: value)
			attributes[temp.key] = temp.value
		}
		
		return attributes
	}
	
	func attribute(key: String, value: String) -> (key: String, value: Any) {
		switch key {
		case "color":
			return (key: NSForegroundColorAttributeName, value: UIColor(hexa: Int.init(value, radix: 16)!))
		case "background":
			return (key: NSBackgroundColorAttributeName, value: UIColor(hexa: Int.init(value, radix: 16)!))
		default:
			return (key: "", value: "")
		}
	}
}
