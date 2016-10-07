//
//  String+LocalizeBundle.swift
//  Localize_Swift
//
//  Created by Vitalii Budnik on 10/7/16.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

/// bundle friendly extension
public extension String {
	
	/**
	Swift 2 friendly localization syntax, replaces NSLocalizedString
	
	- Parameter bundle: The receiver’s bundle to search. If bundle is `nil`,
	the method attempts to use main bundle.
	
	- Returns: The localized string.
	*/
	func localized(in bundle: Bundle?) -> String {
		return localized(using: nil, in: bundle)
	}
	
	/**
	Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
	
	- Parameter bundle: The receiver’s bundle to search. If bundle is `nil`,
	the method attempts to use main bundle.
	
	- Parameter arguments: arguments values for temlpate (substituted according to the user’s default locale).
	
	- Returns: The formatted localized string with arguments.
	*/
	func localizedFormat(in bundle: Bundle?, arguments: CVarArg...) -> String {
		return String(format: localized(in: bundle), arguments: arguments)
	}
	
	/**
	Swift 2 friendly plural localization syntax with a format argument
	
	- Parameter bundle: The receiver’s bundle to search. If bundle is `nil`,
	the method attempts to use main bundle.
	
	- parameter argument: Argument to determine pluralisation
	
	- returns: Pluralized localized string.
	*/
	func localizedPlural(in bundle: Bundle?, argument: CVarArg) -> String {
		return NSString.localizedStringWithFormat(localized(in: bundle) as NSString, argument) as String
	}
	
}
