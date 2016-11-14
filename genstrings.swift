#!/usr/bin/swift

import Foundation

class GenStrings {

    var str = "Hello, playground"
    let fileManager = FileManager.default
    let acceptedFileExtensions = ["swift"]
    let excludedFolderNames = ["Carthage"]
    let excludedFileNames = ["genstrings.swift"]
    var regularExpresions = [String:NSRegularExpression]()

    let localizedRegex = "(?<=\")([^\"]*)(?=\".(localized|localizedFormat))|(?<=(Localized|NSLocalizedString)\\(\")([^\"]*?)(?=\")"

    enum GenstringsError: Error {
        case Error
    }

    // Performs the genstrings functionality
    func perform(path: String? = nil) {
        let directoryPath = path ?? fileManager.currentDirectoryPath
        let rootPath = URL(fileURLWithPath:directoryPath)
        let allFiles = fetchFilesInFolder(rootPath: rootPath)
        // We use a set to avoid duplicates
        var localizableStrings = Set<String>()
        for filePath in allFiles {
            let stringsInFile = localizableStringsInFile(filePath: filePath)
            localizableStrings = localizableStrings.union(stringsInFile)
        }
        // We sort the strings
        let sortedStrings = localizableStrings.sorted(by: { $0 < $1 })
        var processedStrings = String()
        for string in sortedStrings {
            processedStrings.append("\"\(string)\" = \"\(string)\"; \n")
        }
        print(processedStrings)
    }

    // Applies regex to a file at filePath.
    func localizableStringsInFile(filePath: URL) -> Set<String> {
        do {
            let fileContentsData = try Data(contentsOf: filePath)
            guard let fileContentsString = NSString(data: fileContentsData, encoding: String.Encoding.utf8.rawValue) else {
                return Set<String>()
            }
            let localizedStringsArray = try regexMatches(pattern: localizedRegex, string: fileContentsString as String).map({fileContentsString.substring(with: $0.range)})
            return Set(localizedStringsArray)
        } catch {}
        return Set<String>()
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