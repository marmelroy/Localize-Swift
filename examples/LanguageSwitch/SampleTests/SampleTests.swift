//
//  SampleTests.swift
//  SampleTests
//
//  Created by Roy Marmelstein on 26/09/2015.
//  Copyright © 2015 Roy Marmelstein. All rights reserved.
//

import XCTest
import Localize_Swift

class SampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Localize.resetCurrentLanguageToDefault()
    }
    
    func testSwift1Syntax() {
        let testString = "Change";
        Localize.setCurrentLanguage("fr")
        let translatedString = Localized(testString)
        XCTAssertEqual(translatedString, "Modifier")
    }
    
    func testSwift2Syntax() {
        let testString = "Change";
        Localize.setCurrentLanguage("fr")
        let translatedString = testString.localized()
        XCTAssertEqual(translatedString, "Modifier")
    }
    
    func testMultipleLanguageSwitching() {
        let testString = "Change";
        Localize.setCurrentLanguage("es")
        XCTAssertEqual(testString.localized(), "Cambiar")
        Localize.setCurrentLanguage("de")
        XCTAssertEqual(testString.localized(), "Ändern")
        Localize.resetCurrentLanguageToDefault()
        XCTAssertEqual(testString.localized(), "Change")
    }

    func testFalseLanguage() {
        let testString = "Change";
        Localize.setCurrentLanguage("xxx")
        XCTAssertEqual(testString.localized(), "Change")
    }
    
    func testFalseString() {
        let testString = "Non translated string";
        Localize.setCurrentLanguage("fr")
        XCTAssertEqual(testString.localized(), "Non translated string")
    }

    
}
