//
//  SampleBundleTests.swift
//  Sample
//
//  Created by Vitalii Budnik on 3/28/16.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import XCTest
import Foundation
import Localize_Swift

class SampleBundleTests: XCTestCase {
  
  private let foundationBundle: NSBundle = NSBundle(forClass: NSBundle.self)
  
  override func setUp() {
    super.setUp()
    Localize.resetCurrentLanguageToDefault()
  }
  
  func testSwift2Syntax() {
    let testString = "%@ remaining"
    
    Localize.setCurrentLanguage("fr")
    let translatedString = testString.localizedFormat(
      bundle: foundationBundle,
      tableName: "DurationFormatting",
      arguments: "1")
    
    XCTAssertEqual(translatedString, "Il reste 1")
    
  }
  
  func testMultipleLanguageSwitching() {
    let testString = "%@ remaining"
    
    Localize.setCurrentLanguage("es")
    
    var translatedString = testString.localizedFormat(
      bundle: foundationBundle,
      tableName: "DurationFormatting",
      arguments: "1")
    
    XCTAssertEqual(
      translatedString,
      "Falta(n) 1")
    
    Localize.setCurrentLanguage("de")
    
    translatedString = testString.localizedFormat(
      bundle: foundationBundle,
      tableName: "DurationFormatting",
      arguments: "1")
    
    XCTAssertEqual(
      translatedString,
      "Noch 1")
    
    Localize.resetCurrentLanguageToDefault()
    
    translatedString = testString.localizedFormat(
      bundle: foundationBundle,
      tableName: "DurationFormatting",
      arguments: "1")
    
    XCTAssertEqual(
      translatedString,
      "1 remaining")
  }
  
  func testFalseLanguage() {
    let testString = "%@ remaining"
    
    Localize.setCurrentLanguage("xxx")
    
    let translatedString = testString.localizedFormat(
      bundle: foundationBundle,
      tableName: "DurationFormatting",
      arguments: "1")
    
    XCTAssertEqual(
      translatedString,
      "1 remaining")
  }
  
  func testFalseLanguageAfterCorrectLanguage() {
    let testString = "%@ remaining"
    
    Localize.setCurrentLanguage("de")
    
    var translatedString = testString.localizedFormat(
      bundle: foundationBundle,
      tableName: "DurationFormatting",
      arguments: "1")
    
    XCTAssertEqual(
      translatedString,
      "Noch 1")
    
    Localize.setCurrentLanguage("xxx")
    
    translatedString = testString.localizedFormat(
      bundle: foundationBundle,
      tableName: "DurationFormatting",
      arguments: "1")
    
    XCTAssertEqual(
      translatedString,
      "1 remaining")
  }
  
  func testFalseString() {
    let testString = "%@ remaining..."
    Localize.setCurrentLanguage("fr")
    
    let translatedString = testString.localizedFormat(
      bundle: foundationBundle,
      tableName: "DurationFormatting",
      arguments: "1")
    
    XCTAssertEqual(
      translatedString,
      "1 remaining...")
  }
  
}