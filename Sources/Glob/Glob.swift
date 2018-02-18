import Foundation
import Regex

/**

*/
public func glob(root: String, paths: [String]) throws -> [String] {

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
