import ToDoCoConfig
import CLQuestions
import Commander
import Foundation

let main = Group {
  $0.command("init",
    Option("path", default: ".", description: "Path to the new todoco project."),
    description: "Initialize a new todoco project."
  ) { path in

    let folderName = URL(fileURLWithPath: path).lastPathComponent

    let name = Question(
      text: "What's your name?",
      type: .text
    ).ask()

    let project = Question(
      text: "What's the name of this project?",
      type: .text,
      defaultAnswer: folderName
    ).ask()

    let useGitignore = Question(
      text: "Do you want to use the .gitignore?",
      type: .bool,
      defaultAnswer: false
    ).ask()

    let todoProject = ToDoCoProject(name: project!.text(), author: name!.text())
    let todoFiles = ToDoCoFiles(useGitignore: useGitignore!.bool())

    let config: ToDoCoConfig = ToDoCoConfig(project: todoProject, files: todoFiles)
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
}

main.run()
