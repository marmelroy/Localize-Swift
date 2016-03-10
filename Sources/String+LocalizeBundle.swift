//
//  String+LocalizeBundle.swift
//  Localize_Swift
//
//  Created by Vitalii Budnik on 3/10/16.
//  Copyright © 2016 Vitalii Budnik. All rights reserved.
//

import Foundation

/// NSBundle friendly extension
public extension String {
  
  /**
   Swift 2 friendly localization syntax, replaces NSLocalizedString
   
   - Parameter bundle: Localized `NSBudnle`
   
   - Returns: The localized string.
   */
  func localized(bundle bundle: NSBundle) -> String {
    return bundle.localizedStringForKey(self, value: self, table: .None)
  }
  
  /**
   Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
   
   - Parameter bundle: Localized `NSBudnle`
   
   - Parameter tableName: bundle's string table to search. If tableName is `nil`
   or is an empty string, the method attempts to use the table in `Localizable.strings`.
   
   - Returns: The formatted localized string with arguments.
   */
  func localizedFormat(bundle bundle: NSBundle, arguments: CVarArgType...) -> String {
    let localizedString = localized(bundle: bundle)
    return String(format: localizedString, arguments: arguments)
  }
  
  /**
   Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
   
   - Parameter bundle: Localized `NSBudnle`
   
   - Parameter tableName: bundle's string table to search. If tableName is `nil`
   or is an empty string, the method attempts to use the table in `Localizable.strings`.
   
   - Returns: The formatted localized string with arguments.
   */
  func localizedFormat(bundle bundle: NSBundle, arguments: [CVarArgType]) -> String {
    let localizedString = localized(bundle: bundle)
    return String(format: localizedString, arguments: arguments)
  }
  
  /**
   Swift 2 friendly plural localization syntax with a format argument
   
   - Parameter bundle: Localized `NSBudnle`
   
   - Parameter tableName: bundle's string table to search. If tableName is `nil`
   or is an empty string, the method attempts to use the table in `Localizable.strings`.
   
   - parameter argument: Argument to determine pluralisation
   
   - returns: Pluralized localized string.
   */
  func localizedPlural(bundle bundle: NSBundle, argument: CVarArgType) -> String {
    let localizedString = localized(bundle: bundle)
    return NSString.localizedStringWithFormat(localizedString, argument) as String
  }
  
  // MARK: tableName
  
  /**
   Swift 2 friendly localization syntax, replaces NSLocalizedString
   
   - Parameter bundle: Localized `NSBudnle`
   
   - Parameter tableName: bundle's string table to search. If tableName is `nil`
   or is an empty string, the method attempts to use the table in `Localizable.strings`.
   
   - Returns: The localized string.
   */
  func localized(bundle bundle: NSBundle, tableName: String?) -> String {
    return bundle.localizedStringForKey(self, value: self, table: tableName)
  }
  
  /**
   Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
   
   - Parameter bundle: Localized `NSBudnle`
   
   - Parameter tableName: bundle's string table to search. If tableName is `nil`
   or is an empty string, the method attempts to use the table in `Localizable.strings`.
   
   - Returns: The formatted localized string with arguments.
   */
  func localizedFormat(bundle bundle: NSBundle, tableName: String?, arguments: CVarArgType...) -> String {
    let localizedString = localized(bundle: bundle, tableName: tableName)
    return String(format: localizedString, arguments: arguments)
  }
  
  /**
   Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
   
   - Parameter bundle: Localized `NSBudnle`
   
   - Parameter tableName: bundle's string table to search. If tableName is `nil`
   or is an empty string, the method attempts to use the table in `Localizable.strings`.
   
   - Returns: The formatted localized string with arguments.
   */
  func localizedFormat(bundle bundle: NSBundle, tableName: String?, arguments: [CVarArgType]) -> String {
    let localizedString = localized(bundle: bundle, tableName: tableName)
    return String(format: localizedString, arguments: arguments)
  }
  
  /**
   Swift 2 friendly plural localization syntax with a format argument
   
   - Parameter bundle: Localized `NSBudnle`
   
   - Parameter tableName: bundle's string table to search. If tableName is `nil`
   or is an empty string, the method attempts to use the table in `Localizable.strings`.
   
   - parameter argument: Argument to determine pluralisation
   
   - returns: Pluralized localized string.
   */
  func localizedPlural(bundle bundle: NSBundle, tableName: String?, argument: CVarArgType) -> String {
    let localizedString = localized(bundle: bundle, tableName: tableName)
    return NSString.localizedStringWithFormat(localizedString, argument) as String
  }
  
}