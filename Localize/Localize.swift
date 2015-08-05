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


// MARK: Swift-friendly localization syntax

public func Localized(string: String) -> String {
    let path = NSBundle.mainBundle().pathForResource(Localize.currentLanguage(), ofType: "lproj")
    let bundle = NSBundle(path: path!)
    let string = bundle?.localizedStringForKey(string, value: nil, table: nil)
    return string!
}

// MARK: Language preferences

public class Localize: NSObject {
    
    public class func availableLanguages() -> [String] {
        return NSBundle.mainBundle().localizations as! [String]
    }
    
    public class func currentLanguage() -> String {
        var currentLanguage : String = String()
        if ((NSUserDefaults.standardUserDefaults().objectForKey(LCLCurrentLanguageKey)) != nil){
            currentLanguage = NSUserDefaults.standardUserDefaults().objectForKey(LCLCurrentLanguageKey) as! String
        }
        else {
            currentLanguage = defaultLanguage()
        }
        return currentLanguage
    }
    
    public class func setCurrentLanguage(language: String) {
        //    TODO: Assert here to check if valid string
        var selectedLanguage: String = String()
        let availableLanguages : [String] = Localize.availableLanguages()
        if (contains(availableLanguages, language)) {
            selectedLanguage = language
        }
        else {
            selectedLanguage = Localize.defaultLanguage()
        }
        NSUserDefaults.standardUserDefaults().setObject(selectedLanguage, forKey: LCLCurrentLanguageKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    class func defaultLanguage() -> String {
        var defaultLanguage : String = String()
        let preferredLanguage = NSBundle.mainBundle().preferredLocalizations.first! as! String
        let availableLanguages : [String] = Localize.availableLanguages()
        if (contains(availableLanguages, preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    public class func resetCurrentLanaguageToDefault() {
        setCurrentLanguage(defaultLanguage())
    }
}

