//
//  Localize.swift
//  Localize
//
//  Created by Roy Marmelstein on 05/08/2015.
//  Copyright © 2015 Roy Marmelstein. All rights reserved.
//

import Foundation

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
public func Localized(string: String) -> String {
    return string.localized()
}

/**
 Swift 1.x friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
 - Parameter string: Key to be localized.
 - Returns: The formatted localized string with arguments.
 */
public func Localized(string: String, arguments: CVarArgType...) -> String {
    return String(format: string.localized(), arguments: arguments)
}

/**
 Swift 1.x friendly plural localization syntax with a format argument
 
 - parameter string:   String to be formatted
 - parameter argument: Argument to determine pluralisation
 
 - returns: Pluralized localized string.
 */
public func LocalizedPlural(string: String, argument: CVarArgType) -> String {
    return string.localizedPlural(argument)
}


public extension String {
    /**
     Swift 2 friendly localization syntax, replaces NSLocalizedString
     - Returns: The localized string.
     */
    func localized() -> String {
        if let path = NSBundle.mainBundle().pathForResource(Localize.currentLanguage(), ofType: "lproj"), bundle = NSBundle(path: path) {
            return bundle.localizedStringForKey(self, value: nil, table: nil)
        }
        else if let path = NSBundle.mainBundle().pathForResource(LCLBaseBundle, ofType: "lproj"), bundle = NSBundle(path: path) {
            return bundle.localizedStringForKey(self, value: nil, table: nil)
        }
        return self
    }

    /**
     Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
     - Returns: The formatted localized string with arguments.
     */
    func localizedFormat(arguments: CVarArgType...) -> String {
        return String(format: localized(), arguments: arguments)
    }
    
    /**
     Swift 2 friendly plural localization syntax with a format argument
     
     - parameter argument: Argument to determine pluralisation
     
     - returns: Pluralized localized string.
     */
    func localizedPlural(argument: CVarArgType) -> String {
        return NSString.localizedStringWithFormat(localized(), argument) as String
    }
}



// MARK: Language Setting Functions

public class Localize: NSObject {
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    public class func availableLanguages(excludeBase: Bool = false) -> [String] {
        var availableLanguages = NSBundle.mainBundle().localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.indexOf("Base") where excludeBase == true {
            availableLanguages.removeAtIndex(indexOfBase)
        }
        return availableLanguages
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    public class func currentLanguage() -> String {
        if let currentLanguage = NSUserDefaults.standardUserDefaults().objectForKey(LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    public class func setCurrentLanguage(language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            NSUserDefaults.standardUserDefaults().setObject(selectedLanguage, forKey: LCLCurrentLanguageKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            NSNotificationCenter.defaultCenter().postNotificationName(LCLLanguageChangeNotification, object: nil)
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    public class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = NSBundle.mainBundle().preferredLocalizations.first else {
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
    public class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    public class func displayNameForLanguage(language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayNameForKey(NSLocaleLanguageCode, value: language) {
            return displayName
        }
        return String()
    }
}

