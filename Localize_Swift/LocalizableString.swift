//
//  LocalizableString.swift
//  Localize_Swift
//
//  Created by ToanTQ on 2021/06/11.
//  Copyright © 2021 Roy Marmelstein. All rights reserved.
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
