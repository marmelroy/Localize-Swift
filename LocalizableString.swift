//
//  LocalizableString.swift
//  Localize-Swift
//
//  Created by ToanTQ on 2021/06/11.
//

import Foundation

@propertyWrapper
public struct LocalizableString {
    public var value: String
    
    public init(wrappedValue value: String) {
        self.value = value
    }
    
    public var wrappedValue: String {
        get { value.localized() }
        set { value = newValue }
    }
}
