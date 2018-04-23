//
//  CodeViewController.swift
//  Sample
//
//  Created by Roy Marmelstein on 05/08/2015.
//  Copyright (c) 2015 Roy Marmelstein. All rights reserved.
//

import UIKit
import Localize_Swift

class StoryboardViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var actionSheet: UIAlertController!
    
    let availableLanguages = Localize.availableLanguages(true)
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBActions

    @IBAction func doChangeLanguage(_ sender: AnyObject) {
        actionSheet = UIAlertController(title: nil, message: "Switch Language", preferredStyle: UIAlertControllerStyle.actionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                Localize.setCurrentLanguage(language)

                let storyboard = UIStoryboard(name: "Main", bundle: nil)

                // Option 1:
                /*let rootViewController = storyboard.instantiateInitialViewController()!
                Localize.setCurrentLanguage(language, restartFromRoot: rootViewController)*/
                
                // Option 2:
                let chooseViewController = storyboard.instantiateViewController(withIdentifier: "chooseViewController")
                self.navigationController?.setViewControllers([chooseViewController], animated: true)
                
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func doResetLanguage(_ sender: AnyObject) {
        Localize.resetCurrentLanguageToDefault()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Option 1:
        /*let rootViewController = storyboard.instantiateInitialViewController()!
         Localize.setCurrentLanguage(language, restartFromRoot: rootViewController)*/
        
        // Option 2:
        let chooseViewController = storyboard.instantiateViewController(withIdentifier: "chooseViewController")
        self.navigationController?.setViewControllers([chooseViewController], animated: true)
    }
}

