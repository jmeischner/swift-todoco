import Regex

public class ToDo {
    public static let pattern = try! NSRegularExpression(pattern: ".*(?<=todo:?\\s)(?<todo>.*)$", options: [.caseInsensitive])
    let file: String
    let line: UInt
    let text: String

    public init(text: String, line: UInt, file: String) {
        self.text = text
        self.line = line
        self.file = file
    }
}
