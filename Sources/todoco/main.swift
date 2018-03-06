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
    Flag("debug", default: false, flag: "d", description: "Measure time to extract ToDos."),
    description: "List the ToDos of the current project."
  ) { path, files, debug in

    let start = Date()

    if files {
      listFileWhichAreNotIgnored(atPath: path)
    } else {
      listToDos(atPath: path)      
    }

    let end = Date()

    if debug {
      if #available(OSX 10.12, *) {
        var time = DateInterval(start: start, end: end)
        let sek = (time.duration * 100).rounded() / 100
        print()
        print("Duration: ".green + "\(sek)s".bold)
      } else {
        print("Start: ".green + "\(start)".bold)
        print("End: ".green + "\(end)".bold)
      }
    }
  }
}

main.run()
