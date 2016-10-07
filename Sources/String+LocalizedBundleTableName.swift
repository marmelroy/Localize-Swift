//
//  String+LocalizedBundleTableName.swift
//  Localize_Swift
//
//  Created by Vitalii Budnik on 10/7/16.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

/// bundle & tableName friendly extension
public extension String {
	
	/**
	Swift 2 friendly localization syntax, replaces NSLocalizedString
	
	- Parameter tableName: The receiver’s string table to search. If tableName is `nil`
	or is an empty string, the method attempts to use `Localizable.strings`.

	- Parameter bundle: The receiver’s bundle to search. If bundle is `nil`,
	the method attempts to use main bundle.
	
	- Returns: The localized string.
	*/
	func localized(using tableName: String?, in bundle: Bundle?) -> String {
		let bundle: Bundle = bundle ?? .main
		if let path = bundle.path(forResource: Localize.currentLanguage(), ofType: "lproj"),
			let bundle = Bundle(path: path) {
			return bundle.localizedString(forKey: self, value: nil, table: tableName)
		}
		else if let path = bundle.path(forResource: LCLBaseBundle, ofType: "lproj"),
			let bundle = Bundle(path: path) {
			return bundle.localizedString(forKey: self, value: nil, table: tableName)
		}
		return self
	}
	
	/**
	Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
	
	- Parameter tableName: The receiver’s string table to search. If tableName is `nil`
	or is an empty string, the method attempts to use `Localizable.strings`.

	- Parameter bundle: The receiver’s bundle to search. If bundle is `nil`,
	the method attempts to use main bundle.
	
	- Parameter arguments: arguments values for temlpate (substituted according to the user’s default locale).
	
	- Returns: The formatted localized string with arguments.
	*/
	func localizedFormat(using tableName: String?, in bundle: Bundle?, arguments: CVarArg...) -> String {
		return String(format: localized(using: tableName, in: bundle), arguments: arguments)
	}
	
	/**
	Swift 2 friendly plural localization syntax with a format argument
	
	- Parameter tableName: The receiver’s string table to search. If tableName is `nil`
	or is an empty string, the method attempts to use `Localizable.strings`.

	- Parameter bundle: The receiver’s bundle to search. If bundle is `nil`,
	the method attempts to use main bundle.
	
	- parameter argument: Argument to determine pluralisation
	
	- returns: Pluralized localized string.
	*/
	func localizedPlural(using tableName: String?, in bundle: Bundle?, argument: CVarArg) -> String {
		return NSString.localizedStringWithFormat(localized(using: tableName, in: bundle) as NSString, argument) as String
	}
	
}
