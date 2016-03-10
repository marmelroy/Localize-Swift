//
//  ViewController.swift
//  Sample
//
//  Created by Roy Marmelstein on 05/08/2015.
//  Copyright (c) 2015 Roy Marmelstein. All rights reserved.
//

import UIKit
import Localize_Swift

class ViewController: UIViewController, Localizable {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    var actionSheet: UIAlertController!
    
    let availableLanguages = Localize.availableLanguages()
    
    // MARK: UIViewController
    
    /* Add an observer for LCLLanguageChangeNotification on viewDidLoad. This is posted whenever a language changes and allows the viewcontroller to make the necessary UI updated. Very useful for places in your app when a language change might happen.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        addLanguageChangeObserver()
        localize()
    }
    
    // Remove the LCLLanguageChangeNotification on deinit
    deinit {
        removeLanguageChangeObserver()
    }
    
    // MARK: Localized Text
    
    func localize() {
        textLabel.text = "Hello world".localized();
        changeButton.setTitle("Change".localized(), forState: UIControlState.Normal)
        resetButton.setTitle("Reset".localized(), forState: UIControlState.Normal)
        
        configureToolBar()
    }
    
    private let uiKitBundle = NSBundle(forClass: UIBarButtonItem.self)
    
    func configureToolBar() {
        
        let localizedDoneButtonTitle = "Done".localized(bundle: uiKitBundle)
        
        //
        let doneBarButton = UIBarButtonItem(title: "Done", style: .Done, target: .None, action: "doneBarButtonPressed")
        doneBarButton.possibleTitles = Set.init(arrayLiteral: localizedDoneButtonTitle, "Done")
        doneBarButton.title = localizedDoneButtonTitle
        
        // System item with predefined title
        let newCancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: .None, action: "cancelBarButtonPressed")
        
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: "flexibleSpaceAction")
        
        toolBar.items = [doneBarButton, space, newCancelButton]
    }
    
    // MARK: IBActions
    
    @IBAction func doChangeLanguage(sender: AnyObject) {
        actionSheet = UIAlertController(title: nil, message: "Switch Language", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let enLocale = NSLocale(localeIdentifier: "en")
        let currentLanguage = Localize.language
        
        for language in availableLanguages {
            let localizedDisplayName = Localize.displayNameForLanguage(language)
            
            let enDisplayName = enLocale.displayNameForKey(NSLocaleLanguageCode, value: language) ?? language
            
            let displayName = localizedDisplayName +
                (currentLanguage == "en" ? "" : " (\(enDisplayName))")
            
            let languageAction = UIAlertAction(title: displayName, style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                Localize.setCurrentLanguage(language)
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(bundle: uiKitBundle), style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func doResetLanguage(sender: AnyObject) {
        Localize.resetCurrentLanguageToDefault()
    }
}

