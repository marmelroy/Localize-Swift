//
//  ViewController.swift
//  Sample
//
//  Created by Roy Marmelstein on 05/08/2015.
//  Copyright (c) 2015 Roy Marmelstein. All rights reserved.
//

import UIKit
import Localize

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var actionSheet: UIAlertController!
    
    let availableLanguages = Localize.availableLanguages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setText()
    }
    
    func setText(){
        textLabel.text = Localized("Hello world");
        changeButton.setTitle(Localized("Change"), forState: UIControlState.Normal)
        resetButton.setTitle(Localized("Reset"), forState: UIControlState.Normal)
    }

    @IBAction func doChangeLanguage(sender: AnyObject) {
        actionSheet = UIAlertController(title: nil, message: "Switch Language", preferredStyle: UIAlertControllerStyle.ActionSheet)
        for language in availableLanguages {
            let displayName = language
            let languageAction = UIAlertAction(title: displayName, style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                    Localize.setCurrentLanguage(language)
                    self.setText()
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }

    @IBAction func doResetLanguage(sender: AnyObject) {
        Localize.resetCurrentLanaguageToDefault()
        self.setText()
    }
}

