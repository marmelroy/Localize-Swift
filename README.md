[![Platform](https://img.shields.io/cocoapods/p/Localize-Swift.svg?maxAge=2592000)](http://cocoapods.org/?q=Localize-Swift)
[![Build Status](https://travis-ci.org/marmelroy/Localize-Swift.svg?branch=master)](https://travis-ci.org/marmelroy/Localize-Swift) [![Version](http://img.shields.io/cocoapods/v/Localize-Swift.svg)](http://cocoapods.org/?q=Localize-Swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Localize-Swift
Localize-Swift is a simple framework that improves i18n and localization in Swift iOS apps - providing cleaner syntax and in-app language switching.

<p align="center"><img src="http://i.imgur.com/vsrpqBt.gif" width="242" height="425"/></p>

## Features

- Keep the Localizable.strings file your app already uses.
- Allow your users to change the app's language without changing their device language.
- Use .localized() instead of NSLocalizedString(key,comment) - a more Swifty syntax.
- Generate your strings with a new genstrings swift/python script that recognises .localized().

## Usage

Import Localize at the top of each Swift file that will contain localized text.

If CocoaPods -
```swift
import Localize_Swift
```

Add `.localized()` following any `String` object you want translated:
```swift
textLabel.text = "Hello World".localized()
```

To get an array of available localizations:
```swift
Localize.availableLanguages()
```

To change the current language:
```swift
Localize.setCurrentLanguage("fr")
```

To update the UI in the view controller where a language change can take place, observe LCLLanguageChangeNotification:
```swift
NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
```

To reset back to the default app language:
```swift
Localize.resetCurrentLanguageToDefault()
```

## genstrings

To support this new i18n syntax, Localize-Swift includes custom genstrings swift script.

Copy the genstrings.swift file into your project's root folder and run with

```bash
./genstrings.swift
```

This will print the collected strings in the terminal. Select and copy to your default Localizable.strings.

The script includes the ability to specify excluded directories and files (by editing the script).

### Setting up with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Localize-Swift into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "marmelroy/Localize-Swift"
```

### Setting up with [CocoaPods](http://cocoapods.org/?q=Localize-Swift)
```ruby
source 'https://github.com/CocoaPods/Specs.git'
pod 'Localize-Swift', '~> 1.7'
```
