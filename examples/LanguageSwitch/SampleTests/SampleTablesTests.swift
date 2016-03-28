//
//  SampleTablesTests.swift
//  Sample
//
//  Created by Vitalii Budnik on 3/28/16.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import XCTest
import Localize_Swift

class SampleTablesTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    Localize.resetCurrentLanguageToDefault()
  }
  
  func testSwift2Syntax() {
    let testString = "Hello world";
    
    Localize.setCurrentLanguage("fr")
    let translatedString = testString.localized(tableName: "Greetings")
    XCTAssertEqual(translatedString, "Bonjour le monde")
    
  }
  
  func testMultipleLanguageSwitching() {
    let testString = "Hello world";
    
    Localize.setCurrentLanguage("es")
    XCTAssertEqual(
      testString.localized(tableName: "Greetings"),
      "Hola mundo")
    
    Localize.setCurrentLanguage("de")
    XCTAssertEqual(
      testString.localized(tableName: "Greetings"),
      "Hallo Welt")
    
    Localize.resetCurrentLanguageToDefault()
    XCTAssertEqual(
      testString.localized(tableName: "Greetings"),
      "Hello world")
  }
  
  func testFalseLanguage() {
    let testString = "Hello world";
    
    Localize.setCurrentLanguage("xxx")
    
    XCTAssertEqual(
      testString.localized(tableName: "Greetings"),
      "Hello world")
  }
  
  func testFalseLanguageAfterCorrectLanguage() {
    let testString = "Hello world";
    
    Localize.setCurrentLanguage("de")
    
    XCTAssertEqual(
      testString.localized(tableName: "Greetings"),
      "Hallo Welt")
    
    Localize.setCurrentLanguage("xxx")
    
    XCTAssertEqual(
      testString.localized(tableName: "Greetings"),
      "Hello world")
  }
  
  func testTableNameNotSet() {
    let testString = "Change";
    Localize.setCurrentLanguage("fr")
    
    XCTAssertEqual(
      testString.localized(tableName: .None),
      "Modifier")
  }
  
  func testFalseString() {
    let testString = "Non translated string";
    Localize.setCurrentLanguage("fr")
    
    XCTAssertEqual(
      testString.localized(tableName: "Greetings"),
      "Non translated string")
  }
  
}