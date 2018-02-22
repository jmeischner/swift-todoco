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
            do {
                let content = try String(contentsOfFile: file)
                let lines = content.split(separator: "\n")

                for (index, line) in lines.enumerate() {
                    
                }   
            }


            
            print(file)
            print(ToDo.pattern.allMatches(in: content))
        }

        return result
    }
}


if #available(OSX 10.13, *) {
      let matches = test.matches(in: testString, range: NSMakeRange(0, testString.count))
      let todo = matches[0].range(withName: "todo")
      let swiftRangeTodo = Range(todo, in: testString)

      // Todo Line number, idee: Vorher separate by \n und dann durch gehen und Count machen bis match kommt
      if let range = swiftRangeTodo {
        print(testString[range])
      }
    }
