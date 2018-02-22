import Foundation
import Regex

/**
Function to get all paths not ignored by an
ignore file (e.g. .gitignore) at the specified
path.

@param ignoreFile Path to the ignore file
@returns Paths to all not ignored files
*/
public func pathsFrom(ignoreFile: String) throws -> [String] {

    guard let ignoreContent = try? String(contentsOfFile: ignoreFile) else {
        throw IgnoreError.noIgnoreFileFound
    }

    var lines = ignoreContent.split(separator: "\n").map {String($0)}

    // Todo: Consider changing this behavior to a switchable function argument
    lines.append(".git")

    guard let root = URL(fileURLWithPath: ignoreFile).baseURL?.relativePath else {
        throw IgnoreError.noBaseURLExtractable
    }

    return try pathsFrom(root: root, ignorePattern: lines)
}

/**
Returns the paths to all files not ignored
by the specified patterns, starting from 
given path to root

@param root Root path from which the pattern starts
@param ignorePattern
@returns Paths to all not ignored files
*/
public func pathsFrom(root: String, ignorePattern paths: [String]) throws -> [String] {
    let optEnumerator = FileManager.default.enumerator(atPath: root)
    let pattern = try prepare(pattern: paths)

    return glob(pattern: pattern, enumerator: optEnumerator)
}

func glob(pattern: [NSRegularExpression], enumerator: FileManager.DirectoryEnumerator?) -> [String] {
    var result = [String]()

    if let enumer = enumerator {
        while let path = enumer.nextObject() {
            if let file = path as? String {
                var matches = false
                let fileUrl = URL(fileURLWithPath: file)

                for index in 0..<pattern.count {
                    if pattern[index].numberOfMatches(in: file, range: NSMakeRange(0, file.count)) > 0 {
                        matches = true
                    }
                }

                if !matches {
                    if #available(OSX 10.11, *) {
                        if !fileUrl.hasDirectoryPath {
                            result.append(file)
                        }
                    } else {
                        result.append(file)
                    }
                } else {
                    if #available(OSX 10.11, *) {
                        if fileUrl.hasDirectoryPath {
                           enumer.skipDescendants()
                        }
                    }
                }
            }
        }
    }
    return result
}
