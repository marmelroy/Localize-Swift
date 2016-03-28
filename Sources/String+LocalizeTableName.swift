//
//  String+LocalizeTableName.swift
//  Localize_Swift
//
//  Created by Vitalii Budnik on 3/10/16.
//  Copyright © 2016 Vitalii Budnik. All rights reserved.
//

import Foundation

/// tableName friendly extension
public extension String {
  
  /**
   Swift 2 friendly localization syntax, replaces NSLocalizedString
   
   - Parameter tableName: The receiver’s string table to search. If tableName is `nil` 
   or is an empty string, the method attempts to use the table in `Localizable.strings`.
   
   - Returns: The localized string.
   */
  func localized(tableName tableName: String?) -> String {
    return NSBundle.mainBundle().localizedStringForKey(
      self,
      value: self,
      table: tableName)
  }
  
  /**
   Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
   
   - Parameter tableName: The receiver’s string table to search. If tableName is `nil`
   or is an empty string, the method attempts to use the table in `Localizable.strings`.
   
   - Returns: The formatted localized string with arguments.
   */
  func localizedFormat(tableName tableName: String?, arguments: CVarArgType...) -> String {
    return String(format: localized(tableName: tableName), arguments: arguments)
  }
  
  /**
   Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
   
   - Parameter tableName: The receiver’s string table to search. If tableName is `nil`
   or is an empty string, the method attempts to use the table in `Localizable.strings`.
   
   - Returns: The formatted localized string with arguments.
   */
  func localizedFormat(tableName tableName: String?, arguments: [CVarArgType]) -> String {
    return String(format: localized(tableName: tableName), arguments: arguments)
  }
  
  /**
   Swift 2 friendly plural localization syntax with a format argument
   
   - Parameter tableName: The receiver’s string table to search. If tableName is `nil`
   or is an empty string, the method attempts to use the table in `Localizable.strings`.
   
   - parameter argument: Argument to determine pluralisation
   
   - returns: Pluralized localized string.
   */
  func localizedPlural(tableName tableName: String?, argument: CVarArgType) -> String {
    return NSString.localizedStringWithFormat(localized(tableName: tableName), argument) as String
  }
  
}