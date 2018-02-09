import Foundation

enum Match {
    case directory
    case file
    case none
}

func glob(_ glob: [Pattern], matches path: String) -> Match {

    for pattern in glob {
        switch pattern.type {
        case .contains:
            let match = checkContains(pattern: pattern, path: path)
            if case .none = match {} else {
                return match
            }
        case .startsWith:
            let match = checkStartsWith(pattern: pattern, path: path)
            if case .none = match {} else {
                return match
            }
        case .glob:
            let match = checkGlob(pattern: pattern, path: path)
            if case .none = match {} else {
                return match
            }
        }
    }

    return .none
}

func checkContains(pattern: Pattern, path: String) -> Match {

    let pathURL = URL(fileURLWithPath: path)

    if path.contains(pattern.value) && !pattern.negate {
        if pathURL.isFileURL {
            return .file
        } else {
            return .directory
        }
    } else {
        return .none
    }
}

func checkStartsWith(pattern: Pattern, path: String) -> Match {
    let pathURL = URL(fileURLWithPath: path)

    if path.hasPrefix(pattern.value) && !pattern.negate {
        if pathURL.isFileURL {
            return .file
        } else {
            return .directory
        }
    } else {
        return .none
    }
}

func checkGlob(pattern: Pattern, path: String) -> Match {

    let pathURL = URL(fileURLWithPath: path).pathComponents
    let patternURL = URL(fileURLWithPath: pattern.value).pathComponents

    var match = false

    return .none
}
