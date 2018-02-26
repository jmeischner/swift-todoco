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
    Option("path", default: ".", flag: "p", description: "Path to the new todoco project."),
    Flag("files", default: false, flag: "f", description: "List all files which are not ignored."),
    description: "List the ToDos of the current project."
  ) { path, files in
    if files {
      listFileWhichAreNotIgnored(atPath: path)
    } else {
      listToDos(atPath: path)
    }
  }
}

main.run()
