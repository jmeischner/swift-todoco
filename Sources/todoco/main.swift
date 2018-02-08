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

    var questions = [String: Answer]()

    do {
      questions = try Questions(questions: [
        "name": Question(text: "What's your name?"),
        "project": Question(text: "Whats the name of the project?", type: .text, defaultAnswer: folderName),
        "useGitignore": Question(text: "Do you want to use the .gitignore?", type: .bool, defaultAnswer: false)
    ]).ask() } catch QuestionError.notPossibleToReadLine {
      print("Error: It was not possible to read the line.".red)
    }

    let todoProject = ToDoCoProject(name: questions["project"]!.text(), author: questions["name"]!.text())
    let todoFiles = ToDoCoFiles(useGitignore: questions["useGitignore"]!.bool())
    let config: ToDoCoConfig = ToDoCoConfig(project: todoProject, files: todoFiles)
    do {
      try ToDoCoConfigWriter.write(toPath: path, config: config)
    } catch ToDoCoConfigError.configFileAlreadyExist {
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
    } catch ToDoCoConfigError.directoryIsNoToDoCoProject {
      print("Info: No \(ToDoCoNames.configFile.rawValue) found at '\(path)', thus use default configuration.".yellow)
    }

    print(config.toYaml())
  }
}

main.run()
