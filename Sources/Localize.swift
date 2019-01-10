//
//  Localize.swift
//  Localize
//
//  Created by Roy Marmelstein on 05/08/2015.
//  Copyright © 2015 Roy Marmelstein. All rights reserved.
//

import Foundation
import UIKit

/// Internal current language key
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
let LCLDefaultLanguage = "en"

/// Base bundle as fallback.
let LCLBaseBundle = "Base"

/// Name for language change notification
public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"

// MARK: Localization Syntax

/**
 Swift 1.x friendly localization syntax, replaces NSLocalizedString
 - Parameter string: Key to be localized.
 - Returns: The localized string.
 */
public func Localized(_ string: String) -> String {
    return string.localized()
}

/**
 Swift 1.x friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
 - Parameter string: Key to be localized.
 - Returns: The formatted localized string with arguments.
 */
public func Localized(_ string: String, arguments: CVarArg...) -> String {
    return String(format: string.localized(), arguments: arguments)
}

/**
 Swift 1.x friendly plural localization syntax with a format argument
 
 - parameter string:   String to be formatted
 - parameter argument: Argument to determine pluralisation
 
 - returns: Pluralized localized string.
 */
public func LocalizedPlural(_ string: String, argument: CVarArg) -> String {
    return string.localizedPlural(argument)
}


public extension String {
    /**
     Swift 2 friendly localization syntax, replaces NSLocalizedString
     - Returns: The localized string.
     */
    func localized() -> String {
        return localized(using: nil, in: .main)
    }
    
    /**
     Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
     - Returns: The formatted localized string with arguments.
     */
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localized(), arguments: arguments)
    }
    
    /**
     Swift 2 friendly plural localization syntax with a format argument
     
     - parameter argument: Argument to determine pluralisation
     
     - returns: Pluralized localized string.
     */
    func localizedPlural(_ argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localized() as NSString, argument) as String
    }
}



// MARK: Language Setting Functions

open class Localize: NSObject {
    // Set appearnce language direction responsnding
    public static var changeSemantics = false {
        didSet{
            if #available(iOS 9.0, *) {
                setCurrentSemantics(currentLanguage)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.index(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
  
    
    
    /// get and set current language of the app via string, ex: "ar", "en", ... etc
    open class var currentLanguage: String {
        get {
            if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
                return currentLanguage
            }
            return defaultLanguage
        }set{
            let selectedLanguage = availableLanguages().contains(newValue) ? newValue : defaultLanguage
            if (selectedLanguage != currentLanguage){
                UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
                if #available(iOS 9.0, *) {
                    setCurrentSemantics(selectedLanguage)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
   
    
    @available(iOS 9.0, *)
    open class func setCurrentSemantics(_ language: String) {
        if changeSemantics {
            let direction = Locale.characterDirection(forLanguage: language)
            switch direction {
            case .rightToLeft:
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            case .leftToRight:
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            default:
                break
            }
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    open class var defaultLanguage: String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    /**
     Resets the current language to the default
     */
    open class func resetCurrentLanguageToDefault() {
        currentLanguage = self.defaultLanguage
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage)
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
}

