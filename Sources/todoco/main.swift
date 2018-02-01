import ToDoCoConfig
import CLQuestions
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
  }

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

  $0.command("test") {
    let q1 = Question<String>(text: "Wie heißt du?", type: .text, defaultAnswer: "Peter")
    let name = q1.ask()

    let q2 = Question<Bool>(text: "Bist du groß?", type: .bool)
    let groß = q2.ask()

    if groß ?? false {
      print("Du Riese")
    }

    print("Hallo \(name!)!")
  }
}

main.run()
