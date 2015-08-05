//
//  Localize.swift
//  Localize
//
//  Created by Roy Marmelstein on 05/08/2015.
//  Copyright © 2015 Roy Marmelstein. All rights reserved.
//

import Foundation
import CoreFoundation

let LCLCurrentLanguageKey : String = "LCLCurrentLanguageKey"
let LCLDefaultLanguage : String = "en"


// MARK: Swift-friendly localization syntax

public func Localized(string: String) -> String {
    return NSLocalizedString(string, comment:"")
}

// MARK: Language preferences

public func availableLanguages() -> [String] {
    return NSBundle.mainBundle().localizations
}

public func currentLanguage() -> String {
    var currentLanguage : String = String()
    if ((NSUserDefaults.standardUserDefaults().objectForKey(LCLCurrentLanguageKey)) != nil){
        currentLanguage = NSUserDefaults.standardUserDefaults().objectForKey(LCLCurrentLanguageKey) as! String
    }
    else {
        currentLanguage = defaultLanguage()
    }
    return currentLanguage
}

public func setCurrentLanaguage(language: String) {
//    TODO: Assert here to check if valid string
    var selectedLanguage: String = String()
    if (availableLanguages().contains(language)) {
        selectedLanguage = language
    }
    else {
        selectedLanguage = defaultLanguage()
    }
    NSUserDefaults.standardUserDefaults().setObject(selectedLanguage, forKey: LCLCurrentLanguageKey)
    NSUserDefaults.standardUserDefaults().synchronize()

}

func defaultLanguage() -> String {
    var defaultLanguage : String = String()
    let preferredLanguage = NSBundle.mainBundle().preferredLocalizations.first!
    if (availableLanguages().contains(defaultLanguage)) {
        defaultLanguage = preferredLanguage
    }
    else {
        defaultLanguage = LCLDefaultLanguage
    }
    return defaultLanguage
}

public func resetCurrentLanaguageToDefault() {
    setCurrentLanaguage(defaultLanguage())
}

// MARK: NSLocalizedString Override

class Foundation {
    func NSLocalizedString(key: String, comment: String) -> String {
        let path = NSBundle.mainBundle().pathForResource(currentLanguage(), ofType: "lproj")
        let bundle = NSBundle(path: path!)
        let string = bundle?.localizedStringForKey(key, value: nil, table: nil)
        return string!
    }
}



