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
	
	public var attributed : NSMutableAttributedString {
		return self.transform()
	}
	
	private func parse(mutable: NSMutableAttributedString) -> NSMutableAttributedString {
		var tempMutable = mutable
		let pattern : String = "\\#\\[\\{([^\\}]+)\\}(.+)\\]"
		let regexp = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
		
		
		let matches : [NSTextCheckingResult] = regexp.matches(in: mutable.string, options: [], range: NSMakeRange(0, mutable.string.characters.count))
		
		for match in matches {
			let group = match.rangeAt(0)
			let styles = match.rangeAt(1)
			let text = match.rangeAt(2)
			
			let temp = parse(style: mutable.string.substring(from: styles))
			
			tempMutable.replaceCharacters(in: group, with: mutable.string.substring(from: text))
			
			tempMutable.addAttributes(temp, range: NSMakeRange(group.location, text.length))
			tempMutable = self.parse(mutable: tempMutable)
			
		}
		
		return tempMutable
	}
	
	private func transform() -> NSMutableAttributedString {
		var mutable : NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: nil)
		
		mutable.beginEditing()
		
		mutable = self.parse(mutable: mutable)
		
		mutable.endEditing()
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
		case "font":
			let temp = value.components(separatedBy: ",")
			return (key: NSFontAttributeName, value: UIFont(name: temp[0], size: CGFloat(Int.init(temp[1], radix: 10) ?? Int(UIFont.systemFontSize))))
		case "align":
			let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
			
			paragraphStyle.alignment = .center
			return (key: NSParagraphStyleAttributeName, value: paragraphStyle)
		default:
			return (key: "", value: "")
		}
	}
}
