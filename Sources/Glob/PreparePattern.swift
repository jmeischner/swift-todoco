import Foundation

let containsPattern = "Pattern/|/Pattern$|/Pattern/|Pattern$"

// Matches also the symbols before and after the star(s)
let checkForTwoStarPattern = try! NSRegularExpression(pattern: "([^\\*]|\\A)\\*{2}([^\\*]|$)")

// We need one start between slashes pattern and one star as part on an name e.g. *.sublime-* vs test/*/bla.html
let checkForOneStarPattern = try! NSRegularExpression(pattern: "([^\\*]|\\A)\\*{1}([^\\*]|$)")

struct GlobCase {
    let find: String
    let replace: String
}

let cases = [
    // One Star between Slashes
    GlobCase(find: "\\*(?<!\\*{2})(?!\\*)((?<=/\\*)(?=/)|(?<=\\A\\*)(?=$)|(?<=\\A\\*)(?=/))", replace: "(/|\\\\A)[^/]*(/|$)"),
    // Anywhere in Path
    GlobCase(find: "\\*(((?<![\\*/]\\*)(?![\\*]))|(?<![\\*]\\*)(?![\\*/]))(?<!\\(/\\|\\\\A\\)\\[\\^/\\]\\*)", replace: "([^/]*)"),
    // Two Stars
    GlobCase(find: "\\*{2}(?<!\\*{3})(?!\\*)((?<=/\\*{2})(?=/)|(?<=\\A\\*{2})(?=$)|(?<=/\\*{2})(?=$)|(?<=\\A\\*{2})(?=/))", replace: "(/|\\\\A).*(/|$)")
]

/**
Pattern for string without slash:
"\APatter\/|\/Patter$|\/Patter\/"

Pattern for string with one *
Replace * with [^\/]*

Pattern for string with **
Replace ** with .*

In general:
Escape Slashes with \/ and
dots with \.
If Match is dir --> skipDescendants()

Pattern for negate strings
Collect dismissed files and try
if negate pattern matches this (files only!)

------
Wenn eins der Exclude Patterns ein include Pattern
matched, dann schreib das include Pattern mit
(?!....) davor! 
Bzw:
.gitignore scheint so zu funtkionieren, 
dass er bei einem negate pattern nur prüft
ob bisherige pattern dies ignorieren würden
*/

func buildPattern(pattern: inout NSMutableString, find: String, template: String) {
    let regex = try! NSRegularExpression(pattern: find)

    regex.replaceMatches(in: pattern, range: NSMakeRange(0, pattern.length), withTemplate: template)
}

//ToDo: Throw error when pattern has something like *** included
func transform(glob: String) -> NSRegularExpression {
    var result = NSMutableString(string: glob)

    if !result.contains("/") {
        result = NSMutableString(string: containsPattern.replacingOccurrences(of: "Pattern", with: glob))
    }

    for globcase in cases {
        buildPattern(pattern: &result, find: globcase.find, template: globcase.replace)
    }

    let regex = try! NSRegularExpression(pattern: "\\A\(result)")

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

func checkNegationPattern(negation: String, pattern: [NSRegularExpression]) -> [NSRegularExpression] {

    // Todo: consider how/when the negation pattern can be transformed to regex
    var result = pattern
    let path = String(negation.dropFirst())

    for index in 0..<pattern.count {
        print(pattern[index])
        print(path)
        if pattern[index].numberOfMatches(in: path, range: NSMakeRange(0, path.count)) > 0 {
            let negPattern = escape(glob: path)
            let transformed = transform(glob: negPattern)
            let newPattern = "(?!(\(transformed.pattern)))(\(pattern[index].pattern))"
            print(newPattern)
            result[index] = try! NSRegularExpression(pattern: newPattern)
        }
    }

    return result
}

func prepare(pattern: [String]) -> [NSRegularExpression] {

    var result = [NSRegularExpression]()

    for pat in pattern {

        if pat.hasPrefix("!") {
            result = checkNegationPattern(negation: pat, pattern: result)
        } else {
            let escaped = escape(glob: pat)
            let transformed = transform(glob: escaped)
            result.append(transformed)
        }
    }

    return result
}
