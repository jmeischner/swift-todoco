import Regex

public class ToDo {
    public static let pattern = Regex("(?=todo:\\s?).*$", options: [.ignoreCase])
    let file: String
    let line: UInt
    let text: String

    public init(text: String, line: UInt, file: String) {
        self.text = text
        self.line = line
        self.file = file
    }
}
