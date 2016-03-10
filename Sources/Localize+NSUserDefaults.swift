//
//  Localize+NSUserDefaults.swift
//  Localize_Swift
//
//  Created by Vitalii Budnik on 3/10/16.
//  Copyright © 2016 Vitalii Budnik. All rights reserved.
//

import Foundation

/// NSUserDefaults. Restores setted language after realunch
internal extension Localize {
  
  private class func isCurrentLanguageRightToLeft() -> Bool {
    return NSLocale.characterDirectionForLanguage(currentLanguage()) == NSLocaleLanguageDirection.RightToLeft
  }
  
  /// Localize UserDefaults AppleLanguages key
  /// - Parameter language: Desired language.
  internal class func localizeUserDefaultsLanguages(language: String) {
    
    let newLanguages: [String]
    
    /// Contains available languages (with locales?): ["en", "en-uk"]
    let appleLanguages = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages")
    
    if var currentLanguages = appleLanguages as? [String] {
      
      let currentLocaleIdentifier = NSLocale.currentLocale().localeIdentifier
      let currentLocaleComponents = NSLocale.componentsFromLocaleIdentifier(currentLocaleIdentifier)
      
      let countryCode = currentLocaleComponents[NSLocaleCountryCode]
      
      let localedLanguage: String
      if let countryCode = countryCode {
        localedLanguage = language + "-" + countryCode
      } else {
        localedLanguage = language
      }
      
      // search for languages with locale at first
      if let index = currentLanguages.indexOf(localedLanguage) where index != 0 {
        currentLanguages.removeAtIndex(index)
        currentLanguages.insert(localedLanguage, atIndex: 0)
      } else if let index = currentLanguages.indexOf(language) where index != 0 {
        currentLanguages.removeAtIndex(index)
        currentLanguages.insert(language, atIndex: 0)
      }
      
      newLanguages = currentLanguages
      
    } else {
      newLanguages = [language]
    }
    
    //
    NSUserDefaults.standardUserDefaults()
      .setObject(newLanguages, forKey: "AppleLanguages")
    
    // Right-to-Left Layouts
    // https://developer.apple.com/library/ios/documentation/MacOSX/Conceptual/BPInternational/TestingYourInternationalApp/TestingYourInternationalApp.html#//apple_ref/doc/uid/10000171i-CH7-SW5
    
    let currentLanguageIsRightToLeft = self.isCurrentLanguageRightToLeft()
    
    NSUserDefaults.standardUserDefaults()
      .setBool(currentLanguageIsRightToLeft, forKey: "AppleTextDirection")
    
    NSUserDefaults.standardUserDefaults()
      .setBool(currentLanguageIsRightToLeft, forKey: "NSForceRightToLeftWritingDirection")
    
    NSUserDefaults.standardUserDefaults().synchronize()
    
  }
  
}