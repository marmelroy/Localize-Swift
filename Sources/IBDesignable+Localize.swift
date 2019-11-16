//
//  IBDesignable+Localize1.swift
//  Localize-Swift
//
//  Created by BinaryBoy on 7/23/19.
//

import Foundation

// MARK: - UILabel localize Key extention for language in story board

@IBDesignable public extension UILabel {
    @IBInspectable var localizeKey: String? {
        set {
            // set new value from dictionary
            DispatchQueue.main.async {
                self.text = newValue?.localized()
            }
        }
        get {
            return self.text
        }
    }
}

// MARK: - UIButton localize Key extention for language in story board

@IBDesignable public extension UIButton {

    @IBInspectable var localizeKey: String? {
        set {
            // set new value from dictionary
            DispatchQueue.main.async {
                self.setTitle(newValue?.localized(), for: .normal)
            }
        }
        get {
            return self.titleLabel?.text
        }
    }
}

// MARK: - UITextView localize Key extention for language in story board

@IBDesignable public extension UITextView {

    @IBInspectable var localizeKey: String? {
        set {
            // set new value from dictionary
            DispatchQueue.main.async {
                self.text = newValue?.localized()
            }
        }
        get {
            return self.text
        }
    }
}

// MARK: - UITextField localize Key extention for language in story board

@IBDesignable public extension UITextField {
    @IBInspectable var localizeKey: String? {
        set {
            // set new value from dictionary
            DispatchQueue.main.async {
                self.placeholder = newValue?.localized()
            }
        }
        get {
            return self.placeholder
        }
    }
}

// MARK: - UINavigationItem localize Key extention for language in story board

@IBDesignable public extension UINavigationItem {

    @IBInspectable var localizeKey: String? {
        set {
            // set new value from dictionary
            DispatchQueue.main.async {
                self.title = newValue?.localized()
            }
        }
        get {
            return self.title
        }
    }
}
