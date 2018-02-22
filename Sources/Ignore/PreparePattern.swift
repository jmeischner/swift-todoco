import Foundation

struct GlobCase {
    let find: String
    let replace: String
}

let containsPattern = "Pattern/|/Pattern$|/Pattern/|Pattern$"

let cases = [
    // One star between slashes
    GlobCase(
        find: "\\*(?<!\\*{2})(?!\\*)((?<=/\\*)(?=/)|(?<=\\A\\*)(?=$)|(?<=\\A\\*)(?=/))",
        replace: "(/|\\\\A)[^/]*(/|$)"
    ),
    // One Star Anywhere in Path except between two slashes
    GlobCase(
        find: "\\*(((?<![\\*/]\\*)(?![\\*]))|(?<![\\*]\\*)(?![\\*/]))(?<!\\(/\\|\\\\A\\)\\[\\^/\\]\\*)",
        replace: "([^/]*)"
    ),
    // Two Stars
    GlobCase(
        find: "\\*{2}(?<!\\*{3})(?!\\*)((?<=/\\*{2})(?=/)|(?<=\\A\\*{2})(?=$)|(?<=/\\*{2})(?=$)|(?<=\\A\\*{2})(?=/))",
        replace: "(/|\\\\A).*(/|$)"
    )
]

/**
Replaces **stars** inside an ignore string with
the corresponding regex pattern.
*/
func buildGlobPattern(pattern: inout NSMutableString, find: String, template: String) throws {
    guard let regex = try? NSRegularExpression(pattern: find) else {
        throw IgnoreError.noValidPattern
    }

    regex.replaceMatches(in: pattern, range: NSMakeRange(0, pattern.length), withTemplate: template)
}

//ToDo: Throw error when pattern has something like *** included
func transform(glob: String) throws -> NSRegularExpression {
    var result = NSMutableString(string: glob)

    if !result.contains("/") {
        result = NSMutableString(string: containsPattern.replacingOccurrences(of: "Pattern", with: glob))
    }

    for globcase in cases {
        try buildGlobPattern(pattern: &result, find: globcase.find, template: globcase.replace)
    }

    guard let regex = try? NSRegularExpression(pattern: "\\A\(result)") else {
        throw IgnoreError.noValidPattern
    }

    return regex
}

func escape(glob: String) -> String {
    var result = glob

    if result.hasPrefix("\\") {
        result = String(result.dropFirst())
    }

    if result.hasPrefix("/") {
        result = String(result.dropFirst())
    }

    result = result.replacingOccurrences(of: ".", with: "\\.")

    return result
}

func checkNegationPattern(negation: String, pattern: [NSRegularExpression]) throws -> [NSRegularExpression] {

    var result = pattern
    let path = String(negation.dropFirst())

    for index in 0..<pattern.count {

        if pattern[index].numberOfMatches(in: path, range: NSMakeRange(0, path.count)) > 0 {
            let negPattern = escape(glob: path)
            let transformed = try transform(glob: negPattern)
            let newPattern = "(?!(\(transformed.pattern)))(\(pattern[index].pattern))"
            guard let newRegex = try? NSRegularExpression(pattern: newPattern) else {
                throw IgnoreError.noValidPattern
            }
            result[index] = newRegex
        }
    }

    return result
}

func prepare(pattern: [String]) throws -> [NSRegularExpression] {

    var result = [NSRegularExpression]()

    for pat in pattern {

        if pat.hasPrefix("!") {
            result = try checkNegationPattern(negation: pat, pattern: result)
        } else {
            let escaped = escape(glob: pat)
            let transformed =  try transform(glob: escaped)
            result.append(transformed)
        }
    }

    return result
}
