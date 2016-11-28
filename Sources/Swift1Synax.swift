//
//  Swift1Synax.swift
//  Localize_Swift
//
//  Created by Vitalii Budnik on 10/7/16.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

// MARK: Localization Syntax

/**
 Swift 1.x friendly localization syntax, replaces NSLocalizedString
 - Parameter string: Key to be localized.
 - Returns: The localized string.
 */
@available(*, deprecated: 1.8.0, message: "Use String `.localized()` method instead. Will be removed in 1.9.")
public func Localized(_ string: String) -> String {
    return string.localized()
}

/**
 Swift 1.x friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
 - Parameter string: Key to be localized.
 - Returns: The formatted localized string with arguments.
 */
@available(*, deprecated: 1.8.0, message: "Use String `.localizedFormat()` method instead. Will be removed in 1.9.")
public func Localized(_ string: String, arguments: CVarArg...) -> String {
    return String(format: string.localized(), arguments: arguments)
}

/**
 Swift 1.x friendly plural localization syntax with a format argument
 
 - parameter string:   String to be formatted
 - parameter argument: Argument to determine pluralisation
 
 - returns: Pluralized localized string.
 */
@available(*, deprecated: 1.8.0, message: "Use String `.localizedPlural()` method instead. Will be removed in 1.9.")
public func LocalizedPlural(_ string: String, argument: CVarArg) -> String {
    return string.localizedPlural(argument)
}
