import Foundation

public class ToDo {
    // Todo: Match only in comments for all languages
    public static let pattern = try! NSRegularExpression(
        pattern: ".*(?<=todo:\\s?)(?<todo>.*)$",
        options: [.caseInsensitive]
    )

    public let file: String
    public let line: UInt
    public let text: String

    // Todo: Take the next few lines for more context
    // public let context: [String] or String

    public init(text: String, line: UInt, file: String) {
        self.text = text
        self.line = line
        self.file = file
    }
}
