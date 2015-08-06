//
//  Localize.swift
//  Localize
//
//  Created by Roy Marmelstein on 05/08/2015.
//  Copyright © 2015 Roy Marmelstein. All rights reserved.
//

import Foundation

let LCLCurrentLanguageKey : String = "LCLCurrentLanguageKey"
let LCLDefaultLanguage : String = "en"

public let LCLLanguageChangeNotification : String = "LCLLanguageChangeNotification"

// MARK: Localization Syntax

// Swift-friendly localization syntax, replaces NSLocalizedString
public func Localized(string: String) -> String {
    let path = NSBundle.mainBundle().pathForResource(Localize.currentLanguage(), ofType: "lproj")
    let bundle = NSBundle(path: path!)
    let string = bundle?.localizedStringForKey(string, value: nil, table: nil)
    return string!
}

public func LocalizedWithFormat(string: String, args: CVarArgType...) -> String {
    let locale : NSLocale = NSLocale(localeIdentifier: Localize.currentLanguage())
    return withVaList(args) {
        NSString(format: string, locale: Localize.currentLanguage(), arguments: $0)
    } as String
}


// MARK: Language Setting Functions

public class Localize: NSObject {
    
    // Returns a list of available localizations
    public class func availableLanguages() -> [String] {
        return NSBundle.mainBundle().localizations as! [String]
    }
    
    // Returns the current language
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
    
    // Change the current language
    public class func setCurrentLanguage(language: String) {
        var selectedLanguage: String = String()
        let availableLanguages : [String] = self.availableLanguages()
        if (contains(availableLanguages, language)) {
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
    
    // Returns the app's default language
    class func defaultLanguage() -> String {
        var defaultLanguage : String = String()
        let preferredLanguage = NSBundle.mainBundle().preferredLocalizations.first! as! String
        let availableLanguages : [String] = self.availableLanguages()
        if (contains(availableLanguages, preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    // Resets the current language to the default
    public class func resetCurrentLanaguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    // Returns the app's full display name in the current language
    public class func displayNameForLanguage(language: String) -> String {
        var currentLanguage : String = self.currentLanguage()
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage)
        let displayName = locale.displayNameForKey(NSLocaleLanguageCode, value: language)
        return displayName!
    }
}

