//
//  String+Localize.swift
//  Localize_Swift
//
//  Created by Vitalii Budnik on 10/7/16.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

/// Localize extension
public extension String {
    /**
     Swift 2 friendly localization syntax, replaces NSLocalizedString.
     - returns: The localized string.
     */
    func localized() -> String {
        return localized(using: nil, in: .main)
    }
    
    /**
     Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString).
     - returns: The formatted localized string with arguments.
     */
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localized(), arguments: arguments)
    }
    
    /**
     Swift 2 friendly plural localization syntax with a format argument.
     
     - parameter argument: Argument to determine pluralisation.
     
     - returns: Pluralized localized string.
     */
    func localizedPlural(_ argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localized() as NSString, argument) as String
    }
}
