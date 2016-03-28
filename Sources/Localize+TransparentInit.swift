//
//  Localize+TransparentInit.swift
//  Localize_Swift
//
//  Created by Vitalii Budnik on 3/10/16.
//  Copyright © 2016 Vitalii Budnik. All rights reserved.
//

import Foundation

public extension Localize {
  
  private static var _language: String?
  
  /// Current language
  public internal (set) static var language: String {
    get {
    
      if let language = _language {
        return language
      }
      
      let savedLanguage: String
    
      if let currentLanguage = NSUserDefaults.standardUserDefaults().objectForKey(LCLCurrentLanguageKey) as? String {
        savedLanguage = currentLanguage
      } else {
        savedLanguage = defaultLanguage()
      }
    
      _language = savedLanguage
    
      // Localize UserDefaults AppleLanguages key
      localizeUserDefaultsLanguages(savedLanguage)
      
      // Localize Bundles
      NSBundle.setLanguage(savedLanguage)
    
      return savedLanguage
      
    }
    
    set {
      _language = newValue
    }
    
  }
}