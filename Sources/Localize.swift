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
let AppleLanguagesKey = "AppleLanguages"

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
    open class func setCurrentLanguage(_ language: String, forcingRTL flag: Bool = false) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
        UserDefaults.standard.set([selectedLanguage], forKey: AppleLanguagesKey)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification),
                                        object: nil)
        Bundle.setLanguage(language, forcingRTL: flag)
    }
    
    /**
     Change the current language and Restart from the Root View Controller
     - Parameter language: Desired language.
     */
    open class func setCurrentLanguage(_ language: String, forcingRTL flag: Bool = false, restartingFromRoot rootViewController: UIViewController, animated: Bool = false) {
        self.setCurrentLanguage(language, forcingRTL: flag)
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
        
        if animated {
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            UIView.transition(with: mainwindow, duration: 0.5, options: .transitionFlipFromLeft,
                              animations: nil, completion: nil)
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    open class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Locale.current.languageCode else {
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
    open class func resetCurrentLanguageToDefault(forcingRTL flag: Bool = false) {
        self.setCurrentLanguage(self.defaultLanguage(), forcingRTL: flag)
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: self.currentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
}


extension UILabel {
    
    var originalAligment: NSTextAlignment {
        get {
            switch self.tag {
            case 989796:
                return .center
            case 232425:
                return .justified
            case 757677:
                return .left
            case 343332:
                return .right
            case 616365:
                return .natural
            default:
                return .justified
            }
        }
        set {
            switch newValue {
            case .center:
                self.tag = 989796
            case .justified:
                self.tag = 232425
            case .left:
                self.tag = 757677
            case .right:
                self.tag = 343332
            case .natural:
                self.tag = 616365
            }
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.originalAligment = self.textAlignment
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.isKind(of: NSClassFromString("UITextFieldLabel")!) {
            return // handle special case with uitextfields
        }
        if Localize.currentLanguage() == "ar" {
            if self.originalAligment != .center {
                self.textAlignment = self.originalAligment == .right ? .left : .right
            }
        } else {
            if self.originalAligment != .center || self.originalAligment != .justified {
                self.textAlignment = self.originalAligment
            }
        }
    }
}
