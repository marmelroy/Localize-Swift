//
//  DictionaryBrowserTableViewController.swift
//  Sample
//
//  Created by Vitalii Budnik on 3/10/16.
//  Copyright © 2016 Vitalii Budnik. All rights reserved.
//

import UIKit

private extension Array where Element: AnyObject {
  func indexedDictionary() -> [Int: Element] {
    var result: [Int: Element] = [:]
    for (index, element) in enumerate() {
      result[index] = element
    }
    return result
  }
  func indexedDictionary() -> [String: Element] {
    var result: [String: Element] = [:]
    for (index, element) in enumerate() {
      result["\(index)"] = element
    }
    return result
  }
}

class DictionaryBrowserTableViewController: UITableViewController {
  
  var bundle: NSBundle? = .None
  
  var dictionary = [String: AnyObject]() {
    didSet {
      unfilteredKeys = dictionary.keys.sort() { $0 < $1 }
    }
  }
  
  private var unfilteredKeys = [String]()
  
  private var filteredKeys = [String]()
  
  private (set) var searchController = UISearchController(searchResultsController: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.scopeButtonTitles = []
    searchController.searchBar.showsCancelButton = true
    searchController.searchBar.scopeButtonTitles = ["All", "Key", "Value"]
    searchController.searchBar.selectedScopeButtonIndex = 0
    
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
    
  }
  
  var searchIsActive: Bool {
    return searchController.active && !(searchController.searchBar.text ?? "").isEmpty
  }
  
  var searchText: String? {
    return searchIsActive ? searchController.searchBar.text : .None
  }
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  var keys: [String] {
    return searchIsActive ? filteredKeys : unfilteredKeys
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return keys.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell: UITableViewCell
    if let dequeCell = tableView.dequeueReusableCellWithIdentifier("DictionaryBrowserCell") {
      cell = dequeCell
    } else {
      cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "DictionaryBrowserCell")
    }
    
    let value = dictionary[keys[indexPath.row]]!
    switch value {
    case is [String: AnyObject]:
      cell.accessoryType = .DisclosureIndicator
      cell.detailTextLabel?.text = "dictionary"
      break
    case is [AnyObject]:
      cell.accessoryType = .DisclosureIndicator
      cell.detailTextLabel?.text = "array"
      break
    default:
      cell.accessoryType = .None
      switch value {
      case is String:
        cell.detailTextLabel?.text = value as? String
        break
      case is CustomStringConvertible:
        cell.detailTextLabel?.text = (value as? CustomStringConvertible)?.description
        break
      case is CustomDebugStringConvertible:
        cell.detailTextLabel?.text = (value as? CustomStringConvertible).debugDescription
        break
      default:
        cell.detailTextLabel?.text = "\(value)"
        break
      }
      break
    }
    
    
    
    cell.textLabel?.text = keys[indexPath.row]
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let value = dictionary[keys[indexPath.row]]!
    let controller: DictionaryBrowserTableViewController?
    //switch value {
    if let value = value as? [String: AnyObject] {
      let browser = DictionaryBrowserTableViewController(style: .Plain)
      browser.dictionary = value
      controller = browser
    } else if let value = value as? [AnyObject] {
      let browser = DictionaryBrowserTableViewController(style: .Plain)
      browser.dictionary = value.indexedDictionary()
      controller = browser
    } else {
      controller = .None
    }
    if let controller = controller {
      controller.title = keys[indexPath.row]
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
}

extension DictionaryBrowserTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
  
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterPresentedData(withText: searchBar.text, forScope: selectedScope)
  }
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    filterPresentedData(withText: searchController.searchBar.text, forScope: searchController.searchBar.selectedScopeButtonIndex)
  }
  
  func filterPresentedData(withText text: String?, forScope scope: Int) {
    
    let searchText = text?.lowercaseString ?? ""
    //
    let words = searchText.componentsSeparatedByString(" ").filter( { !$0.isEmpty })
    //
    if ((searchText.isEmpty && scope == 0) || words.count == 0) && (scope == 0) {
      filteredKeys = dictionary.keys.map( { $0 } )
      tableView.reloadData()
      return
    }
    
    filteredKeys = dictionary.flatMap({ (keyValue) -> String? in
      var acceptable: Bool = words.count == 0
      if scope == 0 || scope == 1 {
        acceptable = keyValue.0.lowercaseString.containsString(searchText)
      }
      if scope == 0 || scope == 2 {
        acceptable = (scope == 0 ? acceptable : false) || "\(keyValue.1)".lowercaseString.containsString(searchText)
      }
      return acceptable ? keyValue.0 : .None
    })
    
    
    tableView.reloadData()
  }
  
}
