//
//  LocalizableBundlesTableViewController.swift
//  Sample
//
//  Created by Vitalii Budnik on 3/10/16.
//  Copyright © 2016 Vitalii Budnik. All rights reserved.
//

import UIKit

class LocalizableBundlesTableViewController: UITableViewController {
  
  var frameworks = NSBundle.allFrameworks()
    .flatMap({ $0.pathsForResourcesOfType("lproj", inDirectory: .None).isEmpty
      ? .None
      : $0})
    .sort( { $0.bundleIdentifier < $1.bundleIdentifier } )
  var bundles = NSBundle.allBundles()
    .flatMap({ $0.pathsForResourcesOfType("lproj", inDirectory: .None).isEmpty
      ? .None
      : $0})
    .sort( { $0.bundleIdentifier < $1.bundleIdentifier } )
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Frameworks"
    case 1:
      return "Bundles"
    default:
      return .None
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return frameworks.count
    case 1:
      return bundles.count
    default:
      return 0
    }
  }
  
  func sourceForSection(section: Int) -> [NSBundle] {
    let source: [NSBundle]
    switch section {
    case 0:
      source = frameworks
    case 1:
      source = bundles
    default:
      return []
    }
    return source
  }
  
  func bundleForIndexPath(indexPath: NSIndexPath) -> NSBundle {
    let source = sourceForSection(indexPath.section)
    return source[indexPath.row]
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("NSBundle", forIndexPath: indexPath)
    
    
    
    let bundle = sourceForSection(indexPath.section)[indexPath.row]
    
    cell.textLabel?.text = bundle.bundleIdentifier
    cell.detailTextLabel?.text = bundle.bundlePath
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let bundle = bundleForIndexPath(indexPath)
    
    let bundleFolderController = BundleFolderTableViewController()
    bundleFolderController.url = bundle.bundleURL
    bundleFolderController.bundle = bundle
    bundleFolderController.title = bundle.bundleIdentifier
    
    navigationController?.pushViewController(bundleFolderController, animated: true)
    
  }
  
}

