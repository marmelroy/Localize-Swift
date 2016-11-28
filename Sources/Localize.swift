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

// MARK: Language Setting Functions

open class Localize: NSObject {
    
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
    
    /**
     Current language
     - Returns: The current language. String.
     */
    open class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    open class func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    open class func defaultLanguage() -> String {
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
        setCurrentLanguage(self.defaultLanguage())
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
}

