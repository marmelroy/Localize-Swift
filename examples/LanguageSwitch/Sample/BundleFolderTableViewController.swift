//
//  BundleFolderTableViewController.swift
//  Sample
//
//  Created by Vitalii Budnik on 3/10/16.
//  Copyright © 2016 Vitalii Budnik. All rights reserved.
//

import UIKit

private let supportedDictionaryExtensions = ["plist", "strings"]

private extension NSURL {
  var dictionaryFileExtensionSupported: Bool {
    guard let pathExtension = pathExtension else { return false }
    return supportedDictionaryExtensions.contains(pathExtension)
  }
}

class BundleFolderTableViewController: UITableViewController {
  
  var bundle: NSBundle? = .None
  
  var url: NSURL? = .None {
    didSet {
      if let url = url {
        _urls = try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(url, includingPropertiesForKeys: .None, options: [])
      } else {
        _urls = .None
      }
    }
  }
  private var _urls: [NSURL]? = .None
  private var urls: [NSURL] {
    return _urls ?? []
  }
  private var isAssetsFile: Bool = false
  
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return urls.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    if let dequeCell = tableView.dequeueReusableCellWithIdentifier("LocalizationPaths") {
      cell = dequeCell
    } else {
      cell = UITableViewCell(style: .Default, reuseIdentifier: "LocalizationPaths")
    }
    
    let url = urls[indexPath.row]
    
    cell.textLabel?.text = url.lastPathComponent
    
    var isDirectory: ObjCBool = ObjCBool(false)
    if NSFileManager.defaultManager().fileExistsAtPath(urls[indexPath.row].path ?? "", isDirectory: &isDirectory) {
      if isDirectory.boolValue {
        cell.accessoryType = .DisclosureIndicator
      } else {
        if url.dictionaryFileExtensionSupported {
          cell.accessoryType = .DetailDisclosureButton
        } else {
          cell.accessoryType = .None
        }
      }
    }
    
    return cell
    
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let url = urls[indexPath.row]
    var isDirectory: ObjCBool = ObjCBool(false)
    guard NSFileManager.defaultManager().fileExistsAtPath(url.path ?? "", isDirectory: &isDirectory) else { return }
    
    if isDirectory.boolValue {
      let bundleFolderBrowser = BundleFolderTableViewController(style: .Plain)
      
      bundleFolderBrowser.url = url
      bundleFolderBrowser.title = url.lastPathComponent
      
      if url.pathExtension == "bundle" {
        if let b = NSBundle(URL: url) {
          bundleFolderBrowser.bundle = b
        } else {
          bundleFolderBrowser.bundle = bundle
        }
      } else {
        bundleFolderBrowser.bundle = bundle
      }
      
      navigationController?.pushViewController(bundleFolderBrowser, animated: true)
      
    } else if url.dictionaryFileExtensionSupported {
      if let dictionry = NSDictionary(contentsOfURL: url) as? [String: AnyObject] {
        let dictionaryBrowser = DictionaryBrowserTableViewController(style: .Plain)
        
        dictionaryBrowser.bundle = bundle
        dictionaryBrowser.dictionary = dictionry
        dictionaryBrowser.title = url.lastPathComponent
        
        navigationController?.pushViewController(dictionaryBrowser, animated: true)
        
      }
    }
    
  }
  
  
}