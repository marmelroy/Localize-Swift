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
     or is an empty string, the method attempts to use `Localizable.strings`.
     
     - Returns: The localized string.
     */
    func localized(using tableName: String?) -> String {
        return localized(using: tableName, in: .main)
    }
    
    /**
     Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
     
     - Parameter tableName: The receiver’s string table to search. If tableName is `nil`
     or is an empty string, the method attempts to use `Localizable.strings`.
     
     - Parameter arguments: arguments values for temlpate (substituted according to the user’s default locale).
     
     - Returns: The formatted localized string with arguments.
     */
    func localizedFormat(using tableName: String?, arguments: CVarArg...) -> String {
        return String(format: localized(using: tableName), arguments: arguments)
    }
    
    /**
     Swift 2 friendly plural localization syntax with a format argument
     
     - Parameter tableName: The receiver’s string table to search. If tableName is `nil`
     or is an empty string, the method attempts to use `Localizable.strings`.
     
     - parameter argument: Argument to determine pluralisation
     
     - returns: Pluralized localized string.
     */
    func localizedPlural(using tableName: String?, argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localized(using: tableName) as NSString, argument) as String
    }
    
}
