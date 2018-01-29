import ToDoCoConfig
import Commander

let main = Group {
  $0.command("init",
    Option("path", default: ".", description: "Path to the new todoco project."),
    description: "Initialize a new todoco project."
  ) { path in

    let config: ToDoCoConfig = ToDoCoConfig()
    do {
      try ToDoCoConfigWriter.write(toPath: path, config: config)
    } catch ToDoCoConfigError.ConfigFileAlreadyExist {
      print("Error: '\(path)' seems to be already a todoco project.".red)
    }
  };

  $0.command("show",
    Option("path", default: ".", description: "Path to the new todoco project."),
    description: "Initialize a new todoco project."
  ) { path in
    var config: ToDoCoConfig = ToDoCoConfig()

    do {
      config = try ToDoCoConfigReader.readConfigFile(atPath: path)
    } catch ToDoCoConfigError.DirectoryIsNoToDoCoProject {
      print("Info: No \(ToDoCoNames.configFile.rawValue) found at '\(path)', thus use default configuration.".yellow)
    }

    print(config.toYaml())
  }
}

main.run()