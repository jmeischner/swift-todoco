import ToDoCoConfig
import CLQuestions
import Foundation

func askQuestions(atPath: String) -> [String: Answer] {
  let folderName = URL(fileURLWithPath: atPath).lastPathComponent

  var questions = [String: Answer]()

  do {
    questions = try Questions(questions: [
      "name": Question(text: "What's your name?"),
      "project": Question(text: "Whats the name of the project?", type: .text, defaultAnswer: folderName),
      "useGitignore": Question(text: "Do you want to use the .gitignore?", type: .bool, defaultAnswer: false)
    ]).ask()
  } catch QuestionError.notPossibleToReadLine {
    print("Error: It was not possible to read the line.".red)
  } catch {
    print(error)
  }

  return questions
}

func createToDoCoConfig(atPath: String, answers: [String: Answer]) {
  let todoProject = ToDoCoProject(name: answers["project"]!.text(), author: answers["name"]!.text())
  let todoFiles = ToDoCoFiles(useGitignore: answers["useGitignore"]!.bool())
  let config: ToDoCoConfig = ToDoCoConfig(project: todoProject, files: todoFiles)
  do {
    try ToDoCoConfigWriter.write(toPath: atPath, config: config)
  } catch ToDoCoConfigError.configFileAlreadyExist {
    print("Error: '\(atPath)' seems to be already a todoco project.".red)
  } catch {
    print(error)
  }
}

func createToDoCoIgnore(atPath: String) {
  
}

func initToDoCoProjectWithToDoCoConfig(atPath: String) {
  let answers = askQuestions(atPath: atPath)
  createToDoCoConfig(atPath: atPath, answers: answers)
}

func initToDoCoProject(atPath: String) {

  do {
    try ToDoCoIgnore.writeTemplate(atRoot: atPath)
  } catch ToDoCoConfigError.ignoreFileCanNotBeWritten {
    print("Error: It was not possible to write \(ToDoCoNames.ignoreFile).".red)
  } catch {
    print("Error: \(error)".red)
  }
  
}
