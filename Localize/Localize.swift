//
//  Localize.swift
//  Localize
//
//  Created by Roy Marmelstein on 05/08/2015.
//  Copyright © 2015 Roy Marmelstein. All rights reserved.
//

import Foundation

/// Internal current language key
let LCLCurrentLanguageKey : String = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
let LCLDefaultLanguage : String = "en"

/// Name for language change notification
public let LCLLanguageChangeNotification : String = "LCLLanguageChangeNotification"

// MARK: Localization Syntax

/**
Swift 1.x friendly localization syntax, replaces NSLocalizedString
- Parameter string: Key to be localized.
- Returns: The localized string.
*/
public func Localized(string: String) -> String {
    if let path = NSBundle.mainBundle().pathForResource(Localize.currentLanguage(), ofType: "lproj"), bundle = NSBundle(path: path) {
        return bundle.localizedStringForKey(string, value: nil, table: nil)
    }
    return string
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
        return self
    }
}


// MARK: Language Setting Functions

public class Localize: NSObject {
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    public class func availableLanguages() -> [String] {
        return NSBundle.mainBundle().localizations
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    public class func currentLanguage() -> String {
        var currentLanguage : String = String()
        if ((NSUserDefaults.standardUserDefaults().objectForKey(LCLCurrentLanguageKey)) != nil){
            currentLanguage = NSUserDefaults.standardUserDefaults().objectForKey(LCLCurrentLanguageKey) as! String
        }
        else {
            currentLanguage = self.defaultLanguage()
        }
        return currentLanguage
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    public class func setCurrentLanguage(language: String) {
        var selectedLanguage: String = String()
        let availableLanguages : [String] = self.availableLanguages()
        if (availableLanguages.contains(language)) {
            selectedLanguage = language
        }
        else {
            selectedLanguage = self.defaultLanguage()
        }
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
    class func defaultLanguage() -> String {
        var defaultLanguage : String = String()
        let preferredLanguage = NSBundle.mainBundle().preferredLocalizations.first!
        let availableLanguages : [String] = self.availableLanguages()
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
        let currentLanguage : String = self.currentLanguage()
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage)
        let displayName = locale.displayNameForKey(NSLocaleLanguageCode, value: language)
        return displayName!
    }
}

