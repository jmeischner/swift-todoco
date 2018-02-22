import Foundation
import ToDoCoConfig
import ToDo
import Ignore

public class ToDoCoReader {
    let config: ToDoCoConfig

    public init(config: ToDoCoConfig) {
        self.config = config
    }

    public func read() -> [ToDo] {

        let files = try! pathsFrom(ignoreFile: ".gitignore")

        var result = [ToDo]()
        // todo: blabla
        for file in files {
            let content = try! String(contentsOfFile: file)
            print(file)
            print(ToDo.pattern.allMatches(in: content))
        }

        return result
    }
}
