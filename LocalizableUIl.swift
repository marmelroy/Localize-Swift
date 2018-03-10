//
//  LocalizableUIl.swift
//  Localize_Swift
//
//  Created by Prashant Tukadiya
//

import UIKit
import Localize_Swift



@IBDesignable class LocalizableLabel: UILabel {
    
    @IBInspectable var table :String?
    @IBInspectable var key:String?
    
    override func awakeFromNib() {
        guard let key = key else {return}
        self.text = key.localized(using: table)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
    }
    
    @objc func setText () {
        guard let key = key else {return}
        self.text = key.localized(using: table)

    }
    
}


@IBDesignable class LocalizableButton: UIButton {
    
    @IBInspectable var table :String?
    @IBInspectable var key:String?
    
    override func awakeFromNib() {
        guard let key = key else {return}
        self.setTitle(key.localized(using: "HomeScreen"), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
    }
    
    @objc func setText () {
        guard let key = key else {return}
        self.setTitle(key.localized(using: "HomeScreen"), for: .normal)

    }
    
}




