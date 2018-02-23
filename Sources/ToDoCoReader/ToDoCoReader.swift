import Foundation
import ToDoCoConfig
import ToDo
import Ignore

public class ToDoCoReader {
    let config: ToDoCoConfig

    public init(config: ToDoCoConfig) {
        self.config = config
    }

    public func read() throws -> [ToDo] {

        // todo: Work with .todocoignore + .gitignore or patterns in .todococonfig + .gitignore
        let files = try pathsFrom(ignoreFile: ".gitignore")

        var result = [ToDo]()
        
        for file in files {
            let content = try String(contentsOfFile: file)
            let lines = content.split(separator: "\n", omittingEmptySubsequences: false).map{ String($0) }

            for (index, line) in lines.enumerated() {
                let matches = ToDo.pattern.matches(in: line, range: NSMakeRange(0, line.count))
                if matches.count > 0 {
                    if #available(OSX 10.13, *) {
                        let todoRange = Range(matches[0].range(withName: "todo"), in: line)
                        if let range = todoRange {
                            let text = String(line[range])
                            let linenumber = UInt(index + 1)
                            let todo = ToDo(text: text, line: linenumber, file: file)
                            result.append(todo)
                        }
                    }
                }
            }
        }
        return result
    }
}
