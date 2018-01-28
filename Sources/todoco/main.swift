import ToDoCoConfig
import Commander

let main = Group {
  $0.command("init",
    Option("path", default: ".", description: "Path to the new todoco project."),
    description: "Initialize a new todoco project."
  ) { path in

    var config: ToDoCoConfig = ToDoCoConfig()

    do {
      if let tryConfig = try ToDoCoConfigReader.readConfigFile(at: path) {
        config = tryConfig
      }
    } catch ToDoCoConfigError.ProjectDirectoryDoesNotExist {
      print("Info: No \(ToDoCoNames.configFile.rawValue) found at '\(path)', thus use default configuration.".yellow)
    }

    print(config.project.author)
  }
}

main.run()