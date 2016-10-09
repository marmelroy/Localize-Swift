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
     Swift 2 friendly localization syntax, replaces NSLocalizedString.
     
     - parameter tableName: The receiver’s string table to search. If tableName is `nil`
     or is an empty string, the method attempts to use `Localizable.strings`.
     
     - returns: The localized string.
     */
    func localized(using tableName: String?) -> String {
        return localized(using: tableName, in: .main)
    }
    
    /**
     Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString).
     
     - parameter arguments: arguments values for temlpate (substituted according to the user’s default locale).

     - parameter tableName: The receiver’s string table to search. If tableName is `nil`
     or is an empty string, the method attempts to use `Localizable.strings`.
     
     - returns: The formatted localized string with arguments.
     */
    func localizedFormat(arguments: CVarArg..., using tableName: String?) -> String {
        return String(format: localized(using: tableName), arguments: arguments)
    }
    
    /**
     Swift 2 friendly plural localization syntax with a format argument.
     
     - parameter argument: Argument to determine pluralisation.

     - parameter tableName: The receiver’s string table to search. If tableName is `nil`
     or is an empty string, the method attempts to use `Localizable.strings`.
     
     - returns: Pluralized localized string.
     */
    func localizedPlural(argument: CVarArg, using tableName: String?) -> String {
        return NSString.localizedStringWithFormat(localized(using: tableName) as NSString, argument) as String
    }
    
}
