#!/usr/bin/swift

import Foundation

class GenStrings {

    var str = "Hello, playground"
    let fileManager = FileManager.default
    let acceptedFileExtensions = ["swift"]
    let excludedFolderNames = ["Carthage"]
    let excludedFileNames = ["genstrings.swift"]
    var regularExpresions = [String:NSRegularExpression]()

    let localizedRegex = "(?:\")([^\"]*)(?:\".(?:localized|localizedFormat))(?:\\()(?:(?:\")([^\"]*)(?:\"))?(?:\\))|(?<=(Localized|NSLocalizedString)\\(\")([^\"]*?)(?=\")"

    enum GenstringsError: Error {
        case Error
    }

    // Performs the genstrings functionality
    func perform(path: String? = nil) {
        let directoryPath = path ?? fileManager.currentDirectoryPath
        let rootPath = URL(fileURLWithPath:directoryPath)
        let allFiles = fetchFilesInFolder(rootPath: rootPath)
        var localizableStrings = [String:[String]]()
        for filePath in allFiles {
            let stringsInFile = localizableStringsInFile(filePath: filePath)
            for (key, value) in stringsInFile {
                if localizableStrings[key] == nil {
                    // Given localization doesn't exist
                    localizableStrings[key] = value
                } else {
                    // Given localization already exists
                    for comment in value {
                        // Make sure comments are not repeated
                        if !localizableStrings[key]!.contains(comment) {
                            localizableStrings[key]!.append(comment)
                        }
                    }
                }
            }
        }
        // We sort the strings (we are guaranteed to have at least one element per localizable string)
        let sortedStrings = Array(localizableStrings.keys).sorted(by:<)
        var processedStrings = String()
        for orderedKey in sortedStrings {
            // We are guaranteed to have at least an empty array
            let comments = localizableStrings[orderedKey]!
            if comments.count == 0 {
                // Localization without comment
                processedStrings.append("\"\(orderedKey)\" = \"\(orderedKey)\"; \n")
            } else if comments.count > 0 {
                // Localization with comments
                processedStrings.append("/* ")
                var first = true
                comments.forEach({
                        // Concatenate comments with cute formatting
                        if first {
                            processedStrings.append("\($0)")
                            first = false
                        } else {
                            processedStrings.append("\n   \($0)")
                        }
                        
                    })
                processedStrings.append(" */\n")
                processedStrings.append("\"\(orderedKey)\" = \"\(orderedKey)\"; \n")
            } else {
                // We shouldn't get more than 2 items, but if we do, we ignore the entry for safety
            }
        }
        print(processedStrings)
    }

    // Applies regex to a file at filePath.
    func localizableStringsInFile(filePath: URL) -> [String:[String]] {
        var localizedElementsArray = [String:[String]]()
        do {
            let fileContentsData = try Data(contentsOf: filePath)
            guard let fileContentsString = NSString(data: fileContentsData, encoding: String.Encoding.utf8.rawValue) else {
                return localizedElementsArray
            }

            let localizedStringsArrayFoo = try regexMatches(pattern: localizedRegex, string: fileContentsString as String)
            localizedStringsArrayFoo.forEach({
                var ItemArray = [String]()
                for index in 1..<$0.numberOfRanges {
                    let testRange = $0.rangeAt(index)
                    if testRange.location != NSNotFound && testRange.location + testRange.length <= fileContentsString.length {
                        ItemArray.append(fileContentsString.substring(with: testRange))
                    }
                }
                var ItemMap = [String]()
                if ItemArray.count == 1 {
                    // Localization without comment, nothing to do
                    localizedElementsArray[ItemArray.first!] = ItemMap
                } else if ItemArray.count == 2 {
                    // Localization with comment, append comment
                    // Check if previously there were comments
                    if localizedElementsArray[ItemArray.first!] != nil {
                        // Add only unique comments
                        if (!localizedElementsArray[ItemArray.first!]!.contains(ItemArray[1])) {
                            localizedElementsArray[ItemArray.first!]!.append(ItemArray[1])
                        }
                    } else {
                        ItemMap.append(ItemArray[1])
                        localizedElementsArray[ItemArray.first!] = ItemMap
                    }
                } else {
                    // We shouldn't get more than 2 items, but if we do, we ignore the entry for safety
                }
            })
        } catch {}
        return localizedElementsArray
    }

    //MARK: Regex

    func regexWithPattern(pattern: String) throws -> NSRegularExpression {
        var safeRegex = regularExpresions
        if let regex = safeRegex[pattern] {
            return regex
        }
        else {
            do {
                let currentPattern: NSRegularExpression
                currentPattern =  try NSRegularExpression(pattern: pattern, options:NSRegularExpression.Options.caseInsensitive)
                safeRegex.updateValue(currentPattern, forKey: pattern)
                regularExpresions = safeRegex
                return currentPattern
            }
            catch {
                throw GenstringsError.Error
            }
        }
    }

    func regexMatches(pattern: String, string: String) throws -> [NSTextCheckingResult] {
        do {
            let internalString = string
            let currentPattern =  try regexWithPattern(pattern: pattern)
            // NSRegularExpression accepts Swift strings but works with NSString under the hood. Safer to bridge to NSString for taking range.
            let nsString = internalString as NSString
            let stringRange = NSMakeRange(0, nsString.length)
            let matches = currentPattern.matches(in: internalString, options: [], range: stringRange)
            return matches
        }
        catch {
            throw GenstringsError.Error
        }
    }

    //MARK: File manager

    func fetchFilesInFolder(rootPath: URL) -> [URL] {
        var files = [URL]()
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: rootPath as URL, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            for urlPath in directoryContents {
                let stringPath = urlPath.path
                let lastPathComponent = urlPath.lastPathComponent
                let pathExtension = urlPath.pathExtension
                var isDir : ObjCBool = false
                if fileManager.fileExists(atPath: stringPath, isDirectory:&isDir) {
                    if isDir.boolValue {
                        if !excludedFolderNames.contains(lastPathComponent) {
                            let dirFiles = fetchFilesInFolder(rootPath: urlPath)
                            files.append(contentsOf: dirFiles)
                        }
                    } else {
                        if acceptedFileExtensions.contains(pathExtension) && !excludedFileNames.contains(lastPathComponent)  {
                            files.append(urlPath)
                        }
                    }
                }
            }
        } catch {}
        return files
    }

}

let genStrings = GenStrings()
if CommandLine.arguments.count > 1 {
    let path = CommandLine.arguments[1]
    genStrings.perform(path: path)
} else {
    genStrings.perform()
}