import ToDoCoConfig
import CLQuestions
import Commander
import Foundation
import Glob

let main = Group {
  $0.command("init",
    Option("path", default: ".", description: "Path to the new todoco project."),
    description: "Initialize a new todoco project."
  ) { path in
    initToDoCoProject(atPath: path)
  }

  $0.command("show",
    Option("path", default: ".", description: "Path to the new todoco project."),
    description: "Initialize a new todoco project."
  ) { path in
    var config: ToDoCoConfig = ToDoCoConfig()

    do {
      config = try ToDoCoConfigReader.readConfigFile(atPath: path)
    } catch ToDoCoConfigError.directoryIsNoToDoCoProject {
      print("Info: No \(ToDoCoNames.configFile.rawValue) found at '\(path)', thus use default configuration.".yellow)
    }

    print(config.toYaml())
  }

  $0.command("test") {
    let files = glob(root: ".", paths: [".git", ".build", "/Tests/", "/**/Glob.swift"])

    for file in files {
      print(file)
    }
  }
}

main.run()
