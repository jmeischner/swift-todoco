import Commander
import Regex
import Foundation

let main = Group {
  $0.command("init",
    Option("path", default: ".", description: "Path to the new todoco project."),
    description: "Initialize a new todoco project."
  ) { path in
    initToDoCoProject(atPath: path)
  }

  $0.command("list",
    Option("path", default: ".", description: "Path to the new todoco project.")
  ) { path in
    listToDos(atPath: path)
  }

  $0.command("test") {
    let test = try! NSRegularExpression(pattern: ".*(?<=todo:?\\s)(?<todo>.*)$", options: [.caseInsensitive])
    let testString = "// Todo: Hallo Welt"

    if #available(OSX 10.13, *) {
      let matches = test.matches(in: testString, range: NSMakeRange(0, testString.count))
      let todo = matches[0].range(withName: "todo")
      let swiftRangeTodo = Range(todo, in: testString)

      // Todo Line number, idee: Vorher separate by \n und dann durch gehen und Count machen bis match kommt
      if let range = swiftRangeTodo {
        print(testString[range])
      }
    }
  }
}

main.run()
