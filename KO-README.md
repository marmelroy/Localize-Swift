[![Platform](https://img.shields.io/cocoapods/p/Localize-Swift.svg?maxAge=2592000)](http://cocoapods.org/?q=Localize-Swift)
[![Version](http://img.shields.io/cocoapods/v/Localize-Swift.svg)](http://cocoapods.org/?q=Localize-Swift)
[![Build Status](https://travis-ci.org/marmelroy/Localize-Swift.svg?branch=master)](https://travis-ci.org/marmelroy/Localize-Swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

[![jaywcjlove/sb](https://jaywcjlove.github.io/sb/lang/chinese.svg)](README-zh.md)

# Localize-Swift
Localize-Swift는 Swift iOS앱에서 i18n과 현지화를 향상시키는 간단한 프레임워크입니다 - 더 깔끔한 문법과 앱 내 언어 전환을 지원합니다.

<p align="center"><img src="http://i.imgur.com/vsrpqBt.gif" width="242" height="425"/></p>

## 특징

- 이미 사용중인 Localizable.strings 파일을 그대로 두세요.
- 여러분의 유저들이 기기 자체 언어를 바꾸지 않고 앱 내 언어를 전환할 수 있도록 합니다.
- NSLocalizedString(key,comment) 대신 .localized() 함수를 사용합니다. - 더 빠른 문법을 제공합니다.
- .localized()를 인식하는 새로운 genstrings swift/python 스크리ㅂ트로 String을 생성하세요.

## 사용

지역화된 텍스트를 포함할 Swift 파일 최상단에 Localize를 Import 합니다.

If CocoaPods -
```swift
import Localize_Swift
```

번역하기 원하는 `String` 오브젝트 뒤에 `.localized()`를 추가하세요:
```swift
textLabel.text = "Hello World".localized()
```

가능한 현지화 목록 배열을 가져오는 방법:
```swift
Localize.availableLanguages()
```

현재 언어를 바꾸는 방법:
```swift
Localize.setCurrentLanguage("fr")
```

언어가 변경될 수 있는 view controller 내부에서 UI를 갱신 하려면, LCLLanguageChangeNotification를 observe 하세요:
```swift
NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
```

기본 앱 언어로 되돌리기:
```swift
Localize.resetCurrentLanguageToDefault()
```

## genstrings

이 새로운 i18n 문법을 지원하기 위해, Localize-Swift는 커스텀 genstrings swift 스크립트를 포함합니다.

genstrings.swift 파일을 프로젝트 루트 폴더에 복사하고 실행하세요.

```bash
./genstrings.swift
```

이렇게 하면 수집된 문자열이 터미널에 표시됩니다. 디폴트 Localizable.strings 파일을 선택하고 복사하세요.

script는 (스크립트를 수정하는 것으로) 제외된 디렉토리 및 파일을 지정할 수 있는 기능을 포함합니다.

### Carthage 설정

[Carthage](https://github.com/Carthage/Carthage) 는 Cocoa 어플리케이션에 프레임워크를 추가하는 과정을 자동화해주는 분산형 dependency 관리자입니다.

[Homebrew](http://brew.sh/)로 다음 명령어를 사옹해 Carthage를 설치할 수 있습니다:

```bash
$ brew update
$ brew install carthage
```

Carthage를 사옹해 Localize-Swift를 Xcode 프로젝트에 통합시키기 위해서,`Cartfile`:

```ogdl
github "marmelroy/Localize-Swift"
```

### [CocoaPods](http://cocoapods.org/?q=Localize-Swift)로 설정하기
```ruby
source 'https://github.com/CocoaPods/Specs.git'
pod 'Localize-Swift', '~> 2.0'
```
