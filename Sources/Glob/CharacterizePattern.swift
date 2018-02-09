import Foundation

struct Pattern {
    let type: PatternType
    let value: String
    let negate: Bool
}

enum PatternType {
    case contains
    case glob
    case startsWith
}

func getGlobPatternType(pattern: String) -> PatternType {

    if pattern.contains("*") {
        return .glob
    }

    if !pattern.contains("/") {
        return .contains
    }

    return .startsWith
}

func characterizeGlob(_ glob: [String]) -> [Pattern] {
    var result = [Pattern]()

    for pattern in glob {
        let type = getGlobPatternType(pattern: pattern)
        var value = pattern

        if case .startsWith = type {
            if value.hasPrefix("/") {
                value.removeFirst()
            }
        }

        let negate = pattern.hasPrefix("!")

        result.append(
            Pattern(
                type: type,
                value: value,
                negate: negate
            )
        )
    }

    return result
}
