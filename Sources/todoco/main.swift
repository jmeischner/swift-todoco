import Commander
import Regex
import Foundation

// Todo: Increase Performance

let main = Group {
  $0.command("init",
    Option("path", default: ".", description: "Path to the new todoco project."),
    description: "Initialize a new todoco project."
  ) { path in
    initToDoCoProject(atPath: path)
  }

  $0.command("list",
    Option("path", default: ".", description: "Path to the new todoco project."),
    description: "List the ToDos of the current project."
  ) { path in
    listToDos(atPath: path)
  }
}

main.run()
