import Foundation
import ToDoCoConfig
import ToDo
import Ignore

public class ToDoCoReader {
    let ignore: ToDoCoIgnore

    public init(ignore: ToDoCoIgnore) {
        self.ignore = ignore
    }

    public func read() throws -> [ToDo] {

        var result = [ToDo]()

        let files = try ignore.files()

        for file in files {
            // todo: don't try to read binaries, implement better handling!
            let tryContent = try? String(contentsOfFile: file)

            if let content = tryContent {

                let lines = content.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }

                for (index, line) in lines.enumerated() {
                    let match = ToDo.pattern.firstMatch(in: line, range: NSMakeRange(0, line.count))
                    if let todoMatch = match {
                        if #available(OSX 10.13, *) {
                            let todoRange = Range(todoMatch.range(withName: "todo"), in: line)
                            if let range = todoRange {
                                let text = String(line[range])
                                let linenumber = UInt(index + 1)
                                let todo = ToDo(text: text, line: linenumber, file: file)
                                result.append(todo)
                            }
                        }
                        // Todo: Implement 'else' case
                    }
                }
            }
        }

        return result
    }
}
