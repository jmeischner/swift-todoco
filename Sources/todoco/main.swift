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
}

main.run()
