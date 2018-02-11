import Foundation

let containsPattern = "Pattern\\/|\\/Pattern$|\\/Pattern\\/"
let oneStarPatter = "(/|\\\\A)[^/]*(/|$)"
let twoStarPatter = "(/|\\\\A).*(/|$)"

// Matches also the symbols before and after the star(s)
let checkForTwoStarPattern = try! NSRegularExpression(pattern: "([^\\*]|\\A)\\*{2}([^\\*]|$)")
let checkForOneStarPattern = try! NSRegularExpression(pattern: "([^\\*]|\\A)\\*{1}([^\\*]|$)")

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

//Throw error when pattern has something like *** included
func transform(glob: String) -> NSRegularExpression {
    var result = NSMutableString(string: glob)

    if !result.contains("/") {
        result = NSMutableString(string: containsPattern.replacingOccurrences(of: "Pattern", with: glob))
    }

    checkForOneStarPattern.replaceMatches(in: result, range: NSMakeRange(0, result.length), withTemplate: oneStarPatter)
    checkForTwoStarPattern.replaceMatches(in: result, range: NSMakeRange(0, result.length), withTemplate: twoStarPatter)
    print(result)
    let regex = try! NSRegularExpression(pattern: "\\A\(result)")

    return regex
}

func escape(glob: String) -> String {
    var result = glob

    if result.hasPrefix("/") {
        result = String(result.dropFirst())
    }

    result = result.replacingOccurrences(of: ".", with: "\\.")

    return result
}

func checkNegationPattern(negation: String, pattern: [NSRegularExpression]) -> [NSRegularExpression] {

    var result = pattern
    let path = String(negation.dropFirst())

    for index in 0..<pattern.count {
        if pattern[index].numberOfMatches(in: path, range: NSMakeRange(0, result.count)) > 0 {
            let newPattern = "(?!\(path))\(pattern[index].pattern)"
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
