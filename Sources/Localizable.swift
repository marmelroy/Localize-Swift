//
//  Localizable.swift
//  Localize_Swift
//
//  Created by Vitalii Budnik on 3/10/16.
//  Copyright © 2016 Vitalii Budnik. All rights reserved.
//

import Foundation

public protocol Localizable {
  
  func localize()
  
}

public extension Localizable where Self: AnyObject {
  
  func addLanguageChangeObserver() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "localize", name: LCLLanguageChangeNotification, object: .None)
  }
  
  func removeLanguageChangeObserver() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: LCLLanguageChangeNotification, object: .None)
  }
  
}