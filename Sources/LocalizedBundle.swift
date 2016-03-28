//
//  LocalizedBundle.swift
//  Localize_Swift
//
//  Created by Vitalii Budnik on 3/10/16.
//  Copyright © 2016 Vitalii Budnik. All rights reserved.
//

import Foundation

public class LocalizedBundle: NSBundle {
  
  private static var kBundleKey = "LocalizedNSBundle"
  
  override public func localizedStringForKey(
    key: String,
    value: String?,
    table tableName: String?)
    -> String
  {
    // if bundle successfully localized - we have associated object
    if let bundle = objc_getAssociatedObject(self, &LocalizedBundle.kBundleKey) as? NSBundle {
      return bundle.localizedStringForKey(key, value: value, table: tableName)
    
    // otherwise we call super
    } else {
      return super.localizedStringForKey(key, value: value, table: tableName)
    }
  }
  
  deinit {
    objc_removeAssociatedObjects(self)
  }
  
}

private extension NSLocale {
  
  private func localeIdentifierDisplayName(language: String) -> String? {
    return displayNameForKey(NSLocaleIdentifier, value: language)
  }
  
}

internal extension NSBundle {
  
  private static var dispatchOnceToken: dispatch_once_t = 0
  
  /// List of localizable bundles
  private static var localizableBundles: [NSBundle]!
  
  /// English locale for locale identifier display name
  /// Some frameworks have English.lproj (French.lproj), not en.lproj (fr.lproj)
  private static var enLocale: NSLocale = {
    return NSLocale(localeIdentifier: "en")
  }()
  
  /// Localize bundle
  /// - Parameter language: Desired language.
  private func setLanguage(language: String) {
    
    let localeComponents = NSLocale.componentsFromLocaleIdentifier(language)
    let languageCode = localeComponents[NSLocaleLanguageCode] ?? language
    
    /// list of possible .lproj folders names
    let lprojFolderPatterns: [String?] = [
      language, // en-GB.lproj
      language.stringByReplacingOccurrencesOfString("-", withString: "_"), // en_GB.lproj
      (languageCode != language) ? languageCode : nil, // en.lproj
      NSBundle.enLocale.localeIdentifierDisplayName(languageCode) // English.lproj
    ]
    
    /// Available folders in bundle
    let lprojFoldersPaths: [String] = lprojFolderPatterns.flatMap {
      if let folderName = $0,
        path = pathForResource(folderName, ofType: "lproj") {
        return path
      } else {
        return nil
      }
    }
    
    let localizedBundlePath = lprojFoldersPaths.first
    
    // Getting localized bundle
    let localizedBudnle: NSBundle?
    if let localizedBundlePath = localizedBundlePath {
      localizedBudnle = NSBundle(path: localizedBundlePath)
    } else {
      localizedBudnle = .None
    }
    
    // Setting associated object for bundle
    objc_setAssociatedObject(
      self,
      &LocalizedBundle.kBundleKey,
      localizedBudnle,
      .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    
  }
  
  private func localizable() -> Bool {
    return !pathsForResourcesOfType("lproj", inDirectory: .None).isEmpty
  }
  
  /// Localize Bundles
  /// - Parameter language: Desired language.
  internal class func setLanguage(language: String) {
    
    dispatch_once(&dispatchOnceToken) {
      
      // List of localizable bundles
      var localizableBundles = [NSBundle]()
      
      // Localizable main bundle
      let mainBundle = NSBundle.mainBundle()
      if mainBundle.localizable() {
        // Overriding class
        object_setClass(mainBundle, LocalizedBundle.self)
        
        localizableBundles.append(mainBundle)
      }
      
      // Localizable frameworks
      NSBundle.allFrameworks().forEach { (bundle) -> () in
        if bundle.localizable() {
          // Overriding class
          object_setClass(bundle, LocalizedBundle.self)
          
          localizableBundles.append(bundle)
        }
      }
      
      // Localizable non-framework bundles
      NSBundle.allBundles().forEach { (bundle) -> () in
        if bundle.localizable() {
          object_setClass(bundle, LocalizedBundle.self)
          
          localizableBundles.append(bundle)
        }
      }
      
      NSBundle.localizableBundles = localizableBundles
      
    }
    
    // Setting language for all available for localization bundles
    NSBundle.localizableBundles.forEach { $0.setLanguage(language) }
    
  }
}
